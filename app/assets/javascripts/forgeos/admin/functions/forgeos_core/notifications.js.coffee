window.display_notifications = ->
  jQuery.getJSON window._forgeos_js_vars.mount_paths.core + "/admin/notifications", (data) ->
    display_notification_message "success", data.notice, 5000  if data.notice?
    display_notification_message "error", data.error  if data.error?
    display_notification_message "warning", data.warning  if data.warning?
window.display_notification_message = (type, message, delay) ->
  notification_dom = "<div class=\"notification " + type + "\"><span class=\"small-icons message\">" + message + "</span><a href=\"#\" class=\"big-icons gray-destroy\"></a></div>"
  if jQuery("#notifications").children(notification_dom).length is 0
    jQuery("#notifications").append notification_dom
    setTimeout "jQuery('#notifications').children('.notification." + type + ":first').remove();", delay  unless typeof (delay) is "undefined"
