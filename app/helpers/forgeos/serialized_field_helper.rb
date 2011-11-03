module Forgeos
  module SerializedFieldHelper
    def serialized_field(form_builder, type, method, options = {})
      field_name = serialized_field_name(method)
      object = form_builder.object
      raw(
        form_builder.label(field_name) +
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
end
