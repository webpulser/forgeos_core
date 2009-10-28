# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def build_menu(menu = Forgeos::Menu,options = { :menu => :menu}, html_options = {})
    menu_name = options.delete(:menu)
    menu.each do |tab|
      content_for menu_name, menu_item(tab.dup)
    end
  end

  def current_path?(url,path = request.path.gsub(/\/$/,''))
    (url_for(url) != '/' || path == '/') && (url_for(url) != '/admin' || path == '/admin') && path.include?(url_for(url))
  end

  def menu_item(tab)
    html_options = tab[:html] ? tab[:html].dup : {}
    tab_name = (tab.delete(:i18n) ? I18n.t(*tab[:title]) : tab[:title])
    html_options[:class] = '' unless html_options[:class]
    urls = tab.delete(:url) 

    if urls.is_a?(Array)
      urls.each do |url|
        html_options[:class] += ' current' if current_path?(url)
      end
      url = urls.first
    else
      url = urls
      html_options[:class] += ' current' if current_path?(url)
    end

    if helper = tab.delete(:helper)
        link = self.send(helper[:method],tab_name)
    else
        link = link_to(tab_name.capitalize, url)
    end

    if tab[:children] && !tab[:children].empty?
      menu = []
      tab[:children].each do |child|
        menu << menu_item(child.dup)
      end
      link += content_tag(:ul, menu.join)
    end

    content_tag( :li, link, html_options)
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
end
