define 'forgeos/core/admin/clicks', ['jquery'], ($) ->
  bind_gray_destroy = ->
    # Can be replaced by NestedForm
    $(".gray-destroy").live "click", ->
      $(this).parent().remove()
      false

  bind_destroy = ->
    $("a.destroy").live "click", (e) ->
      e.preventDefault()

      line = $($(this).parent())
      del = line.find("input.destroy")

      # hide nested form
      line.hide "highlight", speed: 3000, ->
        if del.length > 0
          # then mark for destruction
          del.val 1
        else
          # then remove nested_form
          $(this).remove()

      false

  bind_nested_form_buttons = ->
    buttons = $('form a.add_nested_fields, form a.remove_nested_fields')
    if buttons.length > 0
      require('jquery_nested_form')

  initialize = ->
    bind_nested_form_buttons()
    bind_gray_destroy()
    bind_destroy()


  # public methods
  new: initialize

