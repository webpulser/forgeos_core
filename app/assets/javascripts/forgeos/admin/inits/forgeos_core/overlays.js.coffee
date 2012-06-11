jQuery(document).ready ->
  jQuery(".lightbox-container").dialog
    autoOpen: false
    modal: true
    minHeight: 380
    width: 500
    resizable: "se"

  setup_upload_dialog "#imageUpload"
  setup_upload_dialog "#attachmentUpload"
  setup_upload_dialog "#fileUpload"
  setup_select_dialog "#imageSelect", "#image-table:visible,#thumbnail-table:visible"
  setup_select_dialog "#fileSelect", "#table-files"

  jQuery(".display-thumbnails").click (e) ->
    e.preventDefault()
    if jQuery(this).hasClass("off")
      jQuery(this).toggleClass "off"
      jQuery(".display-list").toggleClass "off"
      jQuery(".media-hoverlay-content").toggleClass "hidden"
      search_element = jQuery("#search.image")
      search_element.removeClass "image"
      search_element.addClass "thumbnails"
    false

  jQuery(".display-list").click (e) ->
    e.preventDefault()
    if jQuery(this).hasClass("off")
      jQuery(this).toggleClass "off"
      jQuery(".display-thumbnails").toggleClass "off"
      jQuery(".media-hoverlay-content").toggleClass "hidden"
      search_element = jQuery("#search.thumbnails")
      search_element.removeClass "thumbnails"
      search_element.addClass "image"
    false

  jQuery(".add-image").live "click", (e) ->
    e.preventDefault()
    jQuery(".add-image, .add-file").removeClass "current"
    jQuery(this).addClass "current"
    openimageUploadDialog()
    false

  jQuery(".add-file").live "click", (e) ->
    e.preventDefault()
    jQuery(".add-image, .add-file").removeClass "current"
    jQuery(this).addClass "current"
    openfileUploadDialog()
    false

  jQuery("#add-block, #add-widget").live "click", (e) ->
    e.preventDefault()
    openBlockDialog jQuery(this), jQuery(this).parent()
    false

  jQuery("#add-attachment").live "click", (e) ->
    e.preventDefault()
    initAttachmentUpload $(this).data("file_type")
    false

  jQuery("#fileSelectDialog #inner-lightbox a").live "click", ->
    jQuery("#fileSelectDialog #inner-lightbox a").removeClass "selected"
    jQuery(this).addClass "selected"

  jQuery("a.page-link").live "click", (e) ->
    e.preventDefault()
    openPageDialog jQuery(this)
    false

  jQuery(".link-page.small-icons.page").live "click", ->
    unless jQuery(this).hasClass("active")
      url = jQuery(this).attr("href")
      block_id = url.split("/")[5]
      page_id = jQuery(this).parent().attr("id").substr(5)
      jQuery.ajax
        url: url
        complete: putInPageList(jQuery(this).text(), jQuery(this).attr("title"), block_id, page_id)
        dataType: "script"
        type: "post"

      closeDialogBox()
    false

  jQuery(".static-tab,.widget-tab").live "click", (e) ->
    e.preventDefault()
    toggleHoverlayTrees jQuery(this).attr("class")
    false
