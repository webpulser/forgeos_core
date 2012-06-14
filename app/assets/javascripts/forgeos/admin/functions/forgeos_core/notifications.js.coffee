window.display_notifications = ->
  jQuery.getJSON window._forgeos_js_vars.mount_paths.core + "/admin/notifications", (data) ->

    display_notification_message "success", data.notice, 5000  if data.notice?
    display_notification_message "error", data.error  if data.error?
    display_notification_message "warning", data.warning  if data.warning?

window.display_notification_message = (type, message, delay) ->
  timestamp = new Date().getTime()

  jQuery("#alerts").append "<div id='#{timestamp}' class='alert alert-#{type}'><button class='close' data-dismiss='alert'>&times;</button>#{message}</div>"

  setTimeout "jQuery('##{timestamp}').remove();", delay if delay?
