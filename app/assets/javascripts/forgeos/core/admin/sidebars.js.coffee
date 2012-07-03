define 'forgeos/core/admin/sidebars', ['./sidebars/right', './sidebars/left'], (Right, Left) ->
  initialize = ->
    Right.new()
    Left.new()

  # public methods
  new: initialize
