jQuery(document).ready ->
  jQuery("#blocks-header").tabs()
  unless jQuery("#page").children("ul")[0] is `undefined`
    jQuery("#page").tabs select: (event, ui) ->
      url = jQuery.data(ui.tab, "load.tabs")
      if url
        location.href = url
        return false
      true
  jQuery(".to-tab").tabs ui:
    theme_path: "/assets/forgeos/jquery-ui/themes/"
    theme_name: "dashboard"

  jQuery("#to-tab").tabs ui:
    theme_path: "/assets/forgeos/jquery-ui/themes/"
    theme_name: "dashboard"
