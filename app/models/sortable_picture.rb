class SortablePicture < ActiveRecord::Base
  belongs_to :picture
  belongs_to :picturable, :polymorphic => true
end
