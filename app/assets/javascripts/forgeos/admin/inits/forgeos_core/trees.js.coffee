jQuery(document).ready ->
  jQuery.jstree._themes = "/assets/forgeos/jstree/themes/"
  init_category_tree "#user-tree", "UserCategory", window._forgeos_js_vars.mount_paths.core + "/admin/user_categories.json"
  init_category_tree "#admins-tree", "AdministratorCategory", window._forgeos_js_vars.mount_paths.core + "/admin/administrator_categories.json"
  init_category_tree "#roles-tree", "RoleCategory", window._forgeos_js_vars.mount_paths.core + "/admin/role_categories.json"
  init_category_tree "#rights-tree", "RightCategory", window._forgeos_js_vars.mount_paths.core + "/admin/right_categories.json"
  init_category_tree "#audo-attachment-tree", "AudioCategory", window._forgeos_js_vars.mount_paths.core + "/admin/audio_categories.json"
  init_category_tree "#picture-attachment-tree", "PictureCategory", window._forgeos_js_vars.mount_paths.core + "/admin/picture_categories.json"
  init_category_tree "#pdf-attachment-tree", "PdfCategory", window._forgeos_js_vars.mount_paths.core + "/admin/pdf_categories.json"
  init_category_tree "#video-attachment-tree", "VideoCategory", window._forgeos_js_vars.mount_paths.core + "/admin/video_categories.json"
  init_category_tree "#media-attachment-tree", "MediaCategory", window._forgeos_js_vars.mount_paths.core + "/admin/media_categories.json"
  init_category_tree "#doc-attachment-tree", "DocCategory", window._forgeos_js_vars.mount_paths.core + "/admin/doc_categories.json"
  init_association_category_tree "#association-media-tree", `undefined`, "attachment_category", "association_categories"

  jQuery("#caching-tree").jstree
    json_data:
      ajax:
        url: window._forgeos_js_vars.mount_paths.core + "/admin/cachings.json"
        data: (n) ->
          id: (if n.data then n.data("name") else 0)

    checkbox:
      real_checkboxes: true
      real_checkboxes_names: (n) ->
        [ "files[]", n.data("name") ]

    plugins: [ "ui", "themes", "checkbox", "json_data" ]
