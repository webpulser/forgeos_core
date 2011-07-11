jQuery(document).ready(function(){
  $.jstree._themes = '/assets/forgeos/jstree/themes/';

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

  init_association_category_tree('#association-media-tree', undefined, 'attachment_category', 'association_categories');
});
