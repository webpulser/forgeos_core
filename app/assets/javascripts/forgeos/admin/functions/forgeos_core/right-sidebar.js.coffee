window.submit_tag = (input) ->
  hidden_field_tag_name = "<input type=\"hidden\" name=\"tag_list[]\" value=\"" + input.val() + "\" />"
  destroy = "<a href=\"#\" class=\"big-icons gray-destroy\">&nbsp;</a>"
  new_tag = "<span >" + input.val() + hidden_field_tag_name + destroy + "</span>"
  jQuery(".tags .wrap_tags").append new_tag
  input.val ""
  tags = []
  jQuery(jQuery(input.form).serializeArray()).each ->
    tags.push input.value  if input.name is "tag_list[]" and input.value isnt ""

  element = jQuery("textarea:regex(id,.+_meta_info_attributes_keywords)")
  element.val tags.join(", ")  if element.is(":visible")
window.init_steps = ->
  throw "jsTree cookie: jQuery cookie plugin not included."  if typeof jQuery.cookie is "undefined"
  step = jQuery(this).parent()
  closed_panels_cookie = jQuery.cookie("closed_panels_list")
  if jQuery(this).parent().hasClass("disabled")
    jQuery(this).next().hide()
  else if closed_panels_cookie and closed_panels_cookie.match(step.attr("id"))
    jQuery(this).next().hide()
    step.toggleClass "open"
window.toggle_steps = ->
  unless jQuery(this).parent().hasClass("disabled")
    step = jQuery(this).parent()
    if step.hasClass("open")
      tmce_unload_children step
    else
      tmce_load_children step
    jQuery(this).next().toggle "blind"
    step.toggleClass "open"
    set_cookie_for_panels jQuery(this)
  false
window.set_cookie_for_panels = (panel) ->
  throw "jsTree cookie: jQuery cookie plugin not included."  if typeof jQuery.cookie is "undefined"
  closed_panels_cookie = jQuery.cookie("closed_panels_list")
  closed_panels_cookie = ""  unless closed_panels_cookie?
  step = panel.parent()
  closed_cookie_info = step.attr("id")
  unless step.hasClass("open")
    closed_panels_cookie += ";" + closed_cookie_info
  else
    closed_panels_cookie = closed_panels_cookie.replace(";" + closed_cookie_info, "")
  jQuery.cookie "closed_panels_list", closed_panels_cookie,
    path: window._forgeos_js_vars.mount_paths.core + "/admin/"
    expires: 10
