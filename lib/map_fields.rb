# coding: utf-8
require (RUBY_VERSION.to_f >= 1.9 ? 'csv' : 'fastercsv')

module MapFields
  VERSION = '1.0.0'
  CsvParser = (RUBY_VERSION.to_f >= 1.9 ? CSV : FasterCSV)

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def map_fields(action, fields, options = {})
      include MapFields::InstanceMethods
      write_inheritable_array("map_fields_fields_#{action}", fields)
      write_inheritable_attribute("map_fields_options_#{action}", options)
      write_inheritable_attribute(:map_fields_actions, []) unless read_inheritable_attribute(:map_fields_actions)
      write_inheritable_attribute(:map_fields_actions, (read_inheritable_attribute(:map_fields_actions) << action).uniq)
      skip_filter :map_fields
      skip_filter :map_fields_cleanup
      before_filter :map_fields, :only =>  read_inheritable_attribute(:map_fields_actions)
      after_filter :map_fields_cleanup, :only =>  read_inheritable_attribute(:map_fields_actions)
    end
  end


  module InstanceMethods
    def map_fields
      default_options = {
        :file_field => 'file',
        :params => []
      }
      options = default_options.merge(
        self.class.read_inheritable_attribute("map_fields_options_#{params[:action]}")
      )
      if session[:map_fields].nil? || params[options[:file_field]]
        session[:map_fields] = {}
        if params[options[:file_field]].blank?
          @map_fields_error = MissingFileContentsError
          return
        end

        file_field = params[options[:file_field]]

        temp_dir = Rails.root.join('tmp', 'imports')
        temp_path = File.join(temp_dir, "map_fields_#{Time.now.to_i}_#{$$}")

        Dir.mkdir(temp_dir) unless File.exists?(temp_dir)
        File.open(temp_path, 'wb') do |f|
          f.write file_field.read
        end

        session[:map_fields][:file] = temp_path
      end

      if params[:fields].nil?
        @rows = []
        parser_options = session[:parser_options] = params[:parser_options].symbolize_keys
        CsvParser.foreach(temp_path, parser_options) do |row|
          @rows << row
          break if @rows.size == 5
        end
        expected_fields = self.class.read_inheritable_attribute("map_fields_fields_#{params[:action]}")
        @fields = ([nil] + expected_fields).inject([]){ |o, e| o << [e, o.size]}
        @parameters = []
        options[:params].each do |param|
          @parameters += ParamsParser.parse(params, param)
        end
      else
        if @set
          @mapped_fields = MappedFields.new(session[:map_fields][:file],
                                            @set.fields,
                                            @set.ignore_first_row,
                                            @set.parser_options)

        else
          if session[:map_fields][:file].nil? || params[:fields].nil?
            session[:map_fields] = nil
            @map_fields_error =  InconsistentStateError
          else
            @mapped_fields = MappedFields.new(session[:map_fields][:file],
                                              params[:fields],
                                              params[:ignore_first_row],
                                              session[:parser_options])
          end
        end
      end
    end

    def mapped_fields
      @mapped_fields
    end

    def fields_mapped?
      raise @map_fields_error if @map_fields_error
      @mapped_fields
    end

    def map_field_parameters(&block)

    end

    def map_fields_cleanup
      if @mapped_fields
        #if session[:map_fields][:file]
        #  File.delete(session[:map_fields][:file])
        #end
        session[:map_fields] = nil
        @mapped_fields = nil
        @map_fields_error = nil
      end
    end
  end

  class MappedFields
    attr_reader :file, :mapping

    def initialize(file, mapping, ignore_first_row, parser_options)
      @file = file
      @parser_options = parser_options
      @mapping = {}
      @ignore_first_row = ignore_first_row
      mapping.each do |k,v|
        @mapping[v.to_i - 1] = k.to_i - 1 unless v.to_i == 0
      end
    end

    def each
      row_number = 1
      CsvParser.foreach(@file,@parser_options) do |csv_row|
        unless row_number == 1 && @ignore_first_row
          row = []
          @mapping.each do |k,v|
            row[k] = csv_row[v]
          end
          row.class.send(:define_method, :number) { row_number }
          yield(row)
        end
        row_number += 1
      end
    end

    def size
      @size = CsvParser.read(@file,@parser_options).size
      @size -= 1 if @ignore_first_row
      return @size
    end

    def close
      File.delete(@file) if File.exists?(@file)
    end
  end

  class InconsistentStateError < StandardError
  end

  class MissingFileContentsError < StandardError
  end

  class ParamsParser
    def self.parse(params, field = nil)
      result = []
      params.each do |key,value|
        if field.nil? || field.to_s == key.to_s
          check_values(value) do |k,v|
            result << ["#{key.to_s}#{k}", v]
          end
        end
      end
      result
    end

    private
    def self.check_values(value, &block)
      result = []
      if value.kind_of?(Hash)
        value.each do |k,v|
          check_values(v) do |k2,v2|
            result << ["[#{k.to_s}]#{k2}", v2]
          end
        end
      elsif value.kind_of?(Array)
        value.each do |v|
          check_values(v) do |k2, v2|
            result << ["[]#{k2}", v2]
          end
        end
      else
        result << ["", value]
      end
      result.each do |arr|
        yield arr[0], arr[1]
      end
    end
  end

  class Runner
    def import(fields, methods, email, klass_name, uniq_field, modify_attributes_method)
      klass = klass_name.constantize
      created = 0
      updated = 0
      errors = []
      total = fields.size
      fields.each do |row|
        attributes = ActiveSupport::OrderedHash.new

        methods.each_with_index do |attribute,i|
          exist = fields.mapping.keys.include?(i)
          attributes[attribute.to_sym] = row[i] if exist
        end

        if modify_attributes_method.present? and klass.respond_to?(modify_attributes_method)
          attributes = klass.send(modify_attributes_method, attributes) || {}
        end

        uniq_field_index = methods.index(uniq_field)

        if uniq_field != nil && row[uniq_field_index] != nil && object = klass.send("find_by_#{uniq_field}",row[uniq_field_index])
          if object.update_attributes(attributes)
            updated+=1
          else
            errors << object.errors
          end
        else
          object = klass.new(attributes)
          if object.save
            created+=1
          else
            errors << object.errors
          end
        end
      end

      fields.close
      UserNotifier.import_finished(email, { :created => created, :total => total, :updated => updated, :errors => errors }).deliver
      rescue StandardError => error
        UserNotifier.import_finished(email, { :created => created, :total => total, :updated => updated, :errors => [error]}).deliver
    end
    handle_asynchronously :import
  end
end
