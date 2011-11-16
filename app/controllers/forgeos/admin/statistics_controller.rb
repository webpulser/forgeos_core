module Forgeos
  class Admin::StatisticsController < Admin::BaseController
    before_filter :get_date, :only => :index
    before_filter :get_keywords, :only => :index
    before_filter :get_graph, :only => :index

    def index
    end

    # generates the ofc2 graph
    def graph
      get_date
      # visitors
      visitors = @date.collect{|day| Forgeos::Statistics.total_of_visitors(day)}

      # Bar for visitors
      bar = ::OpenFlashChart::Bar.new
      bar.values  = visitors
      bar.tooltip = "#val# #{I18n.t('visitor', :count => 2)}"
      bar.colour  = '#F2B833'

      # Conf for Y left axis
      # calculates max number of visitors
      max_visitors = visitors.flatten.compact.max.to_i
      max_count_visitors = max_visitors > 0 ? max_visitors : 5

      return render :json => generate_graph(bar, [max_count_visitors], '#F7BD2E')
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
          [Date.current]
        else # week
          params[:timestamp] = 'week'
          Date.current.ago(1.week).to_date..Date.current
        end
    end

    def get_keywords
      @keywords = Forgeos::Statistics.keywords_most_searched(@date, 10)
    end

    def get_graph
      @graph = open_flash_chart_object(666, 250, forgeos_core.admin_statistics_graph_path(:timestamp => params[:timestamp]), true,'/assets/forgeos/flashes/')
    end

    def generate_graph(element, y_max, colour)
      # Conf for X axis
      steps = 4
      days_ratio = @date.to_a.size / steps
      days_step = (days_ratio) > 0 ? days_ratio : 1

      x_labels = ::OpenFlashChart::XAxisLabels.new
      x_labels.set_steps(days_step)
      case params[:timestamp]
      when 'week'
        x_labels.labels = @date.collect{|day| day.to_s(:short)}
      else
        x_labels.labels = @date.collect{|day| day.beginning_of_month == day ? day.to_s(:short) : day.to_s(:only_day)}
        x_labels.set_steps(10)
      end
      x_labels.colour = '#7D5223'

      x_axis = ::OpenFlashChart::XAxis.new
      x_axis.colour = '#7D5223'
      x_axis.grid_colour = '#C8A458'
      x_axis.set_steps(days_step)
      x_axis.set_stroke(1)
      x_axis.set_tick_height(0)
      x_axis.set_labels(x_labels)

      # Conf for Y axis
      y_axis = ::OpenFlashChart::YAxis.new
      y_axis.colour = '#F2B833'
      y_axis.set_range(0, y_max[0], (y_max[0])/4) if y_max
      y_axis.tick_length = 0
      y_axis.stroke = 0

      # Conf for Y right axis
      if y_max.size > 1
        y_axis_right = ::OpenFlashChart::YAxisRight.new
        y_axis_right.set_range(0, y_max[1], (y_max[1])/4) if y_max
        y_axis_right.tick_length = 0
        y_axis_right.stroke = 0
        y_axis_right.colour = '#94CC69'
        y_axis_right.set_label_text("#val# #{$currency.html}")
      end

      # Tooltip
      tooltip = ::OpenFlashChart::Tooltip.new
      tooltip.set_shadow(false)
      tooltip.stroke = 1
      tooltip.colour = '#000000'
      tooltip.set_background_colour("#ffffff")
      tooltip.set_title_style("{font-size: 10px; font-weight: normal; color: #000000;}")
      tooltip.set_body_style("{font-size: 12px; font-weight: bold; color: #000000;}")

      # Construct chart
      chart = ::OpenFlashChart::OpenFlashChart.new
      chart.set_bg_colour('#FEF7DB')
      chart.x_axis = x_axis
      chart.y_axis = y_axis
      chart.y_axis_right = y_axis_right
      chart.set_tooltip(tooltip)
      #chart.y_legend = { :text => 'toto' }
      #chart.y_legend_right = { :text => 'tata' }
      if element.is_a?(Array)
        element.each do |data|
          chart.add_element(data)
        end
      else
        chart.add_element(element)
      end

      return chart.render
    end

    def get_html(url, div_name, base, swf_file_name, width, height, protocol, obj_id)

      <<-HTML
      <div id="#{div_name}"></div>
      <script type="text/javascript">
        swfobject.embedSWF("#{base}#{swf_file_name}", "#{div_name}", "#{width}", "#{height}", "9.0.0", "expressInstall.swf",{"data-file":"#{url}"}, {"wmode":"transparent"});
      </script>
      HTML
    end

  end
end
