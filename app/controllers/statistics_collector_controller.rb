class StatisticsCollectorController < ActionController::Base
  def index
    if klass = params[:type].classify.constantize
      cookie_name = "seen_#{params[:type].pluralize}".to_sym
      if object = klass.find_by_id(params[:id]) and
        (cookies[cookie_name].blank? or
         !cookies[cookie_name].split(',').include?(object.id.to_s))
        object.viewed_counters.new.increment_counter
        cookies[cookie_name] ||= ""
        cookies[cookie_name] += ",#{object.id}"
      end
    end
    render(:nothing => true)
  end
end
