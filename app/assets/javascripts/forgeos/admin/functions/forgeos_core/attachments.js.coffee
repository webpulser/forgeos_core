window.setup_upload_dialog = (selector) ->
  select_dialog = jQuery(selector + 'SelectDialog')
  upload_dialog = jQuery(selector + 'UploadDialog')
  uploader = jQuery(selector + 'Upload')

  upload_dialog.dialog
    autoOpen: false
    modal: true
    width: 500
    buttons:
      'upload': ->
        uploader.uploadifyUpload()

      'clear queue': ->
        uploader.uploadifyClearQueue()
      'add_from_library': ->
        select_dialog.dialog('open')
        upload_dialog.dialog('close')

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
      'ok': ->
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

window.forgeosInitUpload = (selector, button) ->
  upload = selector + "Upload"
  upload_dialog = upload + "Dialog"
  select_dialog = selector + "SelectDialog"

  jQuery(selector + "Dialog").html "<input type='file' id='#{upload.replace("#", "")}'></input>"

  uploadify_datas =
    format: "json"

  uploadify_datas['parent_id'] = jQuery("#parent_id_tmp").val() if jQuery("#parent_id_tmp").length != 0
  uploadify_datas[window._forgeos_js_vars.session_key] = window._forgeos_js_vars.session

  jQuery(upload).uploadify
    swf: "/assets/uploadify/uploadify.swf"
    uploader: window._forgeos_js_vars.mount_paths.core + "/admin/attachments"
    buttonClass: 'btn btn-large'
    width: "154"
    height: "24"
    formData: uploadify_datas
    multi: "true"
    progressData: "speed"
    onUploadSuccess: (file, data, response) ->
      data["name"] = file.name
      callback = button.data("callback")
      eval callback + "(data);" if callback?
    onUploadError: (file, errorCode, errorMsg, errorString) ->
      display_notification_message "error", errorString
    onQueueComplete: ->
      jQuery(upload_dialog).dialog "close"
    onDialogClose: ->
      jQuery('.ui-dialog-buttonset button').removeClass('ui-state-disabled')
    onSWFReady: ->
      ui_dialog = jQuery(upload_dialog).parents('.ui-dialog')
      if selector == '#attachment'
        ui_dialog.find('.ui-dialog-buttonset button:last').hide()
      ui_dialog.find('.ui-dialog-buttonset button:lt(2)').addClass('ui-state-disabled')

window.openimageUploadDialog = (link) ->
  forgeosInitUpload "#image", link
  jQuery("#imageSelectDialog").dialog "open"

window.openfileUploadDialog = (link)->
  forgeosInitUpload "#file", link
  jQuery("#fileSelectDialog").dialog "open"

window.toggleSelectedOverlay = (element) ->
  unless jQuery(element).hasClass("selected")
    jQuery(element).addClass "selected"
    jQuery(element).siblings().removeClass "selected"

# Uploadify Callback
window.add_picture_to_element = (data) ->
  object_name = jQuery("form#wrap").data("object_name")
  input = jQuery(".add-image.current").data("input_name")
  jQuery(input + "-picture ul.sortable").html "<li><img src=\"" + data.path + "\" alt=\"" + data.name + "\"/><a href=\"#\" onclick=\"jQuery(this).parents('li').remove(); jQuery('" + input + "').val(null); return false;\" class=\"big-icons delete\"></a></li>"
  jQuery(input).val data.id

window.add_picture_to_visuals = (data) ->
  object_name = jQuery("form#wrap").data("object_name")
  jQuery("#visuals-picture ul.sortable").before "<li><a href=\"#\" onclick=\"jQuery(this).parents('li').remove(); return false;\" class=\"big-icons trash\"></a><input type=\"hidden\" name=\"" + object_name + "[attachment_ids][]\" value=\"" + data.id + "\"/><img src=\"" + data.path + "\" alt=\"" + data.name + "\"/><div class=\"handler\"><div class=\"inner\"></div></div></li>"


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

window.refresh_after_file_upload = (data) ->
  jQuery('#table').dataTableInstance().fnDraw()
  jQuery.jstree._focused().refresh()
