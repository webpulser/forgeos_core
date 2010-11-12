class Attachment < ActiveRecord::Base
  has_and_belongs_to_many   :attachment_categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'
  before_save :fill_blank_name_with_filename 
  has_many :attachment_links

  named_scope :linked, lambda {{:include => :attachment_links, :conditions => {:attachment_links => {:element_type => 'Product'}}}}

  define_index do
    indexes filename, :sortable => true
    indexes content_type, :sortable => true
    indexes size, :sortable => true
  end

  def file_type
    self.content_type.split('/').last
  end
  
  def fill_blank_name_with_filename
    if self.name.nil? || self.name.blank?
      self.name = self.filename.split('.').first if self.filename
    end
  end  
end
