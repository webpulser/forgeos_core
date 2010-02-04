module Sphinx
  module Globalize
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def define_translated_index(*attr_names)
        klass_name = self.table_name.singularize
        translation_table_name = "#{klass_name}_translations"
        I18n.available_locales.each do |locale|
          self.define_index "#{klass_name}_#{locale}" do
            where "`#{translation_table_name}`.`locale` = '#{locale}'"
            attr_names.each do |attr|
              indexes globalize_translations(attr), :as => attr, :sortable => true
            end
          end
        end
      end
    end
  end
end
ActiveRecord::Base.send(:include,Sphinx::Globalize)
