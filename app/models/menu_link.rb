class MenuLink < ActiveRecord::Base
  acts_as_tree

  validates_presence_of :title

  belongs_to :menu
  belongs_to :target, :polymorphic => true

  accepts_nested_attributes_for :children, :allow_destroy => true

  def kind
    read_attribute(:type)
  end
  
  def kind=(kind)
    write_attribute(:type, kind)
  end

  def clone
    menu_link = super
    menu_link.children = self.children.collect(&:clone)
    return menu_link
  end

  def url
    url_attribute = super
    if url_attribute.nil? || url_attribute.blank?
      target_id.nil? ? '#' : target
    else
      url_attribute
    end
  end

  def url_and_children_urls
    urls = [self.url]
    self.children.each do |child|
      urls += child.url_and_children_urls
    end
    return urls
  end
end
