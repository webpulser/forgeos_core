jQuery(document).ready(function(){
  jQuery('#caching-tree').tree({
    "ui": {
      "theme_path": '/stylesheets/jstree/themes/'
    },
    "rules": {
      "multiple": "on"
    },
    "data": {
      "type": 'json',
      "async": true,
      "opts": { "url": '/admin/cachings.json' }
    },
    "callback": {
      "beforedata": function (n) {
         return { id: (n.data ? n.attr('data-name') : 0) };
      },
      "onchange": function (n, t) {
        var node = jQuery(n);
        if (node.find('> a input').length) {
          node.find('a input').remove();
        } else {
          node.find('> a').append('<input type="checkbox" name="files[]" value="'+ node.attr('data-name') +'" checked />');
        }
      }
    }
  });
});
