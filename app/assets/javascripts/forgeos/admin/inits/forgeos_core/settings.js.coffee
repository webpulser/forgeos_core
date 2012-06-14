jQuery(document).ready ->
  jQuery("#setting_mailer_attributes_delivery_method").change ->
    value = jQuery("#setting_mailer_attributes_delivery_method").val()
    jQuery(".delivery_method_settings").addClass('hidden')
    jQuery("#" + value).removeClass('hidden')

  current_mailer_setting = jQuery("#setting_mailer_attributes_delivery_method").val()
  if current_mailer_setting?
    jQuery("#" + current_mailer_setting).removeClass('hidden')

  jQuery("#setting_smtp_settings_attributes_authentication").change ->
    if @value is "none"
      jQuery("#authentication").addClass "hidden"
    else
      jQuery("#authentication").removeClass "hidden"


  processScroll = ->
    scrollTop = $win.scrollTop()

    if scrollTop >= navTop and not isFixed
      isFixed = 1
      $nav.addClass('subnav-fixed')
    else if scrollTop <= navTop
      isFixed = 0
      $nav.removeClass('subnav-fixed')

  # fix sub nav on scroll
  $win = $(window)
  $nav = $('.subnav')
  navTop = $('.subnav').length && $('.subnav').offset().top
  isFixed = 0
  processScroll()

  # hack sad times - holdover until rewrite for 2.1
  $nav.on 'click', ->
    unless isFixed
      setTimeout "$win.scrollTop($win.scrollTop() - 7)", 10

  $win.on 'scroll', processScroll
