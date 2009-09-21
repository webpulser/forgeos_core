class StatisticCounter < ActiveRecord::Base
  belongs_to :element, :polymorphic => true, :dependent => :destroy

  validates_uniqueness_of :element_id, :scope => [ :date, :element_type ]

  def increment_counter
     sc = StatisticCounter.find_by_element_id_and_date_and_element_type( element_id, date, element_type )
     if sc
       sc.increment!(:counter)
     else
       false
     end
  end

end
