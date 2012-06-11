window.oTables = [] unless oTables?
jQuery(document).ready ->
  jQuery('.datatable').each ->
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
