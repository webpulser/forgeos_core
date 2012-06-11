jQuery(document).ready ->
  jQuery("#forgeos_setting_mailer_delivery_method").change ->
    value = jQuery("#setting_mailer_delivery_method").val()
    jQuery(".delivery_method_settings").hide()
    jQuery("#" + value).show()

  current_mailer_setting = jQuery("#forgeos_setting_mailer_delivery_method").val()
  if current_mailer_setting?
    jQuery(".delivery_method_settings").hide()
    jQuery("#" + current_mailer_setting).show()
  jQuery("#setting_smtp_settings_authentication").change ->
    if @value is "none"
      jQuery("#authentication").addClass "hidden"
    else
      jQuery("#authentication").removeClass "hidden"
