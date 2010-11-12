# This Controller Manage Categories
class Admin::CategoriesController < Admin::BaseController
  before_filter :get_category, :only => [:edit, :update, :destroy, :add_element]
  before_filter :new_category, :only => [:new, :create]
  skip_before_filter :set_currency, :only => [:index]

  # List Categories
  def index
    respond_to do |format|
      format.html{ redirect_to(:root) }
      format.json do
        unless params[:type]
          # list page and product categories
          sort
          render :layout => false
        else
          # list categories like a tree
          klass = params[:type].camelize.constantize
          @categories = klass.find_all_by_parent_id(nil)

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
    if @category.save
      flash[:notice] = t('category.create.success').capitalize
      respond_to do |format|
        format.html { redirect_to edit_admin_category_path(@category)}
        format.json { render :text => @category.id }
      end
    else
      flash[:error] = t('category.create.failed').capitalize
      render :action => 'new'
    end
  end

  # Edit a Category
  # ==== Params
  # * id = Category's id to edit
  # * category = Hash of Category's attributes
  #
  # The Category can be a child of another Category.
  def edit
  end

  def update
    if params[:category] && params[:category][:position]
      position = params[:category].delete(:position)
    end
    if @category.update_attributes(params[:category])
      @category.insert_at(position) unless position.nil?
      flash[:notice] = t('category.update.success').capitalize
    else
      flash[:error] = t('category.update.failed').capitalize
    end

    respond_to do |format|
      format.html { render :action => 'edit' }
      format.json { render :text => @category.total_elements_count }
    end
  end

  # Destroy a Category
  # ==== Params
  # * id = Category's id
  # ==== Output
  #  if destroy succed, return the Categories list
  def destroy
    if @category.destroy
      flash[:notice] = t('category.destroy.success').capitalize
    else
      flash[:error] = t('category.destroy.failed').capitalize
    end
    render :text => true
  end

  def add_element
    render :text => @category.update_attribute(:element_ids, @category.element_ids << params[:element_id].to_i)
  end

private
  def get_category
    unless @category = Category.find_by_id(params[:id])
      flash[:error] = t('category.not_exist').capitalize
      return redirect_to(:action => :index)
    end
  end

  def new_category
    @category = Category.new(params[:category])
  end

  def sort
    columns = %w(categories.name categories.name)
    per_page = params[:iDisplayLength].to_i
    offset =  params[:iDisplayStart].to_i
    page = (offset / per_page) + 1
    #order_column = params[:iSortCol_0].to_i
    #order = "#{columns[order_column]} #{params[:iSortDir_0].upcase}"
    order = 'position ASC'
    conditions = {}
    conditions[:type] = params[:types].collect{ |type| "#{type}Category".camelize } if params[:types]

    options = { :page => page, :per_page => per_page }
    options[:conditions] = conditions unless conditions.empty?
    options[:order] = order unless order.squeeze.blank?
    if params[:sSearch] && !params[:sSearch].blank?
      options[:star] = true
      @categories = Category.search(params[:sSearch], options)
    else
      @categories = Category.paginate(:all, options)
    end
  end
end
