jQuery(document).ready(function(){
  jQuery('#caching-tree').tree({
    "ui": {
      "theme_path": '/stylesheets/jstree/themes/',
      "theme_name": 'categories'
    },
    "data": {
      "type": 'json',
      "async": true,
      "opts": { "url": '/admin/cachings.json' }
    },
    "callback": {
      "beforedata": function (n) {
         return { id: (n.data ? n.data('name') : 0) };
      }
    },
    "plugins": { 
      "checkbox": {
        real_checkboxes: true,
        real_checkboxes_names: function (n) { return ["files[]", n.data('name')]; }
      }
    }
  });
});
