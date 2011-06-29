jQuery(document).ready(function(){
  init_category_tree("#user-tree",'UserCategory','/admin/user_categories.json');
  init_category_tree('#admins-tree','AdminCategory','/admin/admin_categories.json');
  init_category_tree('#roles-tree','RoleCategory','/admin/role_categories.json');
  init_category_tree('#rights-tree','RightCategory','/admin/right_categories.json');
  init_category_tree('#menus-tree','MenuCategory','/admin/menu_categories.json');
  init_category_tree('#picture-attachment-tree','PictureCategory','/admin/picture_categories.json');
  init_category_tree('#pdf-attachment-tree','PdfCategory','/admin/pdf_categories.json');
  init_category_tree('#video-attachment-tree','VideoCategory','/admin/video_categories.json');
  init_category_tree('#media-attachment-tree','MediaCategory','/admin/media_categories.json');
  init_category_tree('#doc-attachment-tree','DocCategory','/admin/doc_categories.json');

  //init the menu modify tree
  jQuery("#menu-tree").tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'menu-tree',
      selected_parent_close: false
    },
    callback: {
      onload: function(TREE_OBJ){
        tree_id = jQuery(TREE_OBJ.container).attr('id');
        jQuery(TREE_OBJ.container).removeClass('tree-default');
        },
      onmove: function(NODE, REF_NODE, TYPE, TREE_OBJ, RB){
        var menu = jQuery('#menu-tree').children('ul');
        var parent = jQuery(NODE).parents('li:first');

        // update names, ids, parent_ids and positions
        update_menu_names_and_ids(menu, 'menu[menu_links_attributes]', 'menu_menu_links_attributes_');
        update_menu_positions(menu);

        // open parent of moved node
        if (parent)
          toggle_menu_link(parent, 'open');
      }
    }
  });

  //init the menu modify tree
  jQuery("#menu-tree-ro").tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'menu-tree',
      selected_parent_close: false
    },
    types: { 'default':
      { draggable: false, clickable: false}
    },
    callback: {
      onload: function(TREE_OBJ){
        tree_id = jQuery(TREE_OBJ.container).attr('id');
        jQuery(TREE_OBJ.container).removeClass('tree-default');
      }
    }
  });

  init_association_category_tree('#association-media-tree', undefined, 'attachment_category', 'association_categories');
});
