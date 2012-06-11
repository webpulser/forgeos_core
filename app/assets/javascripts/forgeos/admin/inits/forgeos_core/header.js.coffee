jQuery(document).ready ->
  jQuery("#menu .current").append "<span class=\"after-current\"></span>"
  jQuery("#menu .current").prepend "<span class=\"before-current\"></span>"
