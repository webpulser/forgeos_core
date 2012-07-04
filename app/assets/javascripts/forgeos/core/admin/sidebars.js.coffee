define 'forgeos/core/admin/sidebars', ->
  initialize = ->
    require ['forgeos/core/admin/sidebars/right'], (rightSidebar) ->
      rightSidebar.new()

    require ['forgeos/core/admin/sidebars/left'], (leftSidebar) ->
      leftSidebar.new()
 

  # public methods
  new: initialize
