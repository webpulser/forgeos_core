module Engines
  class Plugin < Rails::Plugin
    def add_plugin_locale_paths_with_config
      locale_path = File.join(directory,'config', 'locales')
      return unless File.exists?(locale_path)

      locale_files = Dir[File.join(locale_path, '**', '*.{rb,yml}')]
      return if locale_files.blank?

      first_app_element =
        I18n.load_path.select{ |e| e =~ /^#{ RAILS_ROOT }/ }.reject{ |e| e =~ /^#{ RAILS_ROOT }\/vendor\/plugins/ }.first
      app_index = I18n.load_path.index(first_app_element) || - 1

      I18n.load_path.insert(app_index, *locale_files)
    end
    alias_method_chain :add_plugin_locale_paths, :config
  end
end
