# This Controller Manage Categories
module Forgeos
  class Admin::CategoriesController < Admin::BaseController
    skip_before_filter :set_currency, :only => [:index]
    expose(:category, :model => Forgeos::Category)

    # List Categories
    def index
      respond_to do |format|
        format.html{ redirect_to([forgeos_core, :admin, :root]) }
        format.json do
          unless params[:type]
            redirect_to [forgeos_core, :admin, :root]
          else
            # list categories like a tree
            klass = params[:type].camelize.constantize
            @categories = if root = klass.find_by_id(params[:id])
              root.children
            else
              klass.roots
            end

            render :json => @categories.collect(&:to_jstree).to_json
          end
        end
      end
    end

    def new
    end

    # Create a Category
    # ==== Params
    # * category = Hash of Category's attributes
    #
    # The Category can be a child of another Category.
    def create
      if category.save
        flash.notice = t('category.create.success').capitalize
        respond_to do |format|
          format.html { redirect_to [forgeos_core, :edit, :admin, category] }
          format.json { render :text => category.id }
        end
      else
        flash.alert = t('category.create.failed').capitalize
        respond_to do |format|
          format.html { render :action => 'new' }
          format.json { render :json => { :errors => category.errors } }
        end
      end
    end

    # Edit a Category
    # ==== Params
    # * id = Category's id to edit
    # * category = Hash of Category's attributes
    #
    # The Category can be a child of another Category.
    def edit
      category
    end

    def update
      if category.save
        flash.notice = t('category.update.success').capitalize
        respond_to do |format|
          format.html { redirect_to [forgeos_core, :edit, :admin, category] }
          format.json { render :text => category.total_elements_count }
        end
      else
        flash.alert = t('category.update.failed').capitalize
        respond_to do |format|
          format.html { render :action => 'edit' }
          format.json { render :json => { :errors => category.errors } }
        end
      end
    end

    # Destroy a Category
    # ==== Params
    # * id = Category's id
    # ==== Output
    #  if destroy succed, return the Categories list
    def destroy
      if category.destroy
        flash.notice = t('category.destroy.success').capitalize
        respond_to do |format|
          format.html { redirect_to [forgeos_core, :admin, :categories] }
          format.json { render :text => true }
        end
      else
        flash.alert = t('category.destroy.failed').capitalize
        respond_to do |format|
          format.html { redirect_to [forgeos_core, :admin, :categories] }
          format.json { render :json => { :errors => category.errors } }
        end
      end
    end

    def add_element
      category.update_attribute(:element_ids, category.element_ids << params[:element_id].to_i)
      render :text => category.elements.count
    end
  end
end

