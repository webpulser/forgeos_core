jQuery(document).ready ->
  unless jQuery.cookie("closed_panels_list")?
    jQuery.cookie "closed_panels_list", "",
      path: window._forgeos_js_vars.mount_paths.core + "/admin/"
      expires: 10

  jQuery("a.step-title, a.panel").bind "click", toggle_steps
  jQuery("a.step-title, a.panel").each init_steps
