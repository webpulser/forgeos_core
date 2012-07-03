//= require forgeos/admin/requirejs.config
require ['jquery', 'forgeos/admin'], ($, ForgeosAdmin) ->
  $ ->
    ForgeosAdmin.new()
