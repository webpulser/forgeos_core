define 'forgeos/core/admin/sidebars/right', ['jquery'], ($) ->
  init_steps = ->
    button = $(this)
    step = button.parent()
    id = step.attr("id")

    button.bind "click", toggle_steps

    require ['jquery.cookie'], ->
      closed_panels_cookie = $.cookie("closed_panels_list")

      if step.hasClass("disabled")
        button.next().hide()
      else if id? and closed_panels_cookie? and closed_panels_cookie.match(id)
        step.toggleClass "open"


  set_cookie_for_panels = (panel) ->
    require ['jquery.cookie'], ->
      closed_panels_cookie = $.cookie("closed_panels_list")
      closed_panels_cookie = ""  unless closed_panels_cookie?

      step = panel.parent()
      closed_cookie_info = step.attr("id")

      unless step.hasClass("open")
        closed_panels_cookie += ";" + closed_cookie_info
      else
        closed_panels_cookie = closed_panels_cookie.replace(";" + closed_cookie_info, "")

      # save closed panels states in a cookie
      $.cookie "closed_panels_list", closed_panels_cookie,
        path: _forgeos_js_vars.mount_paths.core + "/admin/"
        expires: 10

  submit_tag = (input) ->
    hidden_field_tag_name = "<input type=\"hidden\" name=\"tag_list[]\" value=\"" + input.val() + "\" />"
    destroy = "<a href=\"#\" class=\"big-icons gray-destroy\">&nbsp;</a>"
    new_tag = "<span >" + input.val() + hidden_field_tag_name + destroy + "</span>"
    $(".tags .wrap_tags").append new_tag
    input.val ""
    tags = []
    $($(input.form).serializeArray()).each ->
      tags.push input.value  if input.name is "tag_list[]" and input.value isnt ""

    element = $("textarea:regex(id,.+_meta_info_attributes_keywords)")
    element.val tags.join(", ")  if element.is(":visible")

  toggle_steps = (e) ->
    e.preventDefault()

    button = $(this)
    step = button.parent()

    unless step.hasClass("disabled")
      require ['forgeos/core/admin/editor'], (Editor) ->
        if step.hasClass("open")
          Editor.unload_children step
        else
          Editor.load_children step

      button.next().toggle "blind", ->
        step.toggleClass "open"

      set_cookie_for_panels button
    false

  initialize = ->
    $("a.icon-step-title, a.icon-panel").each init_steps

  # public methods
  new: initialize

