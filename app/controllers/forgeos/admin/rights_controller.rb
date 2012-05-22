module Forgeos
  class Admin::RightsController < Admin::BaseController
    before_filter :get_right, :only => [:show, :edit, :update, :destroy]

    def index
      respond_to do |format|
        format.html # index.html.erb
        format.json do
          sort
          render :layout => false
        end
      end
    end

    def show
    end

    def new
      @right = Right.new(params[:right])
    end

    def edit
    end

    def create
      @right = Right.new(params[:right])
      if @right.save
        flash[:notice] = I18n.t('right.create.success').capitalize
        return request.xhr? ? render(:nothing => true) : redirect_to([forgeos_core, :edit, :admin, @right])
      else
        flash[:error] = I18n.t('right.create.failed').capitalize
        if request.xhr?
          render :nothing => true, :json => { :result => 'error' }
          return false
        else
          render :action => 'new'
        end
      end
    end

    def update
      if @right.update_attributes(params[:right])
        flash[:notice] = I18n.t('right.update.success').capitalize
        return request.xhr? ? render(:nothing => true) : render(:action => :edit)
      else
        flash[:error] = I18n.t('right.update.failed').capitalize
        if request.xhr?
          render :nothing => true, :json => { :result => 'error' }
          return false
        else
          render :action => 'edit'
        end
      end
    end

    def destroy
      if @right.destroy
        flash[:notice] = I18n.t('right.destroy.success').capitalize
      else
        flash[:error] = I18n.t('right.destroy.failed').capitalize
      end

      respond_to do |wants|
        wants.html do
          redirect_to([forgeos_core, :admin, :rights])
        end
        wants.js
      end
    end

  private

    def get_right
      unless @right = Right.find_by_id(params[:id])
        flash[:error] = I18n.t('right.not_exist').capitalize
        return redirect_to([forgeos_core, :admin, :rights])
      end
    end

    def sort
      columns = %w(forgeos_rights.id forgeos_rights.name controller_name action_name)
      per_page = params[:iDisplayLength] ? params[:iDisplayLength].to_i : 10
      offset = params[:iDisplayStart] ? params[:iDisplayStart].to_i : 0
      page = (offset / per_page) + 1
      order_column = params[:iSortCol_0].to_i
      order = "#{columns[order_column]} #{params[:sSortDir_0] ? params[:sSortDir_0].upcase : 'ASC'}"


      conditions = {}
      includes = []
      options = { :page => page, :per_page => per_page }

      if params[:category_id]
        conditions[:forgeos_categories_elements] = { :category_id =>  params[:category_id] }
        includes << :categories
      end

      options[:conditions] = conditions unless conditions.empty?
      options[:include] = includes unless includes.empty?
      options[:order] = order unless order.squeeze.blank?

      if params[:sSearch] && !params[:sSearch].blank?
        options[:star] = true
        if options[:order]
          options[:order].gsub!('forgeos_rights.', '')
        end

        @rights = Right.search(params[:sSearch],options)
      else
        @rights = Right.paginate(options)
      end
    end
  end
end
