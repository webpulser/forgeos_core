define 'forgeos/core/admin/notifications', ['jquery'], ($) ->
  remote = ->
    $.getJSON window._forgeos_js_vars.mount_paths.core + "/admin/notifications", (data) ->

      display "success", data.notice, 5000  if data.notice?
      display "error", data.error  if data.error?
      display "warning", data.warning  if data.warning?

  display = (type, message, delay) ->
    timestamp = new Date().getTime()

    require ['bootstrap-alert'], ->
      $("#alerts").append "<div id='#{timestamp}' class='alert alert-#{type}'><button class='close' data-dismiss='alert'>&times;</button>#{message}</div>"

      setTimeout "jQuery('##{timestamp}').remove();", delay if delay?

  new: remote
  init: remote
  display: display
