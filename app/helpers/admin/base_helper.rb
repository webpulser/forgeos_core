module Admin::BaseHelper
  def Forgeos_save_buttons(back_path=admin_root_path)
    content_tag(:div, :class => 'interact-links') do
      fg_submit_tag('save_changes') + t('or') + link_to(t('cancel').capitalize, back_path, :class => 'back-link')
    end
  end

  def dataTables_tag(options = {})
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

    unless options[:callback].nil? or options[:callback].blank?
      data_source += "'fnDrawCallback': #{options[:callback]},"
    end

    javascript_tag "
    jQuery(document).ready(function(){
      var table = $('##{id}').dataTable({
        'sPaginationType': 'full_numbers',
        'sDom': \"<'top'if>t<'bottom'p<'clear'>\",
        'aoColumns': [ #{columns.join(',')} ],
        'sProcessing': true,
        'aaSorting': [[1,'asc']],
        'bStateSave': false,
        'bAutoWidth': false,
        #{data_source}
        'oLanguage': {
          'sProcessing' : '#{t('jquery.dataTables.oLanguage.sProcessing')}',
          'sLengthMenu':'#{t('jquery.dataTables.oLanguage.sLengthMenu')}',
          'sZeroRecords':'#{t('jquery.dataTables.oLanguage.sZeroRecords')}',
          'sInfo':'#{t('jquery.dataTables.oLanguage.sInfo')}',
          'sInfoEmpty':'#{t('jquery.dataTables.oLanguage.sInfoEmpty')}',
          'sSearch':''
        }
      });
      if(typeof oTables == 'undefined')
        oTables = new Array();

      oTables.push(table);
      oTable = oTables[0];
    });"
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

    javascript_tag "
    jQuery(document).ready(function(){
      var table = $('##{id}').dataSlide({
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
          'sSearch':''
        }
      });
      if(typeof oTables == 'undefined')
        oTables = new Array();

      oTables.push(table);
      oTable = oTables[0];
    });"
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
      link_to('', '#', :class => 'big-icons gray-destroy') +
      hidden_field_tag("#{model_name}[#{block_name}_ids][]", block.id, :class => 'block-selected')
    end
  end

  def Forgeos_save_buttons(back_path=admin_root_path)
    content_tag(:div, :class => 'interact-links') do
      fg_submit_tag('save_changes') + t('or') + link_to(t('cancel').capitalize, back_path, :class => 'back-link')
    end
  end

end
