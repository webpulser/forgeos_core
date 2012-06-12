module Forgeos
  module Admin
    module BaseHelper
      include AttachmentHelper
      include DatatablesHelper

      def index_sidebar(icon, title, id)
        render :partial => 'left_sidebar', :locals => { :icon => icon, :sidebar_title => title, :tree_id => id }
      end

      def create_button(engine, model, icon, html_options = {})
        html_options[:class] ||= 'btn'
        link_to [engine, :new, :admin, model], html_options do
          i('plus-sign') +
          i(icon) +
          t(:action, :scope => [model, :create])
        end
      end


      def size_in_kb(size)
        "#{size/1024} #{t 'media.byte.kilo'}"
      end

      def handler_icon(icon, model)
        content_tag(:div, :id => polymorphic_html_id(model), :class => 'handler_container') do
          content_tag(:div, '', :class=>'handler') +
          i(icon)
        end
      end

      def activate_toogle_button(engine, model)
        link_to('', [engine, :activate, :admin, model],
          :remote => true,
          :method => :put,
          :class => (model.active? ? 'active icon icon-eye-open' : 'unactive icon icon-eye-close'),
          :id => polymorphic_html_id(model, 'show')
        )
      end

      def duplicate_button(engine, model)
        link_to('', [engine, :duplicate, :admin, model], :class => 'icon icon-copy')
      end

      def edit_button(engine, model)
        link_to('', [engine, :edit, :admin, model], :class => 'icon icon-pencil')
      end

      def destroy_button(engine, model, confirm = t(:confirm, :scope => [model.class.model_name.singular_route_key, :destroy]))
        link_to('', [engine, :admin, model],
          :remote => true,
          :method => :delete,
          :confirm => confirm,
          :class => 'icon icon-trash',
          :id => polymorphic_html_id(model, 'destroy')
        )
      end

      def forgeos_js_vars
        session_key = Rails.application.config.session_options[:key]
        javascript_tag "
        window._forgeos_js_vars = {
         session_key: '#{session_key}',
         session: encodeURIComponent('#{cookies[session_key]}'),
         mount_paths: {
           core: '#{Rails.application.routes.named_routes[:forgeos_core].path.spec}'
         }
        }"
      end

      def fg_search
        content_tag(:div, '', :id => 'search')
      end

      def fg_submit_tag(label)
        button_tag((content_tag(:i, '', :class => 'icon-ok') + t(label)).html_safe, :class => 'btn btn-large btn-primary')
      end

      def forgeos_save_buttons(back_path= [forgeos_core, :admin, :root], label= 'save_changes')
        fg_submit_tag(label) +
          link_to(t(:cancel), back_path, :class => 'btn btn-mini')
      end

      def polymorphic_html_id(object, prefix = '')
        elements = []
        elements << prefix if prefix.present?
        elements << object.class.to_s.underscore
        elements << object.id

        elements * '_'
      end
    end
  end
end
