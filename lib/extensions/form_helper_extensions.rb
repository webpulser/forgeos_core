require 'action_view/helpers/form_helper'
module ActionView
  module Helpers
    class FormBuilder #:nodoc:
      private
      def fields_for_nested_model_with_noid(name, object, args, block)
        if object && object.new_record? || (args.first && args.first[:omit_hidden_fields]) == true
          @template.fields_for(name, object, *args, &block)
        else
          @template.fields_for(name, object, *args) do |builder|
            @template.concat builder.hidden_field(:id)
            block.call(builder)
          end
        end
      end

      alias_method_chain :fields_for_nested_model, :noid
    end
    class InstanceTag
      def to_label_tag_with_nested(text = nil, options = {})
        options = options.stringify_keys
        tag_value = options.delete("value")
        name_and_id = options.dup
        name_and_id["id"] = name_and_id["for"]
        add_default_name_and_id_for_value(tag_value, name_and_id)
        options.delete("index")
        options["for"] ||= name_and_id["id"]

        content = if text.blank?
          base_name = object ? object.class.name.underscore : object_name
          i18n_label = I18n.t("helpers.label.#{base_name}.#{method_name}", :default => "")
          i18n_label if i18n_label.present?
        else
          text.to_s
        end

        content ||= if object && object.class.respond_to?(:human_attribute_name)
          object.class.human_attribute_name(method_name)
        end

        content ||= method_name.humanize

        label_tag(name_and_id["id"], content, options)
      end
      alias_method_chain :to_label_tag, :nested
    end
  end
end

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  error_message = instance.object.errors.on(instance.method_name)
  if error_message && !(html_tag =~ /^<label|type="hidden"/)
    "#{html_tag}<div class='field error'><span class='small-icons message'>#{error_message.is_a?(Array) ? error_message.first : error_message}</span></div>"
  else
    html_tag
  end
end
