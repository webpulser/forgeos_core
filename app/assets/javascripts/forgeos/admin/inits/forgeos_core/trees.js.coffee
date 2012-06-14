jQuery(document).ready ->
  jQuery.jstree._themes = "/assets/forgeos/jstree/themes/"
  jQuery('.category-tree').each ->
    tree = jQuery(this)
    init_category_tree tree, tree.data('model_name'), tree.data('url')

  init_association_category_tree "#association-attachment-tree", `undefined`, "attachment_category", "association_categories"

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
