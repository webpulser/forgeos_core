module Forgeos
  class Admin::BaseController < Forgeos::ApplicationController
    layout 'forgeos/admin'
    helper "forgeos/admin/base"
    before_filter :login_required, :edition_locale, :except => [:notifications, :url]
    skip_after_filter :log_visit
    protect_from_forgery

  private
    # decent_exposure remplacement (waiting for decent_exposure v2.0)
    def self.expose(name, options = {}, &block)
      model = options[:model] || name.camelize.constantize
      define_method(name) do
        resource_name = "@#{name}".to_sym
        resource = self.instance_variable_get(resource_name)
        return resource if resource
        unless resource = self.instance_variable_set(resource_name, (params[:id] ? model.find_by_id(params[:id]) : model.new))
          flash.alert = t(:not_exist, :scope => [name]).capitalize
          return redirect_to([forgeos_core, :admin, name.to_s.pluralize.to_sym])
        end

        resource.assign_attributes(params[name], :as => :admin) if params[name]

        resource
      end

      helper_method name
    end

    def login_required
      return_to_admin
      unless current_user.is_a?(Administrator)
        store_location
        flash[:warning] = t(:login_required)
        redirect_to([forgeos_core, :admin,:login])
        return false
      end
      unless current_user.access_path?(params[:controller], params[:action])
        store_location
        flash[:warning] = t(:admin_access_denied)
        if current_user.access_path?('forgeos/admin/dashboard','index')
          redirect_to([forgeos_core, :admin,:root])
        else
          redirect_to([forgeos_core, :admin, :login])
        end
        return false
      end
    end

    # Set session to another user. Only available to admins
    def assume_user(new_user)
      return unless current_user and current_user.is_a?(Administrator) and not new_user.is_a?(Administrator)
      session[:admin_id] = current_user.id
      PersonSession.create(new_user, true)
    end

    def return_to_admin
      if admin = Administrator.find_by_id(session[:admin_id])
        session[:admin_id] = nil
        current_user_session = PersonSession.create(admin, true)
      end
    end


    def edition_locale
      if session[:lang]
        Globalize.locale = session[:lang]
      end
    end

    def forgeos_sort_from_datatables(klass, sorting_columns, search_columns = sorting_columns, per_page = nil)
      search_query = {}

      per_page ||= klass.default_per_page
      per_page = params[:iDisplayLength].to_i if params[:iDisplayLength]
      offset = params[:iDisplayStart] ? params[:iDisplayStart].to_i : 0
      page = (offset / per_page) + 1

      items = klass.page(page)
      items = items.per(per_page)

      search_query[:s] = { '0' => {
        :name => sorting_columns[params[:iSortCol_0].to_i],
        :dir => (params[:sSortDir_0] ? params[:sSortDir_0].downcase : 'asc')
      }}

      if params[:ids]
        items = items.where(:id => params[:ids].split(','))
      else

        keyword = params[:sSearch]
        search_query[:g] ||= []

        if keyword.present?
          search_by_keyword = if keyword.start_with?('#')
            { :id_eq => keyword.gsub(/^#/, '') }
          else
            { :m => 'or', :"#{(search_columns).join('_or_')}_cont" => keyword }
          end

          search_query[:g] << search_by_keyword
        end

        if params[:category_id]
          search_query[:g] << { :categories_id_eq => params[:category_id] }
        end
      end

      [items, search_query]
    end
  end
end
