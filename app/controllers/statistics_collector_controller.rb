class StatisticsCollectorController < ActionController::Base
  def index
    if params[:type] and klass = params[:type].classify.constantize
      cookie_name = "seen_#{params[:type].pluralize}".to_sym
      if klass.respond_to?(:find_by_id) and
        object = klass.find_by_id(params[:id]) and
        (
          cookies[cookie_name].blank? or
          !cookies[cookie_name].split(',').include?(object.id.to_s)
        )

        object.viewed_counters.new.increment_counter
        cookies[cookie_name] = {
          :value => (cookies[cookie_name] || '') + ",#{object.id}",
          :expires => Date.current.end_of_day
        }
      end
    end
    render(:nothing => true)
  end
end
