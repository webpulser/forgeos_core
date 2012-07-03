define 'forgeos/core/admin/settings', ['jquery', 'bootstrap-tooltip'], ($) ->

  init_popovers = ->
    $('.with_popover, a[rel=popover]').popover()
  init_tootltips = ->
    $('.with_tooltip, a[rel=tooltip]').tooltip()
  initialize = ->
    #init_popovers()
    init_tootltips()

  # public methods
  new: initialize
