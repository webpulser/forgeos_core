class Attachment < ActiveRecord::Base
  has_and_belongs_to_many :attachment_categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'
  has_and_belongs_to_many :categories, :readonly => true, :join_table => 'categories_elements', :foreign_key => 'element_id', :association_foreign_key => 'category_id'
  has_many :attachment_links, :dependent => :destroy

  before_save :fill_blank_name_with_filename

  named_scope :linked_to, lambda { |element_type| {:include => :attachment_links, :conditions => {:attachment_links => {:element_type => element_type.to_s.classify }}}}

  define_index do
    indexes filename, :sortable => true
    indexes content_type, :sortable => true
    indexes size, :sortable => true
  end

  def file_type
    content_type.split('/').last
  end

  def fill_blank_name_with_filename
    if name.blank? and filename
      self.name = filename.split('.').first
    end
  end

  private

  def self.options_for(target = class_name)
    (Setting.current.attachments[target] || {}).symbolize_keys
  end
end
