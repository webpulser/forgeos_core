define 'forgeos/core/admin/settings', ['jquery'], ($) ->

  # add popover on nodes marked with a popover
  init_popovers = ->
    popovers = $('.with_popover, a[rel=popover]')
    if popovers.length > 0
      require ['bootstrap-popover'], ->
        popovers.popover()

  # add tooltip on nodes marked with a tooltip
  init_tooltips = ->
    tooltips = $('.with_tooltip, a[rel=tooltip]')
    if tooltips.length > 0
      require ['bootstrap-tooltip'], ->
        tooltips.tooltip()

  initialize = ->
    init_tooltips()
    init_popovers()

  # public methods
  new: initialize
