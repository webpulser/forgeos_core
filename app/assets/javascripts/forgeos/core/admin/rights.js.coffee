define 'forgeos/core/admin/rights', ['jquery', './base', './notifications'], ($, Base, Notifications) ->

  add_inline_form = (timestamp, url, method) ->
    $('body').append "<form action=\"#{url}\" id=\"#{timestamp}\" method=\"#{method}\" onsubmit=\"inline_save('#{timestamp}', '#{url}', '#{method}')\"></form>"

  bind_create = ->
    $(".create-right").live "click", (e) ->
      e.preventDefault()
      timestamp = new Date().getTime()

      add_inline_form timestamp, "#{window._forgeos_js_vars.mount_paths.core}/admin/rights", 'post'
      $("#table").prepend right_form(timestamp)

      false

  bind_edit = ->
    $(".edit-right").live "click", (e) ->
      e.preventDefault()
      row = $(this).parents("tr")
      right_id = Base.get_rails_element_id(row.find('td div.handler_container'))
      timestamp = new Date().getTime()

      add_inline_form timestamp, "#{window._forgeos_js_vars.mount_paths.core}/admin/rights/#{right_id}", 'put'

      row.hide()
      row.after right_form(timestamp, row)

      false

  bind_duplicate = ->
    $(".duplicate-right").live "click", (e) ->
      e.preventDefault()
      timestamp = new Date().getTime()
      row = $(this).parents("tr")
      add_inline_form timestamp, "#{window._forgeos_js_vars.mount_paths.core}/admin/rights", 'post'
      row.after right_form(timestamp, row)

      false

  # Discard inline crud
  inline_discard = (timestamp) ->
    row = $("#new_row_#{timestamp}").prev('tr:hidden')
    if row.length != 0
      row.show()

    $("##{timestamp}, #new_row_#{timestamp}").remove()

    return false

  inline_save = (timestamp, url, method) ->
    row = $("#new_row_#{timestamp}")
    form = $("##{timestamp}")
    form.html(row.clone(true))
    $.ajax
      success: (result) ->
        $('#table').dataTableInstance().fnDraw()
        form.remove()
      error: ->
        Notifications.new()
      data: form.serializeArray()
      dataType: 'script'
      type: method
      url: url

    return false

  right_form = (timestamp, row = null) ->
    if row?
      klass = (row.hasClass('odd') ? 'even' : 'odd')
      cell_name = row.children().get(1)
      cell_controller = row.children().get(2)
      cell_action = row.children().get(3)

      name = $(cell_name).children("div").html()
      controller = $(cell_controller).html()
      action = $(cell_action).html()
    else
      klass = 'even'
      name = ''
      controller = ''
      action = ''


    "<tr id='new_row_#{timestamp}' class='new_row #{klass}'>
    <td><i class='icon-legal'></i></td>
    <td><input type='text' value='#{name}' name='right[name]' size='25'/></td>
    <td><input type='text' value='#{controller}' name='right[controller_name]' size='25'/></td>
    <td><input type='text' value='#{action}' name='right[action_name]' size='15'/></td>
    <td>
      <a href='#' onclick=\"$('##{timestamp}').trigger('onsubmit')\"><i class='icon icon-ok-sign'></i></a>
      <a href='#' onclick=\"inline_discard('#{timestamp}')\"><i class='icon icon-remove-sign'></i></a>
    </td>
    </tr>"

  initialize = ->
    bind_create()
    bind_edit()
    bind_duplicate()

  # public methods
  new: initialize
