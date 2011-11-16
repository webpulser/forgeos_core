require 'test_helper'

module Forgeos
  class SphinxGlobalizeTest < ActiveSupport::TestCase
    test "should be included in ActiveRecord::Base" do
      assert ActiveRecord::Base.respond_to?(:define_translated_index)
    end

    test "should define one sphinx index by locale" do
      class ::SphinxGlobalizeRecord < ActiveRecord::Base
        self.table_name = 'people'

        define_translated_index :lastname, :firstname
      end

      assert_respond_to ::SphinxGlobalizeRecord, :sphinx_indexes

      assert ::SphinxGlobalizeRecord.sphinx_index_names.include?('sphinx_globalize_record_en_core'), 'english index not defined'
      assert ::SphinxGlobalizeRecord.sphinx_index_names.include?('sphinx_globalize_record_fr_core'), 'french index not defined'
    end
  end
end
