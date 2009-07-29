#SortableAttachments
module SortableAttachments #:nodoc:

  def self.included(base)
    base.extend ClassMethods  
  end

  module ClassMethods
    def sortable_attachments
      has_many :sortable_attachments, :dependent => :destroy, :order => 'position', :as => :attachable
      has_many :attachments, :through => :sortable_attachments, :readonly => true, :order => 'sortable_attachments.position'
    end
  end

end

ActiveRecord::Base.send(:include, SortableAttachments)
