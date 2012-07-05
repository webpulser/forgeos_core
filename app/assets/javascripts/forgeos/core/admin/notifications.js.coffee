define 'forgeos/core/admin/notifications', ['jquery'], ($) ->
  remote = ->
    $.getJSON window._forgeos_js_vars.mount_paths.core + "/admin/notifications", (data) ->

      display "success", data.notice, 5000  if data.notice?
      display "error", data.error  if data.error?
      display "warning", data.warning  if data.warning?

  display = (type, message, delay) ->
    timestamp = new Date().getTime()

    require ['mustache', 'text!templates/admin/notifications/new.html', 'bootstrap-alert'], (Mustache, template) ->
      $("#alerts").append Mustache.render template,
        id: timestamp
        type: type
        message: message

      setTimeout "jQuery('##{timestamp}').remove();", delay if delay?

  new: remote
  init: remote
  display: display
