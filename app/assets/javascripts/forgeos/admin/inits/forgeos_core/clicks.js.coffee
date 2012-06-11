jQuery(document).ready ->
  # Can be replaced by NestedForm
  jQuery(".gray-destroy").live "click", ->
    jQuery(this).parent().remove()
    false

  jQuery("a.destroy").live "click", (e) ->
    e.preventDefault()
    line = jQuery(jQuery(this).parent())
    del = line.find("input.destroy")
    if del.length > 0
      del.val 1
      line.hide "highlight",
        speed: 3000
    else
      line.hide "highlight",
        speed: 3000
      , ->
        jQuery(this).remove()
    false
