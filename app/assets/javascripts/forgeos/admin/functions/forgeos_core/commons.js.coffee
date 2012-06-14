window.get_rails_element_id = (element) ->
  id = jQuery(element).attr("id")
  unless typeof (id) is "undefined"
    id = id.split("_")
    id[id.length - 1]
  else
    ""
window.get_rails_element_ids = (list) ->
  ids = new Array()
  i = 0

  while i < list.length
    ids.push get_rails_element_id(list[i])
    i++
  ids

window.get_id_from_rails_url = ->
  numbers = document.location.pathname.match(/\d+/)
  (if not numbers? then "" else numbers[0])

window.get_rails_attribute_from_name = (name) ->
  attributes = name.split("[")
  attributes[attributes.length - 1].replace "]", ""

window.jquery_obj_to_str = (obj) ->
  jQuery("<div>").append(jQuery(obj).clone()).remove().html()

window.get_json_params_from_url = (url) ->
  url_params = url.split("?")[1]
  json_params = {}
  params = undefined
  if url_params
    params = (if url_params then url_params.split("&") else null)
    if params
      i = 0

      while i < params.length
        key = params[i].split("=")[0]
        value = params[i].split("=")[1]
        json_params[key] = value
        i++
  json_params

window.stringify_params_from_json = (json_params) ->
  params = []
  JSON.stringify json_params, (key, value) ->
    params.push key + "=" + value  if key and value
    value

  params.join "&"

window.capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

window.change_rule = (element, name) ->
  selected = jQuery(element).val().replace(/\s+/g, "")
  condition = jQuery(element).parent().parent()
  condition.html ""
  condition.append jQuery(".rule-" + selected + ".pattern").html()
  check_icons "rule-conditions"
  check_icons "end-conditions"


window.update_block_container_positions = (container) ->
  jQuery(container).children(".block-container:visible").each ->
    index = jQuery(this).parent().children(".block-container:visible").index(this)
    item_position = jQuery(this).find("input:regex(id,.+_position)")
    item_position.val index

window.remove_rails_nested_object = (selector) ->
  line = jQuery(selector)
  del = line.find("input.destroy")
  if del.length > 0
    del.val 1
    tmce_unload_children selector
    line.hide "explode", {}, 3000
  else
    line.hide "explode", {}, 3000, ->
      jQuery(this).remove()
