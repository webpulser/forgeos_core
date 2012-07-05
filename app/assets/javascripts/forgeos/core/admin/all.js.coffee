define 'forgeos/core/admin/all', [
    './attachments',
    './clicks',
    './datatables',
    './editor',
    './header',
    './import',
    './inputs',
    './notifications',
    './popins',
    './rights',
    './settings',
    './sidebars',
    './trees',
    'jquery_ujs'
  ],
  (
    Attachments,
    Clicks,
    DataTables,
    Editor,
    Header,
    Import,
    Inputs,
    Notifications,
    Mary,
    Rights,
    Settings,
    Sidebars,
    Trees
  ) ->

    new: ->
      Attachments.new()
      Clicks.new()
      DataTables.new()
      Header.new()
      Editor.new()
      Import.new()
      Inputs.new()
      Mary.new()
      Notifications.new()
      Rights.new()
      Settings.new()
      Sidebars.new()
      Trees.new()
