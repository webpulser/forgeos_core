module Admin::BaseHelper
  include AttachmentHelper

  def dataTables_tag(options = {})
    id = options[:id].nil? ? 'table' : options[:id]
    columns = options[:columns]
    options[:sort_col].nil? ? sort_col = 1 : sort_col = options[:sort_col]
    options[:sort_order].nil? ? sort_order = 'asc' : sort_order = options[:sort_order]

    save_state = options[:save_state] || false
    per_page = options[:per_page] || 50

    # data source
    data_source = ''
    unless options[:url].nil? or options[:url].blank?
      data_source += "'bServerSide': true,"
      data_source += "'sAjaxSource': '#{options[:url]}',"
      data_source += "'fnDrawCallback': DataTablesDrawCallBack,"
      data_source += "'fnRowCallback': DataTablesRowCallBack,"
    end

    unless options[:callback].nil? or options[:callback].blank?
      data_source += "'fnDrawCallback': #{options[:callback]},"
    end

    dataTables_init_function = "initDataTables_on_#{id.gsub('-','_')}"

    javascript_tag "
      function #{dataTables_init_function}(){
        var target = jQuery('##{id}');
        if (typeof(target.dataTableInstance) != 'undefined' && typeof(target.dataTableInstance()) != 'undefined') {
          oTable.fnDraw();
        } else {
          var table = target.dataTable({
            'sPaginationType': 'full_numbers',
            'sDom': \"<'top'f>tpl<'clear'>i\",
            'aoColumns': [ #{columns.join(',')} ],
            'sProcessing': true,
            'iDisplayLength': #{per_page},
            'bLengthChange': true,
            'aaSorting': [[#{sort_col},'#{sort_order}']],
            'bStateSave': #{save_state},
            'bAutoWidth': false,
            #{data_source}
            'oLanguage': {
              'sProcessing' : '#{t('jquery.dataTables.oLanguage.sProcessing')}',
              'sLengthMenu':'#{t('jquery.dataTables.oLanguage.sLengthMenu')}',
              'sZeroRecords': '#{t('jquery.dataTables.oLanguage.sZeroRecords')}',
              'sInfo': '#{t('jquery.dataTables.oLanguage.sInfo')}',
              'sInfoEmpty': '#{t('jquery.dataTables.oLanguage.sInfoEmpty')}',
              'sSearch': '#{t('jquery.dataTables.oLanguage.sSearch')}',
              'oPaginate': {
                'sFirst': '#{t('jquery.dataTables.oLanguage.sFirst')}',
                'sPrevious': '#{t('jquery.dataTables.oLanguage.sPrevious')}',
                'sNext': '#{t('jquery.dataTables.oLanguage.sNext')}',
                'sLast': '#{t('jquery.dataTables.oLanguage.sLast')}'
              }
            }
          });
          oTables.push(table);
          oTable = table;
        }
      }

      jQuery(document).ready(function(){
        if(typeof(oTables) == 'undefined') {
          oTables = new Array();
        }
        jQuery('##{id}').data('dataTables_init_function','#{dataTables_init_function}');
        #{"eval(jQuery('##{id}').data('dataTables_init_function')+'()');" if options[:autostart] != false}
      });
    "
  end

  def dataSlides_tag(options = {})
    id = options[:id].nil? ? 'table' : options[:id]
    columns = options[:columns]

    # data source
    data_source = ''
    unless options[:url].nil? or options[:url].blank?
      data_source += "'bServerSide': true,"
      data_source += "'sAjaxSource': '#{options[:url]}',"
      data_source += "'fnDrawCallback': DataTablesDrawCallBack,"
      data_source += "'fnRowCallback': DataTablesRowCallBack,"
    end

    dataTables_init_function = "initDataSlides_on_#{id.gsub('-','_')}"

    javascript_tag "
      function #{dataTables_init_function}(){
        var target = jQuery('##{id}');
        if (typeof(target.dataTableInstance) != 'undefined' && typeof(target.dataTableInstance()) != 'undefined') {
          oTable.fnDraw();
        } else {
          var table = target.dataSlide({
            'sPaginationType': 'full_numbers',
            'sDom': \"<'top'if>t<'bottom'p<'clear'>\",
            'aoColumns': [ #{columns.join(',')} ],
            'sProcessing': true,
            'bStateSave': false,
            'bLengthChange': true,
            'iDisplayLength': 12,
            'iDisplayEnd': 12,
            #{data_source}
            'oLanguage': {
              'sProcessing' : '#{t('jquery.dataTables.oLanguage.sProcessing')}',
              'sLengthMenu':'#{t('jquery.dataTables.oLanguage.sLengthMenu')}',
              'sZeroRecords':'#{t('jquery.dataTables.oLanguage.sZeroRecords')}',
              'sInfo':'#{t('jquery.dataTables.oLanguage.sInfo')}',
              'sInfoEmpty':'#{t('jquery.dataTables.oLanguage.sInfoEmpty')}',
              'sSearch': '#{t('jquery.dataTables.oLanguage.sSearch')}',
              'oPaginate': {
                'sFirst': '#{t('jquery.dataTables.oLanguage.sFirst')}',
                'sPrevious': '#{t('jquery.dataTables.oLanguage.sPrevious')}',
                'sNext': '#{t('jquery.dataTables.oLanguage.sNext')}',
                'sLast': '#{t('jquery.dataTables.oLanguage.sLast')}'
              }
            }
          });
          oTables.push(table);
          oTable = table;
        }
      }

      jQuery(document).ready(function(){
        if(typeof(oTables) == 'undefined') {
          oTables = new Array();
        }
        jQuery('##{id}').data('dataTables_init_function','#{dataTables_init_function}');
        #{"eval(jQuery('##{id}').data('dataTables_init_function')+'()');" if options[:autostart] != false}
      });
    "
  end

  def fg_search
    label = content_tag(:span, t('search').capitalize, :class => 'small-icons search-span')
    link_to(label, '#', :class => 'small-icons left search-link')
  end

  def fg_submit_tag(label)
    submit_tag(t(label).capitalize, :class => 'backgrounds interact-button')
  end

  def block_container(model_name, block_name, block, &proc)
    content_tag :div, :class => 'block-container ui-corner-all' do
      content_tag(:span, :class => 'block-type') do
        content_tag(:span, content_tag(:span, '&nbsp;', :class => 'inner'), :class => 'handler') +
        block.class.human_name
      end +
      content_tag(:span, capture(&proc), :class => 'block-name') +
      link_to('', [:edit, :admin, block], :class => 'small-icons edit-link', :popup => true) +
      link_to('', '#', :class => 'big-icons gray-destroy') +
      hidden_field_tag("#{model_name}[#{block_name}_ids][]", block.id, :class => 'block-selected')
    end
  end

  def Forgeos_save_buttons(back_path=admin_root_path,label='save')
    content_tag(:div, :class => 'interact-links') do
      fg_submit_tag(label) + t('or') + link_to(t('cancel').capitalize, back_path, :class => 'back-link')
    end
  end

end

