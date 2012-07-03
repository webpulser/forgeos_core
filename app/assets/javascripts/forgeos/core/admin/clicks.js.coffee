define 'forgeos/core/admin/clicks', ['jquery', 'jquery_nested_form'], ($) ->
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


  # public methods
  new: ->
    bind_gray_destroy()
    bind_destroy()
