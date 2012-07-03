define 'forgeos/core/admin/header', ['jquery', 'bootstrap-dropdown', 'bootstrap-scrollspy', 'bootstrap-tab'], ($) ->

  copy_dataTables_filters = ->
    filters = $('#content .dataTables_wrapper .top')
    $('#page .header .span8').append(filters.clone(true))
    filters.hide()

  init_dataTables_filters = ->
    setTimeout copy_dataTables_filters, 500

  init_navbar = ->
    $nav = $('.subnav')
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
      $win = $(window)
      navTop = $nav.length && $nav.offset().top
      isFixed = 0
      bigProcessScroll()

      # hack sad times - holdover until rewrite for 2.1
      $nav.on 'click', ->
        unless isFixed
          setTimeout "$(window).scrollTop($(window).scrollTop() - 7)", 10

      $win.on 'scroll', bigProcessScroll

  init_page_header = ->
    $header = $('#page .header')
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
      $win = $(window)
      navTop = $header.length && $header.offset().top
      isFixed = 0
      headerProcessScroll()

      # hack sad times - holdover until rewrite for 2.1
      $header.on 'click', ->
        unless isFixed
          setTimeout "$(window).scrollTop($(window).scrollTop() - 7)", 10

      $win.on 'scroll', headerProcessScroll

  init_scrollbar = ->
    $('#scrollbar a').click (e) ->
      e.preventDefault()
      $(window).scrollTop($($(this).attr('href')).position().top)
      false

  initialize = ->
    init_page_header()
    init_navbar()
    init_scrollbar()
    init_dataTables_filters()

  # public methods
  new: initialize
