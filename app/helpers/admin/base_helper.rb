module Admin::BaseHelper
  def hide_html_elements_onload(element_ids)
    return javascript_tag("$('##{element_ids.join(",#")}').hide()")
  end 

  def link_to_effect_toggle(title,element_id,effect = :toggle_appear )
    return link_to_function(title,visual_effect(effect,element_id))
  end

  def yield_for_tools
    content_for :tools, link_to(I18n.t('back').capitalize,:back, :class => 'back')
    out = ''
    @content_for_tools.each do |content|
      out += content_tag('li', content) unless content.blank?
    end
    return out
  end
  
  def build_menu
    Forgeos::AdminMenu.each do |tab|
      content_for :menu, menu_item(tab.dup)
    end
  end

  def dataTables_tag(columns_count=1, options = {})

    id = options[:id].nil? ? 'table' : options[:id]
    action_column = options[:action_column].nil? ? true : options[:action_column]
    sorting = options[:sorting].nil? ? false : options[:sorting]

    #columns_count -= 1 if action_column
    columns = columns_count.times.collect{'null'}
    #columns << "{ 'bSearchable': false, 'bSortable': false }" if action_column
    columns[0] = "{ 'bVisible': false, 'sType': 'numeric' }" if sorting

    javascript_tag "
    $(function(){
      oTable = $('##{id}').dataTable({
        'sPaginationType': 'full_numbers',
        'sDom': \"<'top'if>t<'bottom'p<'clear'>\",
        'aoColumns': [ #{columns.join(',')} ],
        'sProcessing': true,
        'bServerSide': true,
        'sAjaxSource': '#{options[:url]}',
        'fnDrawCallback': DataTablesDrawCallBack,
        'oLanguage': {
          'sProcessing' : '#{I18n.t('jquery.dataTables.oLanguage.sProcessing')}',
          'sLengthMenu':'#{I18n.t('jquery.dataTables.oLanguage.sLengthMenu')}',
          'sZeroRecords':'#{I18n.t('jquery.dataTables.oLanguage.sZeroRecords')}',
          'sInfo':'#{I18n.t('jquery.dataTables.oLanguage.sInfo')}',
          'sInfoEmpty':'#{I18n.t('jquery.dataTables.oLanguage.sInfoEmpty')}',
          'sSearch':''
        }
      });
    });"
  end
end
