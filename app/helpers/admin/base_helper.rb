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

  def dataTables_tag(columns_count)
    javascript_tag "
    $(function(){
      oTable = $('#table').dataTable({ 
        'aoColumns': [#{' null,'*(columns_count-1)} { 'bSearchable': false, 'bSortable': false } ],
        'oLanguage': { 
          'sProcessing' : '#{I18n.t('jquery.dataTables.oLanguage.sProcessing')}',
          'sLengthMenu':'#{I18n.t('jquery.dataTables.oLanguage.sLengthMenu')}',
          'sZeroRecords':'#{I18n.t('jquery.dataTables.oLanguage.sZeroRecords')}',
          'sInfo':'#{I18n.t('jquery.dataTables.oLanguage.sInfo')}',
          'sInfoEmpty':'#{I18n.t('jquery.dataTables.oLanguage.sInfoEmpty')}',
          'sSearch':'#{I18n.t('jquery.dataTables.oLanguage.sSearch')}'
        }
      });
    });"
  end
end
