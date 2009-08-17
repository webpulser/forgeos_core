#SortableAttachments
module SortableAttachments #:nodoc:

  def self.included(base)
    base.extend ClassMethods  
  end

  module ClassMethods
    def sortable_attachments
      has_and_belongs_to_many :attachments, :list => true
    end
  end

end

ActiveRecord::Base.send(:include, SortableAttachments)
