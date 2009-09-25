class UrlCatcherController < ApplicationController
  after_filter :visitor_count

  def visitor_count
    unless cookies[:visitor_counter]
      VisitorCounter.new.increment_counter
      cookies[:visitor_counter] = true
    end
  end
end
