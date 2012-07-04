define 'forgeos/core/admin/datatables', ['jquery'], ($) ->

  default_row_callback = (nRow, aData, iDisplayIndex) ->
    table = $("#" + @sInstance)
    table = $(this)  if typeof (table) is "undefined"
    div = $(nRow).find(":regex(id,.+_\\d+)")
    unless div.length is 0
      div_id = div[0].id
      row_id = "row_" + div_id
      $(nRow).attr "id", row_id

    # Draggable Rows
    if table.hasClass("draggable_rows")
      require ['forgeos/jqueryui/jquery.ui.draggable'], ->
        $(nRow).draggable
          revert: "invalid"
          cursor: "move"
          handle: ".handler"
          cursorAt:
            top: 15
            left: 75

          helper: (e) ->
            element = $($(e.currentTarget).find("td a")[0])
            title = element.text()
            "<div class=\"ui-helper ui-corner-all\"><span class=\"handler\"><span class=\"inner\">&nbsp;</span></span>" + title + "</div>"

          start: (event, ui) ->
            $("#page").addClass "sidebar_dragg"
            $(this).addClass "dragging"

          stop: (event, ui) ->
            $("#page").removeClass "sidebar_dragg"
            $(this).removeClass "dragging"

    # Selectable Rows
    if table.hasClass("selectable_rows")
      table.data "selected_rows", []  if typeof (table.data("selected_rows")) is "undefined"
      datable_datas = table.data("selected_rows")
      index = $(nRow).attr("id")
      if $.inArray(index, datable_datas) < 0
        $(nRow).children("td:first").append "<input id=\"select_" + $(nRow).attr("id") + "\" type=\"checkbox\" name=\"none\"/>"
      else
        $(nRow).addClass "row_selected"
        $(nRow).children("td:first").append "<input id=\"select_" + $(nRow).attr("id") + "\" type=\"checkbox\" name=\"none\" checked=\"checked\"/>"

      $(nRow).click ->
        $(this).dataTableToggleselect()

      $(nRow).find("input[type=checkbox]").click ->
        $(this).attr "checked", (if $(this).is(":checked") then 0 else 1)

    nRow

  update_current_dataTable_source = (selector, source) ->
    current_table = $(selector).dataTableInstance()
    current_table.fnSettings().sAjaxSource = source
    current_table.fnDraw()

  hide_paginate = (dataTables) ->
    pagination = $(dataTables.nPaginateList).parents(":first")
    pages_number = dataTables.nPaginateList.children.length
    (if (pages_number > 1) then pagination.show() else pagination.hide())

  dataTableSelectRows = (selector, callback) ->
    current_table = $(selector).dataTableInstance()
    source = current_table.fnSettings().sAjaxSource
    ids = []
    $($(selector).data("selected_rows")).each ->
      ids.push @split("_").slice(-1)  if @split

    current_table.fnSettings().sAjaxSource = source + "&ids=" + ids.join(",")
    current_table.fnSettings().fnDrawCallback = ->
      indexes = current_table.fnGetSelectedIndexes()
      callback current_table, indexes
      current_table.fnUnSelectNodes()
      current_table.fnSettings().sAjaxSource = source
      current_table.fnClearTable()

    current_table.fnDraw()

  save_category_sort = (type, id_pos) ->
    return true  if typeof (type) is "undefined"
    current_table = $("#table").dataTableInstance()
    url = current_table.fnSettings().sAjaxSource
    params = get_json_params_from_url(url)
    positions = []
    nNodes = current_table.fnGetNodes()
    i = 0
    while i < nNodes.length
      node = nNodes[i]
      pos = current_table.fnGetPosition(node)
      positions.push current_table.fnGetData(pos).slice(id_pos, id_pos + 1)
      i++
    $.ajax
      url: _forgeos_js_vars.mount_paths.core + "/admin/categories/" + params.category_id
      data:
        "category[element_ids][]": positions

      dataType: "json"
      type: "put"

  # Extend dataTables API to add
  # selection feature
  extend_datatables = ->
    extend_jquery()
    $.fn.dataTableExt.oApi.fnGetSelectedNodes = ->
      aReturn = new Array()
      aTrs = $(this).dataTableInstance().fnGetNodes()
      i = 0

      while i < aTrs.length
        aReturn.push aTrs[i]  if $(aTrs[i]).hasClass("row_selected")
        i++
      aReturn

    $.fn.dataTableExt.oApi.fnUnSelectNodes = ->
      aTrs = $(this).dataTableInstance().fnGetSelectedNodes()
      i = 0

      while i < aTrs.length
        $(aTrs[i]).dataTableUnselect()
        i++

    $.fn.dataTableExt.oApi.fnGetSelectedIndexes = ->
      aReturn = new Array()
      aTrs = $(this).dataTableInstance().fnGetNodes()
      i = 0

      while i < aTrs.length
        aReturn.push i  if $(aTrs[i]).hasClass("row_selected")
        i++
      aReturn

  # Extend dataSlides API to add
  # selection feature
  extend_dataslides = ->
    extend_jquery()
    $.fn.dataSlideExt.oApi.fnGetSelectedNodes = ->
      aReturn = new Array()
      aTrs = $(this).dataTableInstance().fnGetNodes()
      i = 0

      while i < aTrs.length
        aReturn.push aTrs[i]  if $(aTrs[i]).hasClass("row_selected")
        i++
      aReturn

    $.fn.dataSlideExt.oApi.fnUnSelectNodes = ->
      aTrs = $(this).dataTableInstance().fnGetSelectedNodes()
      i = 0

      while i < aTrs.length
        $(aTrs[i]).dataTableUnselect()
        i++

    $.fn.dataSlideExt.oApi.fnGetSelectedIndexes = ->
      aReturn = new Array()
      aTrs = $(this).dataTableInstance().fnGetNodes()
      i = 0

      while i < aTrs.length
        aReturn.push i  if $(aTrs[i]).hasClass("row_selected")
        i++
      aReturn

  extend_jquery = ->
    unless $.fn.dataTableInstance?
      $.fn.extend
        dataTableInstance: ->
          element = this
          oTable = `undefined`
          $(oTables).each ->
            oTable = this  if $(this).attr("id") is $(element).attr("id")

          oTable

    unless $.fn.dataTableSelect?
      $.fn.extend
        dataTableSelect: ->
          $(this).addClass "row_selected"
          checkbox = $(this).find("input[type=checkbox]")
          checkbox.attr "checked", 1
          datatable = $(this).parents(".datatable").dataTableInstance()
          datable_datas = $(this).parents(".datatable").data("selected_rows")
          index = $(this).attr("id")
          datable_datas.push index

    unless $.fn.dataTableUnselect?
      $.fn.extend
        dataTableUnselect: ->
          $(this).removeClass "row_selected"
          checkbox = $(this).find("input[type=checkbox]")
          checkbox.attr "checked", 0
          datatable = $(this).parents(".datatable").dataTableInstance()
          datable_datas = $(this).parents(".datatable").data("selected_rows")
          index = $(this).attr("id")
          index_in_table = $.inArray(index, datable_datas)
          datable_datas.splice index_in_table, 1

    unless $.fn.dataTableToggleselect?
      $.fn.extend
        dataTableToggleselect: ->
          row = $(this)
          if row.hasClass("row_selected")
            row.dataTableUnselect()
          else
            row.dataTableSelect()

    $.expr[":"].regex = (elem, index, match) ->
      matchParams = match[3].split(",")
      validLabels = /^(data|css):/
      attr =
        method: (if matchParams[0].match(validLabels) then matchParams[0].split(":")[0] else "attr")
        property: matchParams.shift().replace(validLabels, "")

      regexFlags = "ig"
      regex = new RegExp(matchParams.join("").replace(/^\s+|\s+$/g, ""), regexFlags)
      regex.test $(elem)[attr.method](attr.property)

    $.fn.unwrap = ->
      this.parent(':not(body)').each ->
        $(this).replaceWith( this.childNodes )

      return this

  setup_datatables = ->
    tables = $('.datatable')
    slides = $('.dataslide')
    window.oTables = [] unless oTables?

    if tables.length > 0
      require ['jquery.dataTables.min'], ->
        extend_datatables()
        tables.each ->
          target = $(this)
          if target.dataTableInstance()?
            oTable.fnDraw()
          else
            table = target.dataTable target.data('datatable-options')

            if table?
              oTables.push table
              oTable = table

    if slides.length > 0
      require ['forgeos/jquery.dataSlides'], ->
        extend_dataslides()
        slides.each ->
          target = $(this)
          if target.dataTableInstance()?
            oTable.fnDraw()
          else
            table = target.dataSlide target.data('dataslide-options')

            if table?
              oTables.push table
              oTable = table



  bind_destroy_row = ->
    $('a.icon-trash').live 'ajax:success', ->
      link = $(this)
      current_table = link.parents("table:first").dataTableInstance()
      current_table.fnDeleteRow current_table.fnGetPosition(link.parents("tr:first")[0])
      require ['forgeos/core/admin/notifications'], (Notifications) ->
        Notifications.new()

  bind_select_all = ->
    $('a.datatable-select-all').click (e) ->
      e.preventDefault()
      if id = $(this).data('tree-id')
        select_all_elements_without_category(id)

  bind_library_type_switch = ->
    $('a.library-change-type').click (e) ->
      e.preventDefault()
      if id = $(this).data('table-id') and url = $(this).attr('href')
        update_current_dataTable_source(id, url)

  initialize = ->
    bind_destroy_row()
    bind_library_type_switch()
    bind_select_all()
    setup_datatables()

  # public methods
  new: initialize
  update_current_dataTable_source: update_current_dataTable_source
