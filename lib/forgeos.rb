# coding: utf-8

# Add patch to ActionController to upload via Adobe Flash
ActionController::Dispatcher.middleware.insert -1, 'FlashSessionCookieMiddleware'
require 'haml_options'
require 'extensions'
require 'forgeos/menu'
require 'forgeos/url_generator'
require 'forgeos/statistics'
require 'sphinx_globalize'

require 'action_view/helpers/assert_tag_helper'
require 'action_view/helpers/form_helper'
require 'action_view/helpers/form_helper_extensions'
require 'sortable_attachments'
