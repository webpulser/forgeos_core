require 'test_helper'

class StatisticCounterTest < ActiveSupport::TestCase
  test "should initialize with current date" do
    statistic_counter = StatisticCounter.new
    assert_equal Date.current, statistic_counter.date
  end

  test "should save to increment counter" do
    statistic_counter = StatisticCounter.new(:element => people(:user))
    statistic_counter.increment_counter
    assert statistic_counter.valid?
    assert !statistic_counter.new_record?
    assert_equal 1, statistic_counter.counter
  end

  test "should increment counter" do
    statistic_counter = StatisticCounter.new(:element => people(:user))
    statistic_counter.increment_counter
    statistic_counter2 = StatisticCounter.new(:element => people(:user))
    statistic_counter2.increment_counter

    statistic_counter.reload
    assert_equal 2, statistic_counter.counter
  end

end
