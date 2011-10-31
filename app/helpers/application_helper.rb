# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logged_in?
    current_user
  end

  def build_menu(menu = {}, options = { :menu => :menu}, html_options = {})
    menu_name = options.delete(:menu)
    menu.each do |k, v|
      content_for menu_name, menu_item(v.dup, k)
    end
  end

  def current_path?(url, path = request.path.gsub(/\/$/,''))
    (url_for(url) != '/' || path == '/') && (url_for(url) != '/admin' || path == '/admin') && path.include?(url_for(url))
  end

  def menu_item(tab, title = tab[:title])
    return ''.html_safe unless tab.has_key?(:url)
    urls = [tab[:url]]
    html_options = (tab[:html] || {}).dup
    tab_name = I18n.t(tab[:title] || title, :scope => [:back_office, :menu])


    if tab[:children] && !tab[:children].empty?
      menu = []
      if tab[:children].kind_of?(Hash)
        tab[:children].each do |k, child|
          next if title == k
          case child
          when Hash
            menu << menu_item(child.dup, k)
            urls << child[:url]
            urls += child[:children].values.compact.flatten
          when String
            menu << menu_item({:url => child}, k)
            urls << child
          when Array
            menu << menu_item({:url => child.first }, k)
            urls += child
          end
        end
      else
        tab[:children].each do |child|
          menu << menu_item(child.dup)
        end
        urls += tab[:children]
      end
    end


    urls.each do |url|
      if current_path?(url)
        if html_options[:class].present?
          html_options[:class] += ' current'
        else
          html_options[:class] = 'current'
        end
      end
    end

    if helper = tab[:helper] and helper.kind_of?(Hash)
      link = self.send(helper[:method],tab_name)
    else
      link = link_to(tab_name.capitalize, urls.first)
    end

    if defined?(menu) and menu.present?
      link += content_tag(:span, '', :class => 'arrow') + content_tag(:ul, menu.join.html_safe)
    end

    content_tag(:li, link, html_options)
  end

  def activerecord_error_list(errors)
    content_tag :ul do
      errors.collect do |e, m|
        content_tag :li, "#{e.capitalize unless e == "base"} #{m}"
      end
    end
  end

  def display_standard_flashes(message = I18n.t(:error), with_tag = true)
    if !flash[:notice].nil? && !flash[:notice].blank?
      flash_to_display, level = flash[:notice], 'ui-state-highlight'
      flash[:notice] = nil
    elsif !flash[:warning].nil? && !flash[:warning].blank?
      flash_to_display, level = flash[:warning], 'ui-state-error'
      flash[:warning] = nil
    elsif !flash[:error].nil? && !flash[:error].blank?
      level = 'ui-state-error'
      if flash[:error].instance_of? ActiveRecord::Errors
        flash_to_display = content_tag :span, message, :class => 'ico close'
        flash_to_display << activerecord_error_list(flash[:error])
      else
        flash_to_display = flash[:error]
      end
      flash[:error] = nil
    else
      return
    end

    content = content_tag :div, :class => 'ui-widget' do
      content_tag :div, :class => "#{level} ui-corner-all" do
        content_tag :p, flash_to_display, :style => 'text-align : center'
      end
    end

    script = render(:update) do |page|
      page.replace_html('display_standard_flashes', content)
      page.visual_effect(:slide_down, 'display_standard_flashes')
      page.delay(10) do
        page.visual_effect(:slide_up,'display_standard_flashes')
      end
    end
    return with_tag ? javascript_tag(script) : script
  end

  def attachment_class_from_content_type(media)
    media_class = Media
    [Video,Pdf,Doc,Picture].each do |klass|
      media_class = klass if klass.attachment_options[:content_type].include?(media.content_type)
    end
    media_class
  end

  def find_categories_from_content_type(media)
    "#{attachment_class_from_content_type(media)}Category".constantize.find_all_by_parent_id(nil)
  end

  def find_media_type_from_content_type(media)
    attachment_class_from_content_type(media).to_s.underscore
  end

  def statistics_collector_tag(object)
    javascript_include_tag(forgeos_core.statistics_collector_path(:type => object.class.to_s.underscore, :id => object.id))
  end

  def serialized_field(form_builder, object, type, method, options = {})
    field_name = serialized_field_name(method)
    raw(
      form_builder.label(field_name, t(method, :scope => [:helpers, :label, form_builder.object_name])) +
      tag(:br) +
      case type
      when :check_box
        form_builder.send(type, field_name, options.merge(:checked => (object[method] == '1')))
      else
        form_builder.send(type, field_name, options.merge(:value => (object[method] || '')))
      end
    )
  end

  def serialized_field_name(*fields)
    fields.map(&:to_s) * ']['
  end
end
