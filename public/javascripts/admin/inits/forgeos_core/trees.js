jQuery(document).ready(function(){
  init_category_tree('#admins-tree','AdminCategory','/admin/admin_categories.json');
  init_category_tree('#roles-tree','RoleCategory','/admin/role_categories.json');
  init_category_tree('#rights-tree','RightCategory','/admin/right_categories.json');
  init_category_tree('#picture-attachment-tree','PictureCategory','/admin/picture_categories.json');
  init_category_tree('#pdf-attachment-tree','PdfCategory','/admin/pdf_categories.json');
  init_category_tree('#video-attachment-tree','VideoCategory','/admin/video_categories.json');
  init_category_tree('#media-attachment-tree','MediaCategory','/admin/media_categories.json');
  init_category_tree('#doc-attachment-tree','DocCategory','/admin/doc_categories.json');

  //init the menu modify tree
  $("#menu-tree").tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'menu-tree',
      selected_parent_close: false
    },
    rules: {draggable : 'all', clickable: 'all'},
    callback: {
      onload: function(TREE_OBJ){
        tree_id = $(TREE_OBJ.container).attr('id');
        $(TREE_OBJ.container).removeClass('tree-default');
      }
    }
  });
});

