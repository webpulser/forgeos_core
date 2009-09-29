class Admin::StatisticsController < Admin::BaseController
  before_filter :get_date, :only => :index
  before_filter :get_keywords, :only => :index

  def index
  end

private
  def get_date
    @date = 
      case params[:timestamp]
      when 'month'
        Date.current.ago(1.month).to_date..Date.current
      when 'yesterday'
        Date.yesterday..Date.current
      when 'today'
        Date.current..Date.current
      else # week
        params[:timestamp] = 'week'
        Date.current.ago(1.week).to_date..Date.current
      end
  end

  def get_keywords
    @keywords = Forgeos::Statistics.keywords_most_searched(@date, 10)
  end
end
