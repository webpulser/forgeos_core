class Attachment < ActiveRecord::Base
  has_and_belongs_to_many   :attachment_categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'

  def file_type
    self.content_type.split('/')[1]
  end
end
