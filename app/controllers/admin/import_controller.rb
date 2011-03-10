require 'map_fields'
class Admin::ImportController < Admin::BaseController
  UPLOAD_PROGRESS_FILE = File.join(Rails.root,'tmp','import_progress.txt')
  before_filter :save_import_set, :except => :index
  map_fields :create_user, User.new.attributes.keys
  before_filter :models, :only => :index

  def index; end

  def create_user
    create_model(User,'email')
  end

  def progress
    if File.exist?(UPLOAD_PROGRESS_FILE)
      render :text => File.open(UPLOAD_PROGRESS_FILE,'r').read
    else
      render :nothing => true
    end
  end

  private

  def models
    @models = ['user']
  end

  def create_model(klass, uniq_field = nil, &block)
    File.open(UPLOAD_PROGRESS_FILE, 'w') {|f| f.write(0) }
    if fields_mapped?
      total = mapped_fields.size
      created = 0
      updated = 0
      errors = []
      methods = self.class.read_inheritable_attribute("map_fields_fields_#{params[:action]}")
      mapped_fields.each do |row|
        logger.debug("\033[01;33m Number : #{row.number} / #{total}\033[0m")

        attributes = ActiveSupport::OrderedHash.new
        methods.each_with_index do |attribute,i|
          exist = params[:fields].values.include?((i+1).to_s)
          attributes[attribute.to_sym] = row[i] if exist
        end

        if block_given?
          attributes = yield(attributes) || {}
        end

        uniq_field_index = methods.index(uniq_field)

        if uniq_field != nil && row[uniq_field_index] != nil && object = klass.send("find_by_#{uniq_field}",row[uniq_field_index])
          if object.update_attributes(attributes)
            updated+=1
          else
            errors << object.errors
            logger.debug("\033[01;33m#{object.errors.inspect}\033[0m")
          end
        else
          object = klass.new(attributes)
          if object.save
            created+=1
          else
            errors << object.errors
            logger.debug("\033[01;33m#{object.errors.inspect}\033[0m")
          end
        end
        File.open(UPLOAD_PROGRESS_FILE, 'w') {|f| f.write((row.number.to_f / total.to_f) * 100.0) } if row.number.modulo(10).zero?
      end

      flash[:notice] = t('import.create.success', :model => t(klass.to_s.underscore, :count => created), :nb => "#{created}/#{total}") if created != 0
      flash[:warning] = t('import.update.success', :model => t(klass.to_s.underscore, :count => updated), :nb => "#{updated}/#{total}") if updated != 0
      errors_count = errors.flatten.size
      flash[:error] = t('import.failed.errors', :model => t(klass.to_s.underscore, :count => errors_count), :nb =>"#{ errors_count}/#{total}") unless errors.empty?
      File.open(UPLOAD_PROGRESS_FILE, 'w') {|f| f.write(100.0) }
      render(:nothing => true)
    else
      render(:action => 'create')
    end
    rescue StandardError => error
      File.open(UPLOAD_PROGRESS_FILE, 'w') {|f| f.write(100.0) }
      render(:text => error.inspect, :status => 500)
  end

  private

  def save_import_set
    @set = ImportSet.find_by_id(params[:set_id])
    if params[:save_set]
      set_attributes = {
        :fields => params[:fields],
        :parser_options => session[:parser_options],
        :ignore_first_row => params[:ignore_first_row],
        :name => params[:set_name]
      }
      if @set = ImportSet.find_by_id(params[:set_id])
        @set.update_attributes(set_attributes)
      else
        @set = ImportSet.create(set_attributes)
      end
    end
  end
end
