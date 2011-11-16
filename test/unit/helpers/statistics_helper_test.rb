require 'test_helper'

module Forgeos
  class StatisticsHelperTest < ActionView::TestCase
    include Forgeos::StatisticsHelper
    include Rails.application.routes.mounted_helpers

    test "should generate javascript include tag for statistics collection" do
      assert_equal "<script src=\"/statistics/user/227792459.js\" type=\"text/javascript\"></script>", statistics_collector_tag(forgeos_people(:user))
    end
  end
end
