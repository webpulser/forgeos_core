# coding: utf-8
require 'action_view/helpers/assert_tag_helper'
require 'forgeos/menu'
require 'forgeos/url_generator'
require 'forgeos/statistics'

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  error_message = instance.object.errors.on(instance.method_name)
  if error_message && !(html_tag =~ /^<label|type="hidden"/)
    "#{html_tag}<div class='field error'><span class='small-icons message'>#{error_message.is_a?(Array) ? error_message.first : error_message}</span></div>"
  else
    html_tag
  end
end
