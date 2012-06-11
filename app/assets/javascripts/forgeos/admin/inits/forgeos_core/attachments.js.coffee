jQuery(document).ready ->
  jQuery(".media-image-container").mouseover ->
    jQuery(this).addClass "image_on_top"

  jQuery(".media-image-container").mouseout ->
    jQuery(this).removeClass "image_on_top"
