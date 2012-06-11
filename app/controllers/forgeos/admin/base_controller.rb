module Forgeos
  class Admin::BaseController < Forgeos::ApplicationController
    layout 'forgeos/admin'
    helper "forgeos/admin/base"
    before_filter :login_required, :edition_locale, :except => [:notifications, :url]
    skip_after_filter :log_visit
    protect_from_forgery

  private

    def login_required
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
