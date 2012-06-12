window.toggleActivate = (selector) ->
  link = jQuery(selector)
  link.toggleClass "see-on"
  link.toggleClass "see-off"

window.showObjectsAssociated = ->
  jQuery(".plus").bind "click", ->
    element = jQuery(this)
    tr = element.parents("tr")
    tr.toggleClass "open"

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

window.toggle_search_elements = ->
  parent = jQuery(this).parents("#search")
  classe = parent.attr("class").split(" ")[1]
  parent.toggleClass "open"
  if classe isnt "" and classe isnt `undefined` and classe isnt "open"
    jQuery(".search-form-" + classe).toggle()
  else
    jQuery(".search-form").toggle()
  false

window.toggle_search_elements_ok = ->
  parent = jQuery(this).data("parent")
  unless parent is ""
    jQuery("#search." + parent).toggleClass "open"
    jQuery(".search-form-" + parent).toggle()
  else
    jQuery("#search").toggleClass "open"
    jQuery(".search-form").toggle()
  false

window.openStandardDialog = ->
  jQuery(".lightbox-container").dialog "open"
window.openimageUploadDialog = (link) ->
  forgeosInitUpload "#image"
  jQuery("#imageSelectDialog").dialog "open"
window.openfileUploadDialog = ->
  forgeosInitUpload "#file"
  jQuery("#fileSelectDialog").dialog "open"
window.closeDialogBox = ->
  jQuery(".lightbox-container").dialog "close"
window.toggleSelectedOverlay = (element) ->
  unless jQuery(element).hasClass("selected")
    jQuery(element).addClass "selected"
    jQuery(element).siblings().removeClass "selected"
window.add_picture_to_category = (data) ->
  category = jQuery(".add-image.current")
  jQuery.ajax
    success: (result) ->
      jQuery("#imageLeftSidebarSelectDialog").dialog "close"
      category.removeClass("add-image").removeClass "current"
      jQuery.jstree._focused().refresh category.parents("li:first")

    data:
      "category[attachment_ids][]": data.id

    dataType: "json"
    type: "put"
    url: window._forgeos_js_vars.mount_paths.core + "/admin/categories/" + get_rails_element_id(category) + ".json"

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
window.add_picture_to_element = (data) ->
  object_name = jQuery("form#wrap").data("object_name")
  input = jQuery(".add-image.current").data("input_name")
  jQuery(input + "-picture ul.sortable").html "<li><img src=\"" + data.path + "\" alt=\"" + data.name + "\"/><a href=\"#\" onclick=\"jQuery(this).parents('li').remove(); jQuery('" + input + "').val(null); return false;\" class=\"big-icons delete\"></a></li>"
  jQuery(input).val data.id
window.add_picture_to_visuals = (data) ->
  object_name = jQuery("form#wrap").data("object_name")
  jQuery("#visuals-picture ul.sortable").before "<li><a href=\"#\" onclick=\"jQuery(this).parents('li').remove(); return false;\" class=\"big-icons trash\"></a><input type=\"hidden\" name=\"" + object_name + "[attachment_ids][]\" value=\"" + data.id + "\"/><img src=\"" + data.path + "\" alt=\"" + data.name + "\"/><div class=\"handler\"><div class=\"inner\"></div></div></li>"

window.setup_upload_dialog = (selector) ->
  select_dialog = jQuery(selector + 'SelectDialog')
  upload_dialog = jQuery(selector + 'UploadDialog')
  uploader = jQuery(selector + 'Upload')

  upload_dialog.dialog
    autoOpen: false
    modal: true
    width: 500
    buttons:
      Upload: ->
        uploader.uploadifyUpload()

      "Clear queue": ->
        uploader.uploadifyClearQueue()

    resizable: "se"
  upload_dialog.find('a.select-link').click (e) ->
    e.preventDefault()
    select_dialog.dialog('open')
    upload_dialog.dialog('close')

window.setup_select_dialog = (selector, table_selector) ->
  select_dialog = jQuery(selector + 'SelectDialog')
  upload_dialog = jQuery(selector + 'UploadDialog')

  select_dialog.dialog
    autoOpen: false
    modal: true
    minHeight: 380
    width: 800
    resizable: "se"
    buttons:
      Ok: ->
        dataTableSelectRows table_selector, (current_table, indexes) ->
          i = 0

          while i < indexes.length
            row = current_table.fnGetData(indexes[i])
            result =
              size: row.slice(-6, -5)
              type: row.slice(-8, -7)
              path: row.slice(-3, -2)
              id: row.slice(-2, -1)
              name: row.slice(-1)

            callback = jQuery(".add-image.current, .add-file.current").data("callback")
            eval_ callback + "(result);"
            i++

        select_dialog.dialog "close"

  select_dialog.find('a.upload-link').click (e) ->
    e.preventDefault()
    upload_dialog.dialog('open')
    select_dialog.dialog('close')

window.forgeosInitUpload = (selector) ->
  upload = selector + "Upload"
  dialog = upload + "Dialog"
  select_dialog = selector + "SelectDialog"
  jQuery(selector + "Dialog").html "<div id='#{upload.replace("#", "")}'></div><div class='library-add'><span>or</span><a class='select-link'>add from library</a></div>"
  uploadify_datas = format: "json"
  uploadify_datas[window._forgeos_js_vars.session_key] = window._forgeos_js_vars.session

  $(upload).uploadify
    uploader: "/assets/forgeos/uploadify/uploadify.swf"
    cancelImg: "/assets/forgeos/admin/big-icons/delete-icon.png"
    script: window._forgeos_js_vars.mount_paths.core + "/admin/pictures"
    buttonImg: "/assets/forgeos/uploadify/choose-picture_" + jQuery("html").attr("lang") + ".png"
    width: "154"
    height: "24"
    scriptData: uploadify_datas
    ScriptAccess: "always"
    multi: "true"
    displayData: "speed"
    onComplete: (e, queueID, fileObj, response, data) ->
      result = jQuery(response)
      if result.result is "success"
        result["name"] = fileObj.name
        callback = jQuery(".add-image.current,.add-file.current").data("callback")
        eval_ callback + "(result);"
      else
        display_notification_message "error", result.error

    onAllComplete: ->
      jQuery(dialog).dialog "close"

window.initAttachmentUpload = (file_type) ->
  jQuery("#attachmentUploadDialog").dialog "open"
  uploadify_datas =
    parent_id: jQuery("#parent_id_tmp").val()
    format: "json"
  uploadify_datas[window._forgeos_js_vars.session_key] = window._forgeos_js_vars.session

  jQuery("#attachmentUpload").uploadify
    uploader: "/assets/forgeos/uploadify/uploadify.swf"
    cancelImg: "/assets/forgeos/admin/big-icons/delete-icon.png"
    script: window._forgeos_js_vars.mount_paths.core + "/admin/attachments"
    buttonImg: "/assets/forgeos/uploadify/upload-picture_" + jQuery("html").attr("lang") + ".png"
    width: "154"
    height: "24"
    scriptData: uploadify_datas
    ScriptAccess: "always"
    multi: "true"
    displayData: "speed"
    onComplete: (e, queueID, fileObj, response, data) ->
      result = jQuery(response)
      if result.result is "success"
        oTable.fnDraw()
        jQuery.tree.focused().refresh()
      else
        display_notification_message "error", result.error

    onAllComplete: ->
      jQuery("#attachmentUploadDialog").dialog "close"
