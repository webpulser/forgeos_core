module Sphinx
  module Globalize
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def define_translated_index(*attr_names)
        translation_table_name = "#{table_name.singularize}_translations"
        I18n.available_locales.each do |locale|
          define_index "#{sphinx_name}_#{locale}" do
            where "`#{translation_table_name}`.`locale` = '#{locale}'"
            attr_names.each do |attr|
              indexes translations(attr), :as => attr, :sortable => true
            end
          end
        end
      end
    end
  end
end
ActiveRecord::Base.send(:include,Sphinx::Globalize)
