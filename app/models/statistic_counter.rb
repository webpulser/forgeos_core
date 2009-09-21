class StatisticCounter < ActiveRecord::Base
  
  belongs_to :element, :polymorphic => true, :dependent => :destroy

  validates_uniqueness_of :element_id, :scope => [ :date, :element_type ]
  def initialize
    super
    set_default_date_to_current
  end

  def increment_counter
     sc = self.class.find_by_element_id_and_date_and_element_type( element_id, date, element_type )
     if sc
       sc.increment!(:counter)
     else
       false
     end
  end
private
  def set_default_date_to_current
    self.date = Date.current
  end
end
