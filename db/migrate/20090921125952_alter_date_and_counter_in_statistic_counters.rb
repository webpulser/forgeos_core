class AlterDateAndCounterInStatisticCounters < ActiveRecord::Migration
  def self.up
    change_table :statistic_counters do |t|
      t.change 'counter', :integer ,:default => 1
    end
  end

  def self.down
    change_table :statistic_counters do |t|
      t.change 'counter', :integer, :default => nil
    end
  end
end
