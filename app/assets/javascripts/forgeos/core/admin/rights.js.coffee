define 'forgeos/core/admin/rights', ['jquery'], ($) ->

  add_inline_form = (timestamp, url, method) ->
    require ['mustache', 'text!templates/admin/rights/form.html'], (Mustache, template) ->
      form = Mustache.render template,
        url: url
        timestamp: timestamp
        method: method

      $('body').append form

    $("##{timestamp}").on 'submit', (e) ->
      e.preventDefault()
      save(timestamp, url, method)

      false

  bind_buttons = ->
    bind_create()
    bind_edit()
    bind_duplicate()
    bind_form_buttons()

  bind_create = ->
    $(".create-right").live "click", (e) ->
      e.preventDefault()
      timestamp = new Date().getTime()

      add_inline_form timestamp, "#{window._forgeos_js_vars.mount_paths.core}/admin/rights", 'post'
      right_form timestamp, null, (html) ->
        $("#table").prepend html

      false

  bind_edit = ->
    $(".edit-right").live "click", (e) ->
      e.preventDefault()
      row = $(this).parents("tr")
      require ['forgeos/core/admin/base'], (Base) ->
        right_id = Base.get_rails_element_id(row.find('td div.handler_container'))
        timestamp = new Date().getTime()

        add_inline_form timestamp, "#{window._forgeos_js_vars.mount_paths.core}/admin/rights/#{right_id}", 'put'
        row.hide()
        right_form timestamp, row, (html) ->
          row.after html

      false

  bind_duplicate = ->
    $(".duplicate-right").live "click", (e) ->
      e.preventDefault()
      timestamp = new Date().getTime()
      row = $(this).parents("tr")
      add_inline_form timestamp, "#{window._forgeos_js_vars.mount_paths.core}/admin/rights", 'post'
      right_form timestamp, row, (html) ->
        row.after html

      false

  bind_form_buttons = ->
    $('.inline_save').live 'click', (e) ->
      e.preventDefault()

      $($(this).attr('href')).trigger 'submit'

      false

    $('.inline_discard').live 'click', (e) ->
      e.preventDefault()

      cancel $(this).attr('href')
      false

  # Discard inline crud
  cancel = (timestamp) ->
    row = $("#new_row_#{timestamp}").prev('tr:hidden')
    if row.length != 0
      row.show()

    $("##{timestamp}, #new_row_#{timestamp}").remove()

    return false

  save = (timestamp, url, method) ->
    row = $("#new_row_#{timestamp}")
    form = $("##{timestamp}")
    form.html(row.clone(true))
    $.ajax
      success: (result) ->
        $('#table').dataTableInstance().fnDraw()
        form.remove()
      error: ->
        require ['forgeos/core/admin/notifications'], (Notifications) ->
          Notifications.new()
      data: form.serializeArray()
      dataType: 'script'
      type: method
      url: url

    return false

  right_form = (timestamp, row = null, block) ->
    if row?
      cell_name = row.children().get(1)
      cell_controller = row.children().get(2)
      cell_action = row.children().get(3)

      data =
        klass: (row.hasClass('odd') ? 'even' : 'odd')
        name: $(cell_name).children("div").html()
        controller: $(cell_controller).html()
        action: $(cell_action).html()
        timestamp: timestamp
    else
      data =
        klass: 'even'
        name: ''
        controller: ''
        action: ''
        timestamp: timestamp

    require ['mustache', "text!templates/admin/rights/new.html"], (Mustache, template) ->
      block(Mustache.render(template, data))


  initialize = ->
    bind_buttons()

  # public methods
  new: initialize
