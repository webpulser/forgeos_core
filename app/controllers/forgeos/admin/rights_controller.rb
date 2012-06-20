module Forgeos
  class Admin::RightsController < Admin::BaseController
    expose(:right, :model => Forgeos::Right)

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
      right
    end

    def new
    end

    def edit
      right
    end

    def create
      if right.save
        flash.notice = I18n.t('right.create.success').capitalize
        return request.xhr? ? render(:nothing => true) : redirect_to([forgeos_core, :edit, :admin, right])
      else
        flash.alert = I18n.t('right.create.failed').capitalize
        if request.xhr?
          render :nothing => true, :json => { :result => 'error' }
          return false
        else
          render :action => 'new'
        end
      end
    end

    def update
      if right.save
        flash.notice = I18n.t('right.update.success').capitalize
        return request.xhr? ? render(:nothing => true) : render(:action => :edit)
      else
        flash.alert = I18n.t('right.update.failed').capitalize
        if request.xhr?
          render :nothing => true, :json => { :result => 'error' }
          return false
        else
          render :action => 'edit'
        end
      end
    end

    def destroy
      if right.destroy
        flash.notice = I18n.t('right.destroy.success').capitalize
      else
        flash.alert = I18n.t('right.destroy.failed').capitalize
      end

      respond_to do |wants|
        wants.html do
          redirect_to([forgeos_core, :admin, :rights])
        end
        wants.js { render :nothing => true }
      end
    end

  private
    def sort
      items, search_query = forgeos_sort_from_datatables(Right, %w(id name controller_name action_name), %w(name controller_name action_name))
      @rights = items.search(search_query).result
    end
  end
end
