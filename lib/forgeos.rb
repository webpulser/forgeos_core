# coding: utf-8

# Add patch to ActionController to upload via Adobe Flash
ActionController::Dispatcher.middleware.insert -1, 'FlashSessionCookieMiddleware'
require 'haml_options'
require 'forgeos/menu'
require 'forgeos/url_generator'
require 'forgeos/statistics'
require 'mysql_utf8' if RUBY_VERSION.to_f >= 1.9

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  error_message = instance.object.errors.on(instance.method_name)
  if error_message && !(html_tag =~ /^<label|type="hidden"/)
    "#{html_tag}<div class='field error'><span class='small-icons message'>#{error_message.is_a?(Array) ? error_message.first : error_message}</span></div>"
  else
    html_tag
  end
end

require 'action_view/helpers/assert_tag_helper'
require 'action_view/helpers/form_helper'
require 'action_view/helpers/form_helper_extensions'
require 'sortable_attachments'
