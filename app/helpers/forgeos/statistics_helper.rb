module Forgeos
  module StatisticsHelper
    def statistics_collector_tag(object)
      javascript_include_tag(forgeos_core.statistics_collector_path(:type => object.class.to_s.gsub(/.*::/,'').underscore, :id => object.id))
    end
  end
end
