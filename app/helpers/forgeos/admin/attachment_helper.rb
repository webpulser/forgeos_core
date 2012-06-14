module Forgeos
  module Admin
    module AttachmentHelper

      def size_in_kb(size)
        "#{size/1024} #{t 'attachment.byte.kilo'}"
      end

      #### Display object visual ####
      def display_visual(object_name, picture, name = 'picture')
        content_tag :div, :class => 'fieldset open' do
          link_to(t(:name, :scope => [object_name, name]), '#', :class => 'small-icons panel') +
          content_tag(:div, :class =>'option-panel-content') do
            label = (picture.nil? ? t(:add, :scope => [object_name,name]) : t(:change, :scope => [object_name, name]))
            picture.nil? ? picture_id = '' : picture_id = picture.id
            hidden_field_tag("#{object_name}[#{name}_id]", picture_id, :id => name) +
            link_to(content_tag(:span, label,:class => 'big-icons add-picture'),
                    '#', :class => "add-image backgrounds button right", 'data-callback' => 'add_picture_to_element', 'data-input_name' => "##{name}") +
            content_tag(:div, :class => 'grid_9', :id => "#{name}-picture") do
              content_tag(:ul, :class => 'sortable') do
                unless picture.nil?
                  content_tag(:li) do
                    image_tag(picture.public_filename(:normal)) +
                    link_to('', '#', :onclick => "jQuery(this).parents('li').remove(); jQuery('##{name}').val('null');", :title => t('picture.destroy.confirm'), :class => 'big-icons delete')
                  end
                end
              end
            end
          end +
          content_tag(:div,'', :class => 'clear')
        end
      end

      #### Display object visuals ####
      def display_visuals(object_name, pictures)
        content_tag :div, :class => 'fieldset open' do
          link_to(t("#{object_name}.visuals.name"), '#', :class => 'small-icons panel') +
          content_tag(:div, :class =>'option-panel-content') do
            link_to(content_tag(:span, t("add_picture"),
                                  :class => 'big-icons add-picture'),
                      '#', :class => 'add-image backgrounds button right', 'data-callback' => 'add_picture_to_visuals') +
            content_tag(:div, :class => 'grid_9', :id => 'visuals-picture') do
              content_tag(:ul, :class => 'sortable') do
                pictures.collect{ |picture|
                  content_tag(:li) do
                    link_to('', '#', :onclick => "jQuery(this).parents('li').remove();", :title => t('picture.destroy.confirm'), :class => 'big-icons delete') +
                    hidden_field_tag("#{object_name}[attachment_ids][]", picture.id, :id => "attachment_#{picture.id}") +
                    image_tag(picture.public_filename(:thumb)) +
                    content_tag(:div, :class => 'handler') do
                      content_tag(:div,'',:class => 'inner')
                    end
                  end
                }.join.html_safe +
                content_tag(:li,'', :class => 'clear')
              end
            end
          end +
          content_tag(:div,'', :class => 'clear')
        end
      end

    end
  end
end
