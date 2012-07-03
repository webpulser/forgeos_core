define 'forgeos/core/admin/popins', ['jquery', 'forgeos/jqueryui/jquery.ui.dialog'], ($) ->

  init_default_dialog = ->
    $(".lightbox-container").dialog
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
