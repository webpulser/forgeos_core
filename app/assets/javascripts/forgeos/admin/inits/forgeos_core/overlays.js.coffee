jQuery(document).ready ->
  jQuery(".lightbox-container").dialog
    autoOpen: false
    modal: true
    minHeight: 380
    width: 500
    resizable: "se"
  jQuery(".static-tab,.widget-tab").live "click", (e) ->
    e.preventDefault()
    toggleHoverlayTrees jQuery(this).attr("class")
    false
