window.removedataTablesRow = (selector) ->
  current_table = jQuery(selector).parents("table:first").dataTableInstance()
  current_table.fnDeleteRow current_table.fnGetPosition(jQuery(selector).parents("tr:first")[0])
  display_notifications()

window.DataTablesDrawCallBack = (table) ->
  showObjectsAssociated()
  moveDataTablesSearchField()

window.DataTablesRowCallBack = (nRow, aData, iDisplayIndex) ->
  table = jQuery("#" + @sInstance)
  table = jQuery(this)  if typeof (table) is "undefined"
  div = jQuery(nRow).find(":regex(id,.+_\\d+)")
  unless div.length is 0
    div_id = div[0].id
    row_id = "row_" + div_id
    jQuery(nRow).attr "id", row_id
  if table.hasClass("draggable_rows")
    jQuery(nRow).draggable
      revert: "invalid"
      cursor: "move"
      handle: ".handler"
      cursorAt:
        top: 15
        left: 75

      helper: (e) ->
        element = jQuery(jQuery(e.currentTarget).find("td a")[0])
        title = element.text()
        "<div class=\"ui-helper ui-corner-all\"><span class=\"handler\"><span class=\"inner\">&nbsp;</span></span>" + title + "</div>"

      start: (event, ui) ->
        jQuery("#page").addClass "sidebar_dragg"
        jQuery(this).addClass "dragging"

      stop: (event, ui) ->
        jQuery("#page").removeClass "sidebar_dragg"
        jQuery(this).removeClass "dragging"
  if table.hasClass("selectable_rows")
    table.data "selected_rows", []  if typeof (table.data("selected_rows")) is "undefined"
    datable_datas = table.data("selected_rows")
    index = jQuery(nRow).attr("id")
    if jQuery.inArray(index, datable_datas) < 0
      jQuery(nRow).children("td:first").append "<input id=\"select_" + jQuery(nRow).attr("id") + "\" type=\"checkbox\" name=\"none\"/>"
    else
      jQuery(nRow).addClass "row_selected"
      jQuery(nRow).children("td:first").append "<input id=\"select_" + jQuery(nRow).attr("id") + "\" type=\"checkbox\" name=\"none\" checked=\"checked\"/>"
    jQuery(nRow).click ->
      jQuery(this).toggleselect()

    jQuery(nRow).find("input[type=checkbox]").click ->
      jQuery(this).attr "checked", (if jQuery(this).is(":checked") then 0 else 1)
  nRow

window.update_current_dataTable_source = (selector, source) ->
  current_table = jQuery(selector).dataTableInstance()
  current_table.fnSettings().sAjaxSource = source
  current_table.fnDraw()

window.hide_paginate = (dataTables) ->
  pagination = jQuery(dataTables.nPaginateList).parents(":first")
  pages_number = dataTables.nPaginateList.children.length
  (if (pages_number > 1) then pagination.show() else pagination.hide())

window.dataTableSelectRows = (selector, callback) ->
  current_table = jQuery(selector).dataTableInstance()
  source = current_table.fnSettings().sAjaxSource
  ids = []
  jQuery(jQuery(selector).data("selected_rows")).each ->
    ids.push @split("_").slice(-1)  if @split

  current_table.fnSettings().sAjaxSource = source + "&ids=" + ids.join(",")
  current_table.fnSettings().fnDrawCallback = ->
    indexes = current_table.fnGetSelectedIndexes()
    callback current_table, indexes
    current_table.fnUnSelectNodes()
    current_table.fnSettings().sAjaxSource = source
    current_table.fnSettings().fnDrawCallback = DataTablesDrawCallBack
    current_table.fnClearTable()

  current_table.fnDraw()

window.save_category_sort = (type, id_pos) ->
  return true  if typeof (type) is "undefined"
  current_table = jQuery("#table").dataTableInstance()
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
  jQuery.ajax
    url: window._forgeos_js_vars.mount_paths.core + "/admin/categories/" + params.category_id
    data:
      "category[element_ids][]": positions

    dataType: "json"
    type: "put"

window.replaceDataTablesSearchField = (field_selector, input_selector, _parent) ->
  input = jQuery(input_selector)
  field = jQuery(field_selector)
  unless input.size() is 0
    field.html input.clone(true)
    field.append("<a href=\"#\" class=\"backgrounds button-ok\">OK</a>").find(".button-ok").data("parent", _parent).live "click", toggle_search_elements_ok
    input.remove()

