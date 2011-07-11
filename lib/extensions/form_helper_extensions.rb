ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  error_message = instance.object.errors[instance.method_name]
  if error_message && !(html_tag =~ /^<label|type="hidden"/)
    "#{html_tag}<div class='field error'><span class='small-icons message'>#{error_message.is_a?(Array) ? error_message.first : error_message}</span></div>".html_safe
  else
    html_tag
  end
end
