class StatisticCounter < ActiveRecord::Base
  belongs_to :element, :polymorphic => true
end
