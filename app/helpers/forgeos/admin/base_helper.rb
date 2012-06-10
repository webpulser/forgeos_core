module Forgeos
  module Admin
    module BaseHelper
      include AttachmentHelper
      include DatatablesHelper

      def fg_search
        label = content_tag(:span, t('search'), :class => 'small-icons search-span')
        link_to(label, '#', :class => 'small-icons left search-link')
      end

      def fg_submit_tag(label)
        submit_tag(t(label), :class => 'backgrounds interact-button')
      end

      def forgeos_save_buttons(back_path= [forgeos_core, :admin, :root], label= 'save')
        content_tag(
          :div,
          fg_submit_tag(label) + t('or') + link_to(t('cancel'), back_path, :class => 'back-link'),
          :class => 'interact-links'
        )
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
