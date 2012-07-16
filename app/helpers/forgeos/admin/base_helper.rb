module Forgeos
  module Admin
    module BaseHelper
      include RequirejsHelper
      include Forgeos::MenuHelper
      include Forgeos::AttachmentHelper
      include Forgeos::SerializedFieldHelper
      include Forgeos::StatisticsHelper
      include AttachmentHelper
      include DatatablesHelper

      def index_view(icon, engine, model, columns, button = {})
        ForgeosAdminIndexViewPresenter.new(self, engine, model, icon, columns, button)
      end

      def form_header(html_options = {}, &block)
        html_options[:class] ||= 'subnav'
        content_tag(:div, html_options) do
          if block_given?
            yield
          end
        end
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
          :data => { :confirm => confirm },
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

      def fg_submit_tag(label, form = nil)
        if form
          form.submit :class => 'btn btn-large btn-primary'
        else
          button_tag((content_tag(:i, '', :class => 'icon-ok') + t(label)).html_safe, :class => 'btn btn-large btn-primary')
        end
      end

      def forgeos_save_buttons(back_path= [forgeos_core, :admin, :root], label= 'forgeos.admin.base.save_changes', form = nil)
        fg_submit_tag(label, form) +
          link_to(t('forgeos.admin.base.cancel'), back_path, :class => 'btn btn-mini')
      end

      def polymorphic_html_id(object, prefix = '')
        elements = []
        elements << prefix if prefix.present?
        elements << object.class.to_s.underscore.gsub(/^.*\//, '')
        elements << object.id

        elements * '_'
      end
    end
  end
end
