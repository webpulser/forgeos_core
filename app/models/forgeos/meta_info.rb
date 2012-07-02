module Forgeos
  class MetaInfo < ActiveRecord::Base
    translates :title, :description, :keywords
    belongs_to :target, :polymorphic => true
  end
end
