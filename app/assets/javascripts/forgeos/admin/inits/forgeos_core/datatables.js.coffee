window.oTables = [] unless oTables?
jQuery(document).ready ->
  jQuery('a.icon-trash').live 'ajax:success', ->
    link = jQuery(this)
    current_table = link.parents("table:first").dataTableInstance()
    current_table.fnDeleteRow current_table.fnGetPosition(link.parents("tr:first")[0])
    display_notifications()

  jQuery('.dataslide,.datatable').each ->
    target = jQuery this
    if target.dataTableInstance()?
      oTable.fnDraw()
    else
      if target.hasClass('datatable')
        table = target.dataTable target.data('datatable-options')
      else
        table = target.dataSlide target.data('dataslide-options')

      if table?
        oTables.push table
        oTable = table

  jQuery('a.datatable-select-all').click (e) ->
    e.preventDefault()
    if id = jQuery(this).data('tree-id')
      select_all_elements_without_category(id)

  jQuery('a.library-change-type').click (e) ->
    e.preventDefault()
    if id = jQuery(this).data('table-id') and url = jQuery(this).attr('href')
      update_current_dataTable_source(id, url)
