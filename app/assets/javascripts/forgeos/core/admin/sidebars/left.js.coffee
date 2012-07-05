define 'forgeos/core/admin/sidebars/left', ['jquery'], ($) ->

  bind_create_action = ->
    # TODO replace with bootstrap dropdown
    $(".create-action").bind "click", ->
      unless $(".create-list").hasClass("displayed")
        $(".update-list").removeClass "displayed"
        $(".create-list").addClass "displayed"
        $(".update-list").find(".shadow").hide()
        $(this).find(".shadow").show()
      else
        $(".create-list").removeClass "displayed"
        $(this).find(".shadow").hide()

  bind_update_action = ->
    $(".update-action").live "click", ->
      unless $(".update-list").hasClass("displayed")
        $(".create-list").removeClass "displayed"
        $(".update-list").addClass "displayed"
        $(".create-list").find(".shadow").hide()
        $(this).find(".shadow").show()
      else
        $(".update-list").removeClass "displayed"
        $(this).find(".shadow").hide()

  bind_widget_action = ->
    $(".widget-action").live "click", ->
      unless $(".widget-types").hasClass("displayed")
        $(".create-list").removeClass "displayed"
        $(".widget-types").addClass "displayed"
      else
        $(".widget-types").removeClass "displayed"

  bind_select_choice = ->
    $(".select_choice").live "click", ->
      unless $(this).find(".choices_list").hasClass("displayed")
        $(".choices_list").removeClass "displayed"
        $(this).find(".choices_list").addClass "displayed"
      else
        $(this).find(".choices_list").removeClass "displayed"

  bind_create_folder = ->
    # Create a new folder
    $(".create-folder, .create-smart").on "click", ->
      tree_id = $(this).data("tree_id")
      require ['jstree/jstree'], ->
        inst = $.jstree._reference(tree_id)
        selected = inst.get_selected()
        selected = -1 if selected.length is 0
        inst.create_node selected, {}, 'first', (new_node) ->
          edit = ->
            inst.edit new_node
          setTimeout(edit, 0)

  initialize = ->
    bind_create_folder()
    bind_create_action()
    bind_update_action()
    bind_select_choice()
    bind_widget_action()

  # public methods
  new: initialize
