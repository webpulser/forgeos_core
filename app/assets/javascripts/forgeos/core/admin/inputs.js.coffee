define 'forgeos/core/admin/inputs', ['jquery', 'forgeos/jqueryui/jquery.ui.datepicker', 'forgeos/jqueryui/jquery.ui.sortable'], ($) ->

  build_url_from_name = ->
    # catch object name field to build object url
    $(".field_name").change ->
      value = $(this).val()
      id = $(this).attr("id")
      element_name = id.split("_")[0]
      element = $("textarea:regex(id,.+_meta_info_attributes_title)")
      element.val value  if element.is(":visible")

      $.ajax
        beforeSend: (request) ->
          $("input:regex(id,.+_url)").addClass "loading"

        data:
          url: value

        dataType: "text"
        success: (request) ->
          target = $("input:regex(id,.+_url)")
          target.val request
          target.removeClass "loading"

        type: "post"
        url: window._forgeos_js_vars.mount_paths.core + "/admin/" + element_name + "s/url"

  build_meta_description_from_description = ->
    # catch object description to build object meta description
    $("textarea.mceEditor:regex(id,.+_(description|content))").change ->
      value = $(this).text()
      element = $("textarea:regex(id,.+_meta_info_attributes_description)")
      element.val value  if element.is(":visible")

  init_sortable = ->
    $(".sortable").each ->
      $(this).sortable
        handle: ".handler"
        placeholder: "ui-state-highlight"

    $(".nested_sortable").each ->
      $(this).sortable
        handle: ".handler"
        placeholder: "ui-state-highlight"
        update: (event, ui) ->
          update_block_container_positions $(this)

  init_datepickers = ->
    $("input.date-picker").datepicker
      dateFormat: "dd/mm/yy"
      showOn: "both"
      buttonText: ""
      changeMonth: true
      changeYear: true

  initialize = ->
    build_url_from_name()
    build_meta_description_from_description()
    init_sortable()
    init_datepickers()

  # public methods
  new: initialize
