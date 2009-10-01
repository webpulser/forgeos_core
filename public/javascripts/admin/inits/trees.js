jQuery(document).ready(function(){
  init_tree("#roles-tree",'RoleCategory', '/admin/roles.json','/admin/role_categories.json');
  init_tree("#rights-tree",'RightCategory', '/admin/rights.json','/admin/right_categories.json');
  init_tree("#picture-attachment-tree",'PictureCategory', '/admin/picture/attachments.json', '/admin/picture_categories.json');
  init_tree("#pdf-attachment-tree",'PdfCategory', '/admin/pdf/attachments.json', '/admin/pdf_categories.json');
  init_tree("#video-attachment-tree",'VideoCategory', '/admin/video/attachments.json','/admin/video_categories.json');
  init_tree("#media-attachment-tree",'MediaCategory', '/admin/media/attachments.json','/admin/media_categories.json');
  init_tree("#doc-attachment-tree",'DocCategory', '/admin/doc/attachments.json','/admin/doc_categories.json');

  //init the menu modify tree
  $("#menu-tree").tree({
    ui: { theme_path: '/stylesheets/jstree/themes/', theme_name : 'menu-tree' },
    rules: {draggable : 'all', clickable: 'all'},
    callback: {
      onload: function(TREE_OBJ){
        tree_id = $(TREE_OBJ.container).attr('id');
        $(TREE_OBJ.container).removeClass('tree-default');
      }
    }
  });
});

