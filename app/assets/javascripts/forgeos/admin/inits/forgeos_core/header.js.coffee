jQuery(document).ready ->
  jQuery('.dropdown-toggle').dropdown()
  jQuery('#scrollbar a').click (e) ->
    e.preventDefault()
    jQuery(window).scrollTop(jQuery(jQuery(this).attr('href')).position().top)
    false


  $nav = jQuery('.subnav')
  if $nav.length != 0
    bigProcessScroll = ->
      scrollTop = $win.scrollTop()

      if scrollTop >= navTop and not isFixed
        isFixed = 1
        $nav.addClass('subnav-fixed')
      else if scrollTop <= navTop
        isFixed = 0
        $nav.removeClass('subnav-fixed')

    # fix sub nav on scroll
    $win = jQuery(window)
    navTop = $nav.length && $nav.offset().top
    isFixed = 0
    bigProcessScroll()

    # hack sad times - holdover until rewrite for 2.1
    $nav.on 'click', ->
      unless isFixed
        setTimeout "jQuery(window).scrollTop(jQuery(window).scrollTop() - 7)", 10

    $win.on 'scroll', bigProcessScroll


  $header = jQuery('#page .header')
  if $header.length != 0
    headerProcessScroll = ->
      scrollTop = $win.scrollTop()

      if scrollTop >= navTop and not isFixed
        isFixed = 1
        $header.addClass('header-fixed')
      else if scrollTop <= navTop
        isFixed = 0
        $header.removeClass('header-fixed')

    # fix sub nav on scroll
    $win = jQuery(window)
    navTop = $header.length && $header.offset().top
    isFixed = 0
    headerProcessScroll()

    # hack sad times - holdover until rewrite for 2.1
    $header.on 'click', ->
      unless isFixed
        setTimeout "jQuery(window).scrollTop(jQuery(window).scrollTop() - 7)", 10

    $win.on 'scroll', headerProcessScroll

  window.copy_dataTables_filters = ->
    filters = jQuery('#content .dataTables_wrapper .top')
    jQuery('#page .header .span8').append(filters.clone(true))
    filters.hide()

  setTimeout 'copy_dataTables_filters()', 500
