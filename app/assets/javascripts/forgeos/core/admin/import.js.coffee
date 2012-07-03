define 'forgeos/core/admin/import', ['jquery'], ($) ->
  update_form_action = ->
    $("form#import_form").attr "action", "import/create_" + $("select#import_model").val()
    $("select#import_model").live "change", ->
      $("form#import_form").attr "action", "import/create_" + @value

  initialize = ->
    update_form_action()

  # public methods
  new: initialize
