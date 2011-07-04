module ActionView
  module Helpers
    module AssetTagHelper
      def javascript_include_dir_tag(*sources)
        options = sources.extract_options!.stringify_keys
        all_javascript_files = collect_asset_files(JAVASCRIPTS_DIR ,sources,'**', '*.js')
        javascript_include_tag(all_javascript_files, options)
      end
    end
  end
end
