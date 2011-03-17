require 'ar-extensions'
class ActiveRecord::Base

  def self.get_nested_conditions(args)
    sanitize_sql(args)
  end

  private

  def self.sanitize_sql_from_hash(hsh, table_name = quoted_table_name, klass = self) #:nodoc:
    conditions, values = [], []
    hsh = expand_hash_conditions_for_aggregates(hsh) # introduced in Rails 2.0.2
    hsh.each_pair do |key,val|
      if val.respond_to?( :to_sql )
        conditions << sanitize_sql_by_way_of_duck_typing( val )
        next
      elsif val.is_a?(Hash) # don't mess with ActiveRecord hash nested hash functionality
        if assoc = self.reflections.map(&:last).find { |ref| !(ref.options[:polymorphic]) && (ref.table_name == key.to_s) }
          conditions << assoc.class_name.constantize.get_nested_conditions(val)
        else
          conditions << sanitize_sql_hash_for_conditions({key => val}, table_name)
        end
      else
        sql = nil
        result = ActiveRecord::Extensions.process( key, val, klass )
        if result
          conditions << result.sql
          values.push( result.value ) unless result.value.nil?
        else
          # Extract table name from qualified attribute names.
          attr = key.to_s
          if attr.include?('.')
            table_name, attr = attr.split('.', 2)
            table_name = connection.quote_table_name(table_name)
          end
          # ActiveRecord in 2.3.1 changed the method signature for
          # the method attribute_condition
          if ActiveRecord::VERSION::STRING < '2.3.1'
            conditions << "#{table_name}.#{connection.quote_column_name(attr)} #{attribute_condition( val )} "
          else
            conditions << attribute_condition("#{table_name}.#{connection.quote_column_name(attr)}", val)
          end
          values << val
        end
      end
    end

    conditions = conditions.join( ' AND ' )
    return [] if conditions.size == 1 and conditions.first.empty?
    [ conditions, *values ]
  end
end
