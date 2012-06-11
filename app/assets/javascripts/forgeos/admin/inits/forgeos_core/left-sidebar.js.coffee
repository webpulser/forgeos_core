jQuery(document).ready ->
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

  jQuery(".create-folder, .create-smart").live "click", ->
    tree_id = jQuery(".category-tree").attr("id")
    t = jQuery.jstree._reference(tree_id)
    if t.get_selected()
      t.create t.get_selected(), 0
    else
      t.create null, 0

  jQuery(".modify-folder").live "click", ->
    t = jQuery.jstree._focused()
    if t.get_selected()
      t.rename t.get_selected()
    else
      error_on_jsTree_action "please select a category first"

  jQuery(".delete-folder").live "click", ->
    t = jQuery.jstree._focused()
    if t.get_selected()
      t.remove t.get_selected()
    else
      error_on_jsTree_action "please select a category first"

  jQuery(".duplicate-folder").live "click", ->
    t = jQuery.jstree._focused()
    if t.get_selected()
      t.copy()
      t.paste -1
    else
      error_on_jsTree_action "please select a category first"
