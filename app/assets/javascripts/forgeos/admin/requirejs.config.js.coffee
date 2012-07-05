require
  shim:
    'bootstrap-all': ['jquery']
    'bootstrap-alert': ['jquery']
    'bootstrap-button': ['jquery']
    'bootstrap-carousel': ['jquery']
    'bootstrap-collapse': ['jquery']
    'bootstrap-dropdown': ['jquery']
    'bootstrap-modal': ['jquery']
    'bootstrap-popover': ['jquery', 'bootstrap-tooltip']
    'bootstrap-scrollspy': ['jquery']
    'bootstrap-tab': ['jquery']
    'bootstrap-tooltip': ['jquery']
    'bootstrap-transition': ['jquery']
    'bootstrap-typeahead': ['jquery']
    'dataTables': ['jquery']
    'dataSlides': ['jquery']
    'jqueryui/jquery.effects.core': ['jquery']
    'jqueryui/jquery.effects.explode': ['./jquery.effects.core']
    'jqueryui/jquery.ui.core': ['jquery']
    'jqueryui/jquery.ui.accordion': ['./jquery.ui.core','./jquery.ui.widget']
    'jqueryui/jquery.ui.autocomplete': ['./jquery.ui.core', './jquery.ui.widget', './jquery.ui.position']
    'jqueryui/jquery.ui.button': ['./jquery.ui.core','./jquery.ui.widget']
    'jqueryui/jquery.ui.datepicker': ['./jquery.ui.core']
    'jqueryui/jquery.ui.dialog': ['./jquery.ui.button', './jquery.ui.draggable', './jquery.ui.resizable']
    'jqueryui/jquery.ui.draggable': ['./jquery.ui.mouse']
    'jqueryui/jquery.ui.droppable': ['./jquery.ui.draggable']
    'jqueryui/jquery.ui.mouse': ['./jquery.ui.core', './jquery.ui.widget']
    'jqueryui/jquery.ui.positon': ['jquery']
    'jqueryui/jquery.ui.progressbar': ['./jquery.ui.core', './jquery.ui.widget']
    'jqueryui/jquery.ui.resizable': ['./jquery.ui.mouse']
    'jqueryui/jquery.ui.selectable': ['./jquery.ui.mouse']
    'jqueryui/jquery.ui.slider': ['./jquery.ui.mouse']
    'jqueryui/jquery.ui.sortable': ['./jquery.ui.mouse']
    'jqueryui/jquery.ui.tabs': ['./jquery.ui.core', './jquery.ui.widget']
    'jqueryui/jquery.ui.widget': ['jquery']
    'jquery_ujs': ['jquery']
    'jstree/jstree': ['jquery', 'jstree/vakata']
    'jstree/jstree.checkbox': ['jstree/jstree']
    'jstree/jstree.contextmenu': ['jstree/jstree']
    'jstree/jstree.dnd': ['jstree/jstree']
    'jstree/jstree.hotkeys': ['jstree/jstree', 'hotkeys']
    'jstree/jstree.html': ['jstree/jstree']
    'jstree/jstree.json': ['jstree/jstree']
    'jstree/jstree.rules': ['jstree/jstree']
    'jstree/jstree.sort': ['jstree/jstree']
    'jstree/jstree.state': ['jstree/jstree', 'cookie']
    'jstree/jstree.themes': ['jstree/jstree']
    'jstree/jstree.ui': ['jstree/jstree']
    'jstree/jstree.unique': ['jstree/jstree']
    'jstree/jstree.xml': ['jstree/jstree']
  paths:
    jqueryui: 'forgeos/jqueryui-1.8.21'
    jstree: 'jstree-1.0.0'
    templates: 'forgeos/templates'
  map:
    '*':
      cookie: 'jquery.cookie-2010'
      dataTables: 'jquery.dataTables.min-1.8.1'
      dataSlides: 'forgeos/jquery.dataSlides'
      hotkeys: 'jquery.hotkeys-0.8+'
      mustache: 'requirejs.mustache'
      text: 'requirejs.text'
      uploadify: 'jquery.uploadify-3.1.1'
