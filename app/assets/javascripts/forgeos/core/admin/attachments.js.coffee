define 'forgeos/core/admin/attachments', ['jquery', './base', 'jquery.uploadify', 'forgeos/jqueryui/jquery.ui.dialog'], ($, Base) ->
  setup_upload_dialog = (selector) ->
    select_dialog = $(selector + 'SelectDialog')
    upload_dialog = $(selector + 'UploadDialog')
    uploader = $(selector + 'Upload')

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
      select_dialog.dialog 'open'
      upload_dialog.dialog 'close'

  setup_select_dialog = (selector, table_selector) ->
    select_dialog = $(selector + 'SelectDialog')
    upload_dialog = $(selector + 'UploadDialog')

    select_dialog.dialog
      autoOpen: false
      modal: true
      minHeight: 380
      width: 800
      resizable: "se"
      buttons:
        ok: ->
          dataTableSelectRows table_selector, (current_table, indexes) ->
            for index in indexes
              row = current_table.fnGetData(indexes[index])
              result =
                size: row.slice(-6, -5)
                type: row.slice(-8, -7)
                path: row.slice(-3, -2)
                id: row.slice(-2, -1)
                name: row.slice(-1)

              callback = $(".add-image.current, .add-file.current").data("callback")
              callback.call result

              null

          select_dialog.dialog "close"

    select_dialog.find('a.upload-link').click (e) ->
      e.preventDefault()
      upload_dialog.dialog 'open'
      select_dialog.dialog 'close'

  forgeosInitUpload = (selector, button) ->
    upload = selector + "Upload"
    upload_dialog = upload + "Dialog"
    select_dialog = selector + "SelectDialog"

    $(selector + "Dialog").html "<input type='file' id='#{upload.replace("#", "")}'></input>"

    uploadify_datas =
      format: "json"

    uploadify_datas['parent_id'] = $("#parent_id_tmp").val() if $("#parent_id_tmp").length != 0
    uploadify_datas[window._forgeos_js_vars.session_key] = window._forgeos_js_vars.session

    $(upload).uploadify
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
        eval("#{callback}(data);") if callback?
      onUploadError: (file, errorCode, errorMsg, errorString) ->
        display_notification_message "error", errorString
      onQueueComplete: ->
        $(upload_dialog).dialog "close"
      onDialogClose: ->
        $('.ui-dialog-buttonset button').removeClass('ui-state-disabled')
      onSWFReady: ->
        ui_dialog = $(upload_dialog).parents('.ui-dialog')
        if selector == '#attachment'
          ui_dialog.find('.ui-dialog-buttonset button:last').hide()
        ui_dialog.find('.ui-dialog-buttonset button:lt(2)').addClass('ui-state-disabled')

  open_upload_dialog = (type, link) ->
    forgeosInitUpload "##{type}", link
    $("##{type}SelectDialog").dialog "open"

  openimageUploadDialog = (link)->
    open_upload_dialog('image', link)

  openfileUploadDialog = (link)->
    open_upload_dialog('file', link)

  toggleSelectedOverlay = (element) ->
    unless $(element).hasClass("selected")
      $(element).addClass "selected"
      $(element).siblings().removeClass "selected"

  # Uploadify Callback
  add_picture_to_element = (data) ->
    object_name = $("form#wrap").data("object_name")
    input = $(".add-image.current").data("input_name")
    $(input + "-picture ul.sortable").html "<li><img src=\"" + data.path + "\" alt=\"" + data.name + "\"/><a href=\"#\" onclick=\"$(this).parents('li').remove(); $('" + input + "').val(null); return false;\" class=\"big-icons delete\"></a></li>"
    $(input).val data.id

  add_picture_to_visuals = (data) ->
    object_name = $("form#wrap").data("object_name")
    $("#visuals-picture ul.sortable").before "<li><a href=\"#\" onclick=\"$(this).parents('li').remove(); return false;\" class=\"big-icons trash\"></a><input type=\"hidden\" name=\"" + object_name + "[attachment_ids][]\" value=\"" + data.id + "\"/><img src=\"" + data.path + "\" alt=\"" + data.name + "\"/><div class=\"handler\"><div class=\"inner\"></div></div></li>"

  add_picture_to_category = (data) ->
    category = $(".add-image.current")
    $.ajax
      success: (result) ->
        $("#imageLeftSidebarSelectDialog").dialog "close"
        category.removeClass("add-image").removeClass "current"
        $.jstree._focused().refresh category.parents("li:first")
      data:
        "category[attachment_ids][]": data.id
      dataType: "json"
      type: "put"
      url: window._forgeos_js_vars.mount_paths.core + "/admin/categories/" + Base.get_rails_element_id(category) + ".json"

  refresh_after_file_upload = (data) ->
    $('#table').dataTableInstance().fnDraw()
    $.jstree._focused().refresh()

  # Image Manager
  imageManager = ->
    if $('.add-image').length != 0 or $('.category-tree').length != 0
      setup_select_dialog "#image", "#image-table:visible,#thumbnail-table:visible"
      setup_upload_dialog "#image"

      $(".display-thumbnails").click (e) ->
        e.preventDefault()
        if $(this).hasClass("off")
          $(this).toggleClass "off"
          $(".display-list").toggleClass "off"
          $(".attachment-hoverlay-content").toggleClass('hidden')
          search_element = $("#search_image")
          search_element.addClass "forgeos-thumbnails"

        false

      $(".display-list").click (e) ->
        e.preventDefault()
        if $(this).hasClass("off")
          $(this).toggleClass "off"
          $(".display-thumbnails").toggleClass "off"
          $(".attachment-hoverlay-content").toggleClass('hidden')
          search_element = $("#search_image.forgeos-thumbnails")
          search_element.removeClass "forgeos-thumbnails"

        false

      $(".add-image").live "click", (e) ->
        e.preventDefault()
        open_upload_dialog 'image', $(this)

        false

  # File Manager
  fileManager = ->
    if $('.add-file').length != 0
      setup_upload_dialog "#file"
      setup_select_dialog "#file", "#table-files"

      $(".add-file").live "click", (e) ->
        e.preventDefault()
        open_upload_dialog 'file', $(this)

        false

      $("#fileSelectDialog #inner-lightbox a").live "click", (e) ->
        e.preventDefault()
        $("#fileSelectDialog #inner-lightbox a").removeClass "selected"
        $(this).addClass "selected"

        false


  # Attachment Uploader
  uploader = ->
    if $('#add-attachment').length != 0
      setup_upload_dialog "#attachment"

      $("#add-attachment").live "click", (e) ->
        e.preventDefault()
        forgeosInitUpload '#attachment', $(this)
        $('#attachmentUploadDialog').dialog('open')

        false

  initialize = ->
    imageManager()
    fileManager()
    uploader()

  # public methods
  new: initialize
  setup_upload_dialog: setup_upload_dialog
  setup_select_dialog: setup_select_dialog
  open_upload_dialog: open_upload_dialog
