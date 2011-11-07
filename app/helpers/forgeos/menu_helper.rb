module Forgeos
  module MenuHelper
    def build_menu(menu = {}, options = { :menu => :menu}, html_options = {})
      menu_name = options.delete(:menu)
      menu.each do |k, v|
        content_for menu_name, menu_item(v.dup, k)
      end
    end

    def current_path?(url, path = request.path.gsub(/\/$/,''))
      (url_for(url) != '/' || path == '/') && (url_for(url) != '/admin' || path == '/admin') && url_for(path).include?(url_for(url))
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
        if current_path?(url)
          if html_options[:class].present?
            html_options[:class] += ' current'
          else
            html_options[:class] = 'current'
          end
        end
      end

      link = link_to(tab_name.capitalize, urls.first)

      if defined?(menu) and menu.present?
        link += content_tag(:span, '', :class => 'arrow') + content_tag(:ul, menu.join.html_safe)
      end

      content_tag(:li, link, html_options)
    end

  end
end
