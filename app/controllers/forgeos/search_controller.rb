module Forgeos
  class SearchController < ApplicationController
    before_filter :init_index, :only => :index
    def index
      @search_keyword = SearchKeyword.find_by_keyword(@keywords) || SearchKeyword.create(:keyword => @keywords)
      @search_keyword.search_keyword_counters.new.increment_counter
    end

  private
    def init_index
      @items = []
      @keywords = params[:keywords]
      render if @keywords.blank?
    end
  end
end
