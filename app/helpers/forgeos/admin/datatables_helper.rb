module Forgeos
  module Admin
    module DatatablesHelper
      def dataTables_resultset(klass, collection = [], &block)
        resultset = {
          :sEcho => params[:sEcho],
          :iTotalRecords => klass.count,
          :iTotalDisplayRecords => collection.count,
          :aaData => collection.collect { |item| yield(item) }
        }
        raw resultset.to_json
      end

      def datatable(options = {})
        options[:id] ||= 'table'
        columns = options.delete(:columns)
        sort_col = options.delete(:sort_col) || 1
        sort_order = options.delete(:sort_order) || 'asc'

        save_state = options.delete(:save_state) || false
        per_page = options.delete(:per_page) || 50
        options.delete(:autostart)

        # data source
        datatable_options = {
          :sPaginationType => 'full_numbers',
          :sDom => "<'top'f>tpl<'clear'>i",
          :aoColumns => columns,
          :sProcessing => true,
          :iDisplayLength => per_page,
          :bLengthChange => true,
          :aaSorting => [[sort_col,sort_order]],
          :bStateSave => save_state,
          :bAutoWidth => false,
          :oLanguage => t('jquery.dataTables.oLanguage.sProcessing')
        }

        if source = options.delete(:url) and source.present?
          datatable_options[:bServerSide] = true
          datatable_options[:sAjaxSource] = source
          datatable_options[:fnDrawCallback] = 'DataTablesDrawCallBack'
          datatable_options[:fnRowCallback] = 'DataTablesRowCallBack'
        end

        datatable_options[:fnDrawCallback] = options.delete(:callback) if options[:callback].present?
        options[:"data-datatable-options"] = datatable_options.to_json
        options[:class] ||= ''
        options[:class] << ' datatable'
        options[:class] << ' selectable_rows' if options.delete(:selectable)
        options[:class] << ' draggable_rows' if options.delete(:draggable)

        content_tag(:table, options) do
          content_tag(:tr, content_tag(:td))
        end
      end

      def dataslide(options = {})
        options[:id] ||= 'table'
        columns = options.delete(:columns)

        save_state = options.delete(:save_state) || false
        per_page = options.delete(:per_page) || 12
        options.delete(:autostart)

        # data source
        datatable_options = {
          :sPaginationType => 'full_numbers',
          :sDom => "<'top'f>tpl<'clear'>i",
          :aoColumns => columns,
          :sProcessing => true,
          :iDisplayLength => per_page,
          :iDisplayEnd => per_page,
          :bLengthChange => true,
          :bStateSave => save_state,
          :bAutoWidth => false,
          :oLanguage => t('jquery.dataTables.oLanguage.sProcessing')
        }

        if source = options.delete(:url) and source.present?
          datatable_options[:bServerSide] = true
          datatable_options[:sAjaxSource] = source
          datatable_options[:fnDrawCallback] = 'DataTablesDrawCallBack'
          datatable_options[:fnRowCallback] = 'DataTablesRowCallBack'
        end

        options[:"data-dataslide-options"] = datatable_options.to_json

        options[:class] ||= ''
        options[:class] << ' table dataslide'
        options[:class] << ' selectable_rows' if options.delete(:selectable)
        options[:class] << ' draggable_rows' if options.delete(:draggable)

        content_tag(:div, '',options)
      end
    end
  end
end
