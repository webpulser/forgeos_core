class SearchController < ApplicationController
  def index
    keywords = params[:keywords] || session[:keywords]
    session[:keywords] = keywords
    search_keyword = SearchKeyword.find_by_keyword(keywords) || SearchKeyword.create(:keyword => keywords)
    search_keyword.search_keyword_counters.new.increment_counter
    @items = []
  end
end
