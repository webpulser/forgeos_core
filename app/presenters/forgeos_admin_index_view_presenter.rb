class ForgeosAdminIndexViewPresenter
  attr_reader :model, :category_model, :icon, :engine, :columns, :button_options, :template

  def initialize(template, engine, model, icon, columns, button_options)
    @model = model
    @category_model = "#{model}Category".constantize
    @icon = icon
    @engine = engine
    @columns = columns
    @button_options = button_options
    @template = template
  end

  def sidebar
    url = engine.send("admin_#{category_model.model_name.route_key}_path", :format => :json)
    template.render :partial => 'index_view_sidebar', :locals => {
      :icon => icon,
      :sidebar_title => "#{model_name(model)}.all",
      :tree_id => "#{model_name(category_model)}-tree",
      :url => url, :model_name => category_model
    }
  end

  def model_name(model)
    model.model_name.singular_route_key
  end

  def header
    template.render :partial => 'index_view_header', :locals => {
      :tree_id => "#{model_name(category_model)}-tree",
      :button => button
    }
  end

    def button
      button_options[:class] ||= 'btn'
      template.link_to [engine, :new, :admin, model_name(model)], button_options do
        template.i('plus-sign') +
        template.i(icon) +
        template.t(:action, :scope => [model_name(model), :create])
      end
    end

  def to_s
    template.render :partial => 'index_view', :locals => {
      :header => header,
      :sidebar => sidebar,
      :table => template.datatable(
        :draggable => true,
        :autostart => true,
        :url => engine.send("admin_#{model.model_name.route_key}_path", :format => :json),
        :columns => columns
      )
    }
  end
end

