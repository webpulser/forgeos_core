jQuery(document).ready ->
  jQuery(".field_name").change ->
    value = jQuery(this).val()
    id = jQuery(this).attr("id")
    element_name = id.split("_")[0]
    element = jQuery("textarea:regex(id,.+_meta_info_attributes_title)")
    element.val value  if element.is(":visible")
    jQuery.ajax
      beforeSend: (request) ->
        jQuery("input:regex(id,.+_url)").addClass "loading"

      data:
        url: value

      dataType: "text"
      success: (request) ->
        target = jQuery("input:regex(id,.+_url)")
        target.val request
        target.removeClass "loading"

      type: "post"
      url: window._forgeos_js_vars.mount_paths.core + "/admin/" + element_name + "s/url"

  jQuery("textarea.mceEditor:regex(id,.+_(description|content))").change ->
    value = jQuery(this).text()
    element = jQuery("textarea:regex(id,.+_meta_info_attributes_description)")
    element.val value  if element.is(":visible")

  jQuery(".sortable").each ->
    jQuery(this).sortable
      handle: ".handler"
      placeholder: "ui-state-highlight"

  jQuery(".nested_sortable").each ->
    jQuery(this).sortable
      handle: ".handler"
      placeholder: "ui-state-highlight"
      update: (event, ui) ->
        update_block_container_positions jQuery(this)

  jQuery("input.date-picker").datepicker
    dateFormat: "dd/mm/yy"
    showOn: "both"
    buttonText: ""
    changeMonth: true
    changeYear: true
