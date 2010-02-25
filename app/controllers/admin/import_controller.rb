require 'map_fields'
class Admin::ImportController < Admin::BaseController
  map_fields :create_user, User.new.attributes.keys
  before_filter :models, :only => :index

  def index; end
  
  def create_user
    create_model(User,'email')
  end

  private

  def models
    @models = ['user']
  end

  def create_model(klass, uniq_field, &block)
    if fields_mapped?
      created = 0
      updated = 0
      count = 0
      errors = []
      fields = self.class.read_inheritable_attribute("map_fields_fields_#{params[:action]}")
      mapped_fields.each do |row|
        if block_given?
          attributes = yield(row) || {}
        else
          attributes = {} 
          fields.each_with_index do |attribute,i|
            attributes[attribute.to_sym] = row[i] if row[i]
          end
        end
        uniq_field_index = fields.index(uniq_field)
        if row[uniq_field_index] != nil && object = klass.send("find_by_#{uniq_field}",row[uniq_field_index])
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
        count+=1
      end

      logger.debug("\033[01;33m#{count}\033[0m")
      flash[:notice] = t('import.create.success', :model => t(klass.to_s.underscore, :count => created), :nb => created) if created != 0
      flash[:warning] = t('import.update.success', :model => t(klass.to_s.underscore, :count => updated), :nb => updated) if updated != 0
      errors_count = errors.flatten.size
      flash[:error] = t('import.failed.errors', :model => t(klass.to_s.underscore, :count => errors_count), :nb => errors_count) unless errors.empty?
      redirect_to(:action => :index)
    else
      render(:action => 'create')
    end
    rescue MapFields::InconsistentStateError
      flash[:error] = t('import.retry')
      redirect_to(:action => :index)
    rescue MapFields::MissingFileContentsError
      flash[:error] = t('import.give_file')
      redirect_to(:action => :index)
  end
end
