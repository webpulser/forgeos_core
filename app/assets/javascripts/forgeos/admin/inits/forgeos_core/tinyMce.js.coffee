jQuery(document).ready ->
  jQuery("textarea.mceEditor").each ->
    tmceInit "#" + jQuery(this).attr("id")
  jQuery('.tiny-mce.select-thumb').click (e) ->
    e.preventDefault()
    select_thumb this
  jQuery('.tiny-mce.select-image').click (e) ->
    e.preventDefault()
    select_image this
  jQuery('.tiny-mce.select-thumb').click (e) ->
    e.preventDefault()
    cancel_image this
