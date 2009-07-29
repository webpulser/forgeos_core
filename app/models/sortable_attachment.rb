class SortableAttachment < ActiveRecord::Base
  belongs_to :attachment
  belongs_to :attachable, :polymorphic => true
end
