jQuery(document).ready ->
  # Image Manager
  if jQuery('.add-image').length != 0 or jQuery('.category-tree').length != 0
    setup_select_dialog "#image", "#image-table:visible,#thumbnail-table:visible"
    setup_upload_dialog "#image"

    jQuery(".display-thumbnails").click (e) ->
      e.preventDefault()
      if jQuery(this).hasClass("off")
        jQuery(this).toggleClass "off"
        jQuery(".display-list").toggleClass "off"
        jQuery(".attachment-hoverlay-content").toggleClass('hidden')
        search_element = jQuery("#search_image")
        search_element.addClass "forgeos-thumbnails"
      false

    jQuery(".display-list").click (e) ->
      e.preventDefault()
      if jQuery(this).hasClass("off")
        jQuery(this).toggleClass "off"
        jQuery(".display-thumbnails").toggleClass "off"
        jQuery(".attachment-hoverlay-content").toggleClass('hidden')
        search_element = jQuery("#search_image.forgeos-thumbnails")
        search_element.removeClass "forgeos-thumbnails"
      false

    jQuery(".add-image").live "click", (e) ->
      e.preventDefault()
      openimageUploadDialog jQuery(this)
      false

  # File Manager
  if jQuery('.add-file').length != 0
    setup_upload_dialog "#file"
    setup_select_dialog "#file", "#table-files"

    jQuery(".add-file").live "click", (e) ->
      e.preventDefault()
      openfileUploadDialog jQuery(this)
      false

    jQuery("#fileSelectDialog #inner-lightbox a").live "click", ->
      jQuery("#fileSelectDialog #inner-lightbox a").removeClass "selected"
      jQuery(this).addClass "selected"


  # Attachment Uploader
  if jQuery('#add-attachment').length != 0
    setup_upload_dialog "#attachment"

    jQuery("#add-attachment").live "click", (e) ->
      e.preventDefault()
      forgeosInitUpload '#attachment', jQuery(this)
      jQuery('#attachmentUploadDialog').dialog('open')
      false
