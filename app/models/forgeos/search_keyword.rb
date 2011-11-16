module Forgeos
  class SearchKeyword < ActiveRecord::Base
    has_many :search_keyword_counters, :as => :element, :dependent => :destroy
  end
end
