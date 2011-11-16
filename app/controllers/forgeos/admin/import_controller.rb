#coding: utf-8
module Forgeos
  class Admin::ImportController < Admin::BaseController
  include MapFields
    before_filter :save_import_set, :except => :index
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

    def create_model(klass, uniq_field = nil, modify_attributes_method = :modify_import_attributes)
      if fields_mapped?
        runner = MapFields::Runner.new
        runner.import(
          mapped_fields,
          self.class.read_inheritable_attribute("map_fields_fields_#{params[:action]}"),
          current_user.email,
          klass.to_s,
          uniq_field,
          modify_attributes_method
        )
        flash[:notice] = "Un email vous sera envoyé lorsque l'import sera fini"
        redirect_to([forgeos_core, :admin, :import])
      else
        render(:action => 'create')
      end
      #rescue StandardError => error
      #  render(:text => error.inspect, :status => 500)
    end

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
end
