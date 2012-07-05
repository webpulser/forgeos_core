define 'forgeos/core/admin/datatables', ['jquery'], ($) ->

  default_row_callback = (nRow, aData, iDisplayIndex) ->
    table = $("#" + @sInstance)
    table = $(this)  if typeof (table) is "undefined"
    row = $(nRow)
    div = row.find(":regex(id,.+_\\d+)")

    unless div.length is 0
      div_id = div[0].id
      row_id = "row_" + div_id
      row.attr "id", row_id

    # Draggable Rows
    if table.hasClass("draggable_rows")
      require ['mustache', 'text!templates/admin/tables/drag_helper.html', 'jqueryui/jquery.ui.draggable'], (Mustache, drag_helper_tpl) ->
        row.draggable
          revert: "invalid"
          cursor: "move"
          handle: ".handler"
          cursorAt:
            top: 15
            left: 75

          helper: (e) ->
            element = $($(e.currentTarget).find("td a")[0])
            Mustache.render drag_helper_tpl,
              name: element.text()

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
      index = row.attr("id")
      require  ['mustache', 'text!templates/admin/tables/checkbox.html'], (Mustache, checkbox_tpl) ->
        if $.inArray(index, datable_datas) < 0
          selected = null
        else
          selected = 'checked'
          row.addClass "row_selected"

        row.children("td:first").append Mustache.render checkbox_tpl,
          id: row.attr('id')
          checked: selected

      row.click ->
        $(this).dataTableToggleselect()

      row.find("input[type=checkbox]").click ->
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
      require ['dataTables'], ->
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
      require ['dataSlides'], ->
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
      C
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

  select_all_elements_without_category = (tree_id) ->
    require ['forgeos/core/admin/base', 'jstree/jstree'], (Base) ->
      tree = $.jstree._reference(tree_id)
      tree.deselect_all() if tree

      table = $("##{tree_id}").parents('.row-fluid').find('.dataslide:visible,.datatable:visible')
      current_table = table.dataTableInstance()

      url = current_table.fnSettings().sAjaxSource
      url_base = url.split("?")[0]
      params = undefined
      params = Base.get_json_params_from_url(url)
      params.category_id = null
      params = Base.stringify_params_from_json(params)
      update_current_dataTable_source current_table, url_base + "?" + params
    $("#parent_id_tmp").remove()

    true


  initialize = ->
    bind_destroy_row()
    bind_library_type_switch()
    bind_select_all()
    setup_datatables()

  # public methods
  new: initialize
  update_current_dataTable_source: update_current_dataTable_source
