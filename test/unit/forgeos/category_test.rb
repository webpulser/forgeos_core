require 'test_helper'

module Forgeos
  class CategoryTest < ActiveSupport::TestCase
    test "should create" do
      category = Category.new(:name => 'test')
      assert category.valid?
    end

    test "should have a name" do
      category = Category.new(:name => nil)
      assert !category.valid?

      category = Category.new(:name => '')
      assert !category.valid?
    end

    test "should not be his self parent" do
      category = Category.create(:name => 'test')
      category.update_attributes(:parent_id => category.id)
      assert !category.valid?
      assert_not_nil category.errors[:parent_id]
    end

    test "should calculate his level" do
      category = Category.create(:name => 'test')
      assert_equal 0, category.level

      subcategory = Category.create(:name => 'test', :parent_id => category.id)

      assert_equal 1, subcategory.level
    end

    test "should have descendants" do
      category = Category.create(:name => 'test')
      subcategory = Category.create(:name => 'test', :parent_id => category.id)
      deepercategory = Category.create(:name => 'test', :parent_id => subcategory.id)

      assert_equal [subcategory, deepercategory], category.descendants
    end

    test "could change type" do
      class ::CategoryInherit < Category
      end
      category = Category.create(:name => 'test')
      category.kind = 'CategoryInherit'
      assert category.save
      assert_equal 'CategoryInherit', category.kind
      assert_instance_of CategoryInherit, Category.find(category.id)
      assert_kind_of Category, CategoryInherit.find(category.id)
    end

    test "should give a hash for jstree" do
      category = Category.create(:name => 'toto', :description => 'toto', :url => 'toto')
      assert_kind_of Hash, category.to_jstree
      assert_equal({
        :attr => {
          :id => "forgeos/category_#{category.id}"
        },
        :data => {
          :title => "toto",
          :icon => 'folder'
        },
        :metadata => {
          :id => category.id
        },
        :state => 'open'
      }, category.to_jstree)
    end

    test "should have picture" do
      category = Category.create(:name => 'toto', :description => 'toto', :url => 'toto')
      assert_equal "folder", category.category_picture
      category.attachments << forgeos_attachments(:picture)
      assert_equal "/uploads/images/0000/0002/picture_categories_icon.jpg", category.category_picture
    end

    test "should count elements" do
      class ::TestCategory < Category
        has_and_belongs_to_many :elements,
          :join_table => 'forgeos_categories_elements',
          :foreign_key => 'category_id',
          :association_foreign_key => 'element_id',
          :class_name => 'Forgeos::User'
      end

      category = TestCategory.create(
        :name => 'toto',
        :description => 'toto',
        :url => 'toto',
        :elements => [forgeos_people(:user)]
      )
      assert_equal [forgeos_people(:user)], category.elements
      assert_equal 1, category.total_elements_count
    end

    test "should count elements with childrens" do
      class ::TestCategory < Category
        has_and_belongs_to_many :elements,
          :join_table => 'forgeos_categories_elements',
          :foreign_key => 'category_id',
          :association_foreign_key => 'element_id',
          :class_name => 'Forgeos::User'
      end

      category = TestCategory.create(:name => 'toto', :description => 'toto', :url => 'toto')
      child_category = TestCategory.create(
        :name => 'tata',
        :description => 'tata',
        :url => 'tata',
        :parent => category,
        :elements => [forgeos_people(:user)]
      )
      assert_equal 1, category.total_elements_count
    end

  end
end
