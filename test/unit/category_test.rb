require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "should create" do
    category = Category.new
    assert category.valid?
  end

  test "should not be his self parent" do
    category = Category.create
    category.update_attributes(:parent_id => category.id)
    assert !category.valid?
    assert_not_nil category.errors[:parent_id]
  end

  test "should calculate his level" do
    category = Category.create
    assert_equal 0, category.level

    subcategory = Category.create(:parent_id => category.id)

    assert_equal 1, subcategory.level
  end

  test "should have descendants" do
    category = Category.create
    subcategory = Category.create(:parent_id => category.id)
    deepercategory = Category.create(:parent_id => subcategory.id)

    assert_equal [subcategory, deepercategory], category.descendants
  end

  test "could change type" do
    category = Category.create
    category.kind = 'AdministratorCategory'
    category.save
    assert_instance_of AdministratorCategory, Category.find(category.id)
  end

  test "should give a hash for jstree" do
    category = Category.create(:name => 'toto', :description => 'toto', :url => 'toto')
    assert_kind_of Hash, category.to_jstree
    assert_equal({
      :attr => {
        :id => "category_#{category.id}"
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
end
