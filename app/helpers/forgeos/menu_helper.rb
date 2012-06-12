module Forgeos
  module MenuHelper
    def build_menu(menu = {}, options = { :menu => :menu}, html_options = {})
      menu_name = options.delete(:menu)
      menu.each do |k, v|
        content_for menu_name, menu_item(v.dup, k)
      end
    end

    def current_path?(url, path = request.path.gsub(/\/$/,''))
      url_string = url_for(url)
      (url_string != '/' || path == '/') && (url_string != '/admin' || path == '/admin') && url_for(path).include?(url_string)
    end

    def i(icon)
      content_tag(:i, '', :class => "icon-#{icon}")
    end


    def menu_item(tab, title = tab[:title])
      return ''.html_safe unless tab.has_key?(:url)
      urls = [tab[:url]]
      html_options = (tab[:html] || {}).dup
      tab_name = (tab[:icon] ? i(tab[:icon]) : '')
      tab_name += t(tab[:title] || title, :scope => [:back_office, :menu])

      html_options[:class] = (html_options[:class] || '').split(' ')

      if tab[:children] && !tab[:children].empty?
        menu = []
        if tab[:children].kind_of?(Hash)
          tab[:children].each do |k, child|
            next if title == k
            case child
            when Hash
              menu << menu_item(child.dup, k)
              urls << child[:url]
              urls += child[:children].values.compact.flatten if child[:children]
            when String
              menu << menu_item({:url => child}, k)
              urls << child
            when Array
              menu << menu_item({:url => child.first }, k)
              urls += child
            end
          end
        end
      end


      urls.each do |url|
        if url.is_a?(Array) and engine = Rails.application.railties.engines.find { |en| en.engine_name == url.first }
          url[0] = eval(url.first)
        end

        html_options[:class] << 'active' if current_path?(url)
      end


      if defined?(menu) and menu.present?
        html_options[:class] << 'dropdown'
        link = link_to((tab_name + content_tag(:b, '', :class => 'caret')).html_safe, '#', :class => 'dropdown-toggle', "data-toggle" => 'dropdown')

        link += content_tag(:ul, menu.join.html_safe, :class => 'dropdown-menu')
      else

        link = link_to(tab_name, urls.first)
      end

      content_tag(:li, link, html_options)
    end
  end
end
