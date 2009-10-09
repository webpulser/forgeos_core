class CreateStatisticCounters < ActiveRecord::Migration
  def self.up
    create_table :statistic_counters do |t|
      t.string :type
      t.date :date
      t.integer :counter,
        :default => 1
      t.belongs_to :element, :polymorphic => true
    end
  end

  def self.down
    drop_table :statistic_counters
  end
end
