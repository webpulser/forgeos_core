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
