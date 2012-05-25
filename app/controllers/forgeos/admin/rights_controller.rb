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
      items, search_query = forgeos_sort_from_datatables(Right, %w(id name controller_name action_name), %w(name controller_name action_name))
      @rights = items.search(search_query).result
    end
  end
end
