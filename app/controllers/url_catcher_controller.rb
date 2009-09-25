class UrlCatcherController < ApplicationController
  after_filter :visitor_count

  def visitor_count
    logger.debug('count'+'***'*1000)
    unless cookies[:visitor_counter]
      VisitorCounter.new.increment_counter
      cookies[:visitor_counter] = true
    end
  end
end
