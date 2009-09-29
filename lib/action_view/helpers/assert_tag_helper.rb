module ActionView
  module Helpers
    module AssetTagHelper
      def javascript_include_dir_tag(dir)
        all_javascript_files = collect_asset_files(JAVASCRIPTS_DIR ,dir,'**', '*.js')
        ((determine_source(:defaults, @@javascript_expansions).dup & all_javascript_files) + all_javascript_files).
          uniq.collect { |source| javascript_src_tag(source,{}) }.join("\n")
      end
    end
  end
end