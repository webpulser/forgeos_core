define 'forgeos/core/admin/base', ['jquery', 'forgeos/jqueryui/jquery.effects.explode', 'jquery_ujs'], ($) ->
  capitalize = (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)

  change_rule = (element, name) ->
    selected = $(element).val().replace(/\s+/g, "")
    condition = $(element).parent().parent()
    condition.html ""
    condition.append $(".rule-" + selected + ".pattern").html()
    check_icons "rule-conditions"
    check_icons "end-conditions"

  get_id_from_rails_url = ->
    numbers = document.location.pathname.match(/\d+/)
    (if not numbers? then "" else numbers[0])

  get_json_params_from_url = (url) ->
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

  get_rails_attribute_from_name = (name) ->
    attributes = name.split("[")
    attributes[attributes.length - 1].replace "]", ""

  get_rails_element_id = (element) ->
    id = $(element).attr("id")
    unless typeof (id) is "undefined"
      id = id.split("_")
      id[id.length - 1]
    else
      ""
  get_rails_element_ids = (list) ->
    ids = new Array()
    i = 0

    while i < list.length
      ids.push get_rails_element_id(list[i])
      i++
    ids

  jquery_obj_to_str = (obj) ->
    $("<div>").append($(obj).clone()).remove().html()

  stringify_params_from_json = (json_params) ->
    params = []
    JSON.stringify json_params, (key, value) ->
      params.push key + "=" + value  if key and value
      value

    params.join "&"

  remove_rails_nested_object = (selector) ->
    line = $(selector)
    del = line.find("input.destroy")
    if del.length > 0
      del.val 1
      tmce_unload_children selector
      line.hide "explode", {}, 3000
    else
      line.hide "explode", {}, 3000, ->
        $(this).remove()

  update_block_container_positions = (container) ->
    $(container).children(".block-container:visible").each ->
      index = $(this).parent().children(".block-container:visible").index(this)
      item_position = $(this).find("input:regex(id,.+_position)")
      item_position.val index


  # public methods
  capitalize:                       capitalize
  change_rule:                      change_rule
  get_id_from_rails_url:            get_id_from_rails_url
  get_json_params_from_url:         get_json_params_from_url
  get_rails_attribute_from_name:    get_rails_attribute_from_name
  get_rails_element_id:             get_rails_element_id
  get_rails_element_ids:            get_rails_element_ids
  jquery_obj_to_str:                jquery_obj_to_str
  stringify_params_from_json:       stringify_params_from_json
  remove_rails_nested_object:       remove_rails_nested_object
  update_block_container_positions: update_block_container_positions

