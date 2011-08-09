jQuery(document).ready(function(){
  $.jstree._themes = '/assets/jstree/themes/';
  jQuery('#caching-tree').jstree({
    "json_data": {
      "ajax": {
        "url": '/admin/cachings.json',
        "data" : function (n) {
           return { id: (n.data ? n.data('name') : 0) };
        }
      }
    },
    "checkbox": {
      real_checkboxes: true,
      real_checkboxes_names: function (n) { return ["files[]", n.data('name')]; }
    },
    "plugins": ['ui', 'themes', 'checkbox','json_data']
  });
});
