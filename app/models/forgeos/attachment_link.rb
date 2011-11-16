module Forgeos
  class AttachmentLink < ActiveRecord::Base
    belongs_to :attachment
    belongs_to :element, :polymorphic => true
  end
end
