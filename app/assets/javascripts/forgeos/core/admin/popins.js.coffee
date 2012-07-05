define 'forgeos/core/admin/popins', ['jquery'], ($) ->

  init_default_dialog = ->
    dialogs = $(".lightbox-container")
    if dialogs.length > 0
      require ['jqueryui/jquery.ui.dialog'], ->
        dialogs.dialog
          autoOpen: false
          modal: true
          minHeight: 380
          width: 500
          resizable: "se"

  bind_blocks_tabs = ->
    $(".static-tab,.widget-tab").live "click", (e) ->
      e.preventDefault()
      toggleHoverlayTrees $(this).attr("class")

      false

  initialize = ->
    init_default_dialog()
    bind_blocks_tabs()

  #public methods
  new: initialize
