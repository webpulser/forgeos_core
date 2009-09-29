class SearchKeyword < ActiveRecord::Base
  has_many :search_keyword_counters, :as => :element
end
