module Forgeos
  class StatisticCounter < ActiveRecord::Base
    belongs_to :element, :polymorphic => true

    after_initialize :set_default_date_to_current

    def increment_counter
      counter = self.class.find_by_element_id_and_date_and_element_type( element_id, date, element_type )

      if counter
        counter.increment!(:counter)
      else
        save
      end
    end

  private

    def set_default_date_to_current
      self.date = Date.current
    end
  end
end