window.moveDataTablesSearchField = ->
  replaceDataTablesSearchField ".search-form", "#table_wrapper .dataTables_filter", ""
  replaceDataTablesSearchField ".search-form-image", "#image-table_wrapper .dataTables_filter", "image"
  replaceDataTablesSearchField ".search-form-thumbnails", "#thumbnail-table_wrapper .dataSlides_filter", "thumbnails"
  replaceDataTablesSearchField ".search-form-files", "#table-files_wrapper .dataTables_filter", "files"
  jQuery(".search-link").live "click", toggle_search_elements

jQuery.fn.dataTableExt.oSort["currency-asc"] = (a, b) ->
  x = a.replace(/€/g, "")
  y = b.replace(/€/g, "")
  x = parseFloat(x)
  y = parseFloat(y)
  x - y

jQuery.fn.dataTableExt.oSort["currency-desc"] = (a, b) ->
  x = a.replace(/€/g, "")
  y = b.replace(/€/g, "")
  x = parseFloat(x)
  y = parseFloat(y)
  y - x

jQuery.fn.dataTableExt.oApi.fnGetSelectedNodes = ->
  aReturn = new Array()
  aTrs = jQuery(this).dataTableInstance().fnGetNodes()
  i = 0

  while i < aTrs.length
    aReturn.push aTrs[i]  if jQuery(aTrs[i]).hasClass("row_selected")
    i++
  aReturn

jQuery.fn.dataTableExt.oApi.fnUnSelectNodes = ->
  aTrs = jQuery(this).dataTableInstance().fnGetSelectedNodes()
  i = 0

  while i < aTrs.length
    jQuery(aTrs[i]).unselect()
    i++

jQuery.fn.dataTableExt.oApi.fnGetSelectedIndexes = ->
  aReturn = new Array()
  aTrs = jQuery(this).dataTableInstance().fnGetNodes()
  i = 0

  while i < aTrs.length
    aReturn.push i  if jQuery(aTrs[i]).hasClass("row_selected")
    i++
  aReturn

jQuery.fn.dataSlideExt.oApi.fnGetSelectedNodes = ->
  aReturn = new Array()
  aTrs = jQuery(this).dataTableInstance().fnGetNodes()
  i = 0

  while i < aTrs.length
    aReturn.push aTrs[i]  if jQuery(aTrs[i]).hasClass("row_selected")
    i++
  aReturn

jQuery.fn.dataSlideExt.oApi.fnUnSelectNodes = ->
  aTrs = jQuery(this).dataTableInstance().fnGetSelectedNodes()
  i = 0

  while i < aTrs.length
    jQuery(aTrs[i]).unselect()
    i++

jQuery.fn.dataSlideExt.oApi.fnGetSelectedIndexes = ->
  aReturn = new Array()
  aTrs = jQuery(this).dataTableInstance().fnGetNodes()
  i = 0

  while i < aTrs.length
    aReturn.push i  if jQuery(aTrs[i]).hasClass("row_selected")
    i++
  aReturn

jQuery.fn.extend
  dataTableInstance: ->
    element = this
    oTable = `undefined`
    jQuery(oTables).each ->
      oTable = this  if jQuery(this).attr("id") is jQuery(element).attr("id")

    oTable

  select: ->
    jQuery(this).addClass "row_selected"
    checkbox = jQuery(this).find("input[type=checkbox]")
    checkbox.attr "checked", 1
    datatable = jQuery(this).parents(".datatable").dataTableInstance()
    datable_datas = jQuery(this).parents(".datatable").data("selected_rows")
    index = jQuery(this).attr("id")
    datable_datas.push index

  unselect: ->
    jQuery(this).removeClass "row_selected"
    checkbox = jQuery(this).find("input[type=checkbox]")
    checkbox.attr "checked", 0
    datatable = jQuery(this).parents(".datatable").dataTableInstance()
    datable_datas = jQuery(this).parents(".datatable").data("selected_rows")
    index = jQuery(this).attr("id")
    index_in_table = jQuery.inArray(index, datable_datas)
    datable_datas.splice index_in_table, 1

  toggleselect: ->
    if jQuery(this).hasClass("row_selected")
      jQuery(this).unselect()
    else
      jQuery(this).select()

jQuery.expr[":"].regex = (elem, index, match) ->
  matchParams = match[3].split(",")
  validLabels = /^(data|css):/
  attr =
    method: (if matchParams[0].match(validLabels) then matchParams[0].split(":")[0] else "attr")
    property: matchParams.shift().replace(validLabels, "")

  regexFlags = "ig"
  regex = new RegExp(matchParams.join("").replace(/^\s+|\s+$/g, ""), regexFlags)
  regex.test jQuery(elem)[attr.method](attr.property)

jQuery.fn.unwrap = ->
  this.parent(':not(body)').each ->
    jQuery(this).replaceWith( this.childNodes )

  return this
