jQuery(document).ready ->
  jQuery(".create-right").live "click", (e) ->
    e.preventDefault()
    timestamp = new Date().getTime()

    add_inline_form timestamp, "#{window._forgeos_js_vars.mount_paths.core}/admin/rights", 'post'
    jQuery("#table").prepend right_form(timestamp)

    false

  jQuery(".edit-right").live "click", (e) ->
    e.preventDefault()
    row = jQuery(this).parents("tr")
    right_id = get_rails_element_id(row.find('td div.handler_container'))
    timestamp = new Date().getTime()

    add_inline_form timestamp, "#{window._forgeos_js_vars.mount_paths.core}/admin/rights/#{right_id}", 'put'

    row.hide()
    row.after right_form(timestamp, row)

    false

  jQuery(".duplicate-right").live "click", (e) ->
    e.preventDefault()
    timestamp = new Date().getTime()
    row = jQuery(this).parents("tr")
    add_inline_form timestamp, "#{window._forgeos_js_vars.mount_paths.core}/admin/rights", 'post'
    row.after right_form(timestamp, row)

    false

  right_form = (timestamp, row = null) ->
    if row?
      klass = (row.hasClass('odd') ? 'even' : 'odd')
      cell_name = row.children().get(1)
      cell_controller = row.children().get(2)
      cell_action = row.children().get(3)

      name = jQuery(cell_name).children("div").html()
      controller = jQuery(cell_controller).html()
      action = jQuery(cell_action).html()
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
      <a href='#' onclick=\"jQuery('##{timestamp}').trigger('onsubmit')\"><i class='icon icon-ok-sign'></i></a>
      <a href='#' onclick=\"inline_discard('#{timestamp}')\"><i class='icon icon-remove-sign'></i></a>
    </td>
    </tr>"

  # Discard inline crud
  window.inline_discard = (timestamp) ->
    row = jQuery("#new_row_#{timestamp}").prev('tr:hidden')
    if row.length != 0
      row.show()

    jQuery("#new_row_#{timestamp}").remove()

    return false

  add_inline_form = (timestamp, url, method) ->
    jQuery('body').append "<form action=\"#{url}\" id=\"#{timestamp}\" method=\"#{method}\" onsubmit=\"inline_save('#{timestamp}', '#{url}', '#{method}')\"></form>"

  window.inline_save = (timestamp, url, method) ->
    row = jQuery("#new_row_#{timestamp}")
    form = jQuery("##{timestamp}").append(row.clone(true))
    jQuery.ajax
      success: (result) ->
        jQuery('#table').dataTableInstance().fnDraw()
        #jQuery('.create-right').parent().show()
      error: display_notifications
      data: form.serializeArray()
      dataType: 'script'
      type: method
      url: url

    return false
