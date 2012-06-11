jQuery(document).ready ->
  jQuery("form#import_form").attr "action", "import/create_" + jQuery("select#import_model").val()
  jQuery("select#import_model").live "change", ->
    jQuery("form#import_form").attr "action", "import/create_" + @value
