module Forgeos
  class Statistics
    def self.total_of_visitors(date = nil)
      VisitorCounter.sum(:counter, :conditions => { :date => date})
    end

    def self.keywords_most_searched(date = nil, limit = nil)
      SearchKeywordCounter.sum(:counter, :conditions => { :date => date}, :group => :element_id, :limit => limit)
    end
  end
end
