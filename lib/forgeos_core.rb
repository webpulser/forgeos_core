# Add patch to ActionController to upload via Adobe Flash
ActionController::Dispatcher.middleware.insert -1, 'FlashSessionCookieMiddleware'

require File.join(File.dirname(__FILE__), 'forgeos/load_settings')
require File.join(File.dirname(__FILE__), 'haml_options')
require File.join(File.dirname(__FILE__), 'engines_plugin_ext')
require File.join(File.dirname(__FILE__), 'extensions')
require File.join(File.dirname(__FILE__), 'forgeos','menu')
require File.join(File.dirname(__FILE__), 'forgeos','url_generator')
require File.join(File.dirname(__FILE__), 'forgeos','statistics')
require File.join(File.dirname(__FILE__), 'sphinx_globalize')
require File.join(File.dirname(__FILE__), 'sortable_attachments')

require 'action_view/helpers/assert_tag_helper'
require 'action_view/helpers/form_helper'
require 'action_view/helpers/form_helper_extensions'
