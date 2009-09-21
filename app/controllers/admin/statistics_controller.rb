class Admin::StatisticsController < Admin::BaseController
  before_filter :get_date, :only => :index
  def index
  end

private
  def get_date
    @date = Date.current
  end
end
