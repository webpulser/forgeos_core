jQuery(document).ready ->
  jQuery("textarea.mceEditor").each ->
    tmceInit "#" + jQuery(this).attr("id")
