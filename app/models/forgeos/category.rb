module Forgeos
  class Category < ActiveRecord::Base
    translates :name, :description, :url
    acts_as_tree :order => "position"
    has_and_belongs_to_many_attachments
    acts_as_list :scope => [:type]
    validates :name, :presence => true

    validates_each :parent_id do |record, attr, value|
      record.errors.add(attr, 'Can\'t be his self parent') if not value.nil? and record.id == value
    end

    def level
      return self.ancestors.length
    end

    def kind
      read_attribute(:type)
    end

    def kind=(kind)
      write_attribute(:type, kind)
    end

    def total_elements_count
      ([elements.count('id')] + children.select('id,type').all.map(&:total_elements_count)).sum
    end

    def category_picture
      unless self.attachments.empty?
        self.attachments.first.public_filename(:categories_icon)
      else
        'folder'
      end
    end

    def to_jstree
      hash = {}
      hash[:li_attr] = { :id => "#{self.class.to_s.underscore}_#{id}"}
      hash[:title] = name
      hash[:data] = {
        :id => id,
        :jstree => {
          :closed => !children.empty?,
          :icon => category_picture
        }
      }
      hash
    end

    def descendants
      (children + children.map(&:descendants)).flatten
    end
  end
end
