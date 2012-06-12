jQuery(document).ready ->

  # TODO replace with bootstrap dropdown
  jQuery(".create-action").bind "click", ->
    unless jQuery(".create-list").hasClass("displayed")
      jQuery(".update-list").removeClass "displayed"
      jQuery(".create-list").addClass "displayed"
      jQuery(".update-list").find(".shadow").hide()
      jQuery(this).find(".shadow").show()
    else
      jQuery(".create-list").removeClass "displayed"
      jQuery(this).find(".shadow").hide()

  jQuery(".update-action").live "click", ->
    unless jQuery(".update-list").hasClass("displayed")
      jQuery(".create-list").removeClass "displayed"
      jQuery(".update-list").addClass "displayed"
      jQuery(".create-list").find(".shadow").hide()
      jQuery(this).find(".shadow").show()
    else
      jQuery(".update-list").removeClass "displayed"
      jQuery(this).find(".shadow").hide()

  jQuery(".widget-action").live "click", ->
    unless jQuery(".widget-types").hasClass("displayed")
      jQuery(".create-list").removeClass "displayed"
      jQuery(".widget-types").addClass "displayed"
    else
      jQuery(".widget-types").removeClass "displayed"

  jQuery(".select_choice").live "click", ->
    unless jQuery(this).find(".choices_list").hasClass("displayed")
      jQuery(".choices_list").removeClass "displayed"
      jQuery(this).find(".choices_list").addClass "displayed"
    else
      jQuery(this).find(".choices_list").removeClass "displayed"

  # Create a new folder
  jQuery(".create-folder, .create-smart").live "click", ->
    tree_id = jQuery(this).data("tree-id")
    t = jQuery.jstree._reference(tree_id)
    if t.get_selected()
      t.create t.get_selected(), 0
    else
      t.create null, 0
