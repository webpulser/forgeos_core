define 'forgeos/core/admin/trees', ['jquery'], ($) ->

  # Duplicate a category in the tree
  duplicate_category = (node, type, parent_id, base_url) ->
    name = extract_category_name(node)
    children = $(node).children("ul").children("li")
    parent_node = $(node).parent().parent("li")
    require ['forgeos/core/admin/base'], (Base) ->
      parent_id = Base.get_rails_element_id(parent_node)  if (parent_id is `undefined`) and (parent_node[0] isnt `undefined`)
      $.ajax
        url: base_url
        complete: (request) ->
          cat_id = request.responseText
          jnode = $(node)
          jnode.attr "id", "category_" + cat_id
          children.each ->
            duplicate_category $(this), type, cat_id, base_url

          set_category_droppable jnode.children("a"), type

        data: get_category_data(name, type, parent_id)
        dataType: "json"
        type: "post"

  # collect category datas
  get_category_data = (name, type, parent_id) ->
    datas =
      "category[name]": name
      "category[kind]": type

    datas["category[parent_id]"] = parent_id  if parent_id?

    datas

  # Initialize a new category tree with JsTree
  init_category_tree = (tree, type, source) ->
    return true unless tree?

    plugins = [ 'ui', 'themes', 'json', 'contextmenu', 'dnd']
    require require_jstree_plugins(plugins), ->
      setup_jstree()
      base_url = source.replace(".json", "/")

      tree.bind("loaded.jstree", (e, data) ->
        $(e.target).find("li > a").each (index, selector) ->
          set_category_droppable selector
      ).bind("after_open.jstree", (e, data) ->
        $(data.rslt.obj).find("li > a").each (index, selector) ->
          set_category_droppable selector
      ).bind("create_node.jstree", (e, data) ->
        jnode = $(data.rslt.obj)
        require ['forgeos/core/admin/base'], (Base) ->
          $.ajax
            url: base_url
            complete: (request) ->
              require ['forgeos/core/admin/notifications'], (Notifications) ->
                Notifications.new()

              cat_id = request.responseText
              jnode.attr "id", "category_" + cat_id
              set_category_droppable jnode.children("a"), type
              if $(".parent_id_hidden").size() is 0
                require ['mustache', 'text!templates/admin/trees/current_node.html'], (Mustache, node) ->
                  $(document.body).append Mustache.render node,
                    value: cat_id
              else
                $("#parent_id_tmp").val cat_id

            data: get_category_data("New folder", type, Base.get_rails_element_id(data.rslt.parent))
            dataType: "json"
            type: "post"
      ).bind("rename_node.jstree", (e, data) ->
        require ['forgeos/core/admin/base'], (Base) ->
          $.ajax
            url: base_url + Base.get_rails_element_id(data.rslt.obj)
            data:
              "category[name]": data.rslt.title
            complete: ->
              require ['forgeos/core/admin/notifications'], (Notifications) ->
                Notifications.new()
            dataType: "json"
            type: "put"
      ).bind("move_node.jstree", (e, data) ->
        require ['forgeos/core/admin/base'], (Base) ->
          $.ajax
            url: base_url + Base.get_rails_element_id(data.rslt.obj)
            data:
              "category[parent_id]": Base.get_rails_element_id(data.rslt.parent)
              "category[position]": data.rslt.position
            complete: ->
              require ['forgeos/core/admin/notifications'], (Notifications) ->
                Notifications.new()
            dataType: "json"
            type: "put"
      ).bind("delete_node.jstree", (e, data) ->
        NODE = data.rslt.obj
        require ['forgeos/core/admin/base'], (Base) ->
          cat_id = Base.get_rails_element_id(NODE)
          $.ajax
            url: base_url + cat_id
            success: (request) ->
              $(NODE).attr "id", "category_" + request.responseText
              require ['forgeos/core/admin/notifications'], (Notifications) ->
                Notifications.new()

            dataType: "json"
            type: "delete"
      ).bind("copy.jstree", (e, data) ->
        duplicate_category data.rslt.obj, type, `undefined`, base_url
      ).bind("select_node.jstree", (e, data) ->
        NODE = data.rslt.obj
        require ['forgeos/core/admin/base'], (Base) ->
          cat_id = Base.get_rails_element_id(NODE)
          if $(".parent_id_hidden").length > 0
            require ['mustache', 'text!templates/admin/trees/current_node.html'], (Mustache, node) ->
              $(document.body).append Mustache.render node,
                value: cat_id
          else
            $("#parent_id_tmp").val cat_id

          $("#category_sort").show()

          require ['forgeos/core/admin/datatables'], (Datatables) ->
            current_table = $("#table").dataTableInstance()
            url = current_table.fnSettings().sAjaxSource
            url_base = url.split("?")[0]
            params = Base.get_json_params_from_url(url)
            params.category_id = cat_id
            Datatables.update_current_dataTable_source current_table, url_base + "?" + Base.stringify_params_from_json(params)

        true
      ).bind("deselect_node.jstree, deselect_all.jstree", (e, data) ->
        $("#category_sort").hide()
        true
      ).jstree
        json:
          ajax:
            url: source
            data: (n) ->
              id: (if n.data then n.data("id") else 0)

          progressive_render: true
        contextmenu:
          items:
            create:
              separator_before: false
              separator_after: true
              label: 'Create'
              icon: 'icon icon-plus-sign'
              action: (data) ->
                inst = $.jstree._reference(data.reference)
                obj = inst.get_node(data.reference)
                inst.create_node obj, {}, 'last', (new_node) ->
                  edit = ->
                    inst.edit new_node
                  setTimeout(edit, 0)
            rename:
              separator_before: false
              separator_after: false
              label: 'Rename'
              icon: 'icon icon-edit'
              action: (data) ->
                inst = $.jstree._reference(data.reference)
                obj = inst.get_node(data.reference)
                inst.edit obj
            remove:
              separator_before: false
              separator_after: false
              label: 'Delete'
              icon: 'icon icon-trash'
              action: (data) ->
                inst = $.jstree._reference(data.reference)
                obj = inst.get_node(data.reference)
                inst.delete_node obj
            add_image:
              label: "Changer l'image"
              icon: 'icon icon-picture'
              action: (data) ->
                inst = $.jstree._reference(data.reference)
                obj = inst.get_node(data.reference)
                button = $(obj)

                $(".add-image").removeClass ".current"
                button.addClass("add-image current")
                button.data "callback", "add_picture_to_category"
                require ['forgeos/core/admin/attachments'], (Attachments) ->
                  Attachments.open_upload_dialog('image', button)

                false

        themes:
          theme: "categories"

        plugins: plugins

  check_jsTree_selected = (element) ->
    typeof ($.jstree._reference(element).selected) is "undefined"

  error_on_jsTree_action = (message) ->
    alert(message)

  require_jstree_plugins = (plugins) ->
    pls = $(plugins).map (i, name) ->
      "jstree/jstree.#{name}"
    ['jstree/jstree'].concat pls.toArray()

  init_association_category_tree = (selector, object_name, category_name, theme) ->
    tree = $(selector)
    if tree.length > 0
      plugins = ['html_data', 'ui', 'themes', 'checkbox']
      require require_jstree_plugins(plugins), ->
        setup_jstree()

        tree.bind("check_node.jstree", (e, data) ->
          jnode = $(data.rslt.obj)
          jnode.addClass "jstree-clicked"
          require [
            'forgeos/core/admin/base',
            'mustache',
            'text!templates/admin/trees/category_input.html'
          ], (
            Base,
            Mustache,
            input
          ) ->
            object_name = jnode.attr("id").split("_")[0] if object_name?
            category_id = Base.get_rails_element_id(jnode)

            jnode.append Mustache.render input,
              object_name: object_name
              association: category_name
              value: category_id


        ).bind("uncheck_node.jstree", (e, data) ->
          jnode = $(data.rslt.obj)
          jnode.children("input").remove()
          jnode.removeClass "jstree-clicked"
        ).jstree
          themes:
            theme: theme

          ui:
            selected_parent_close: false

          plugins: plugins

  select_all_elements_by_url = (url) ->
    oTable.fnSettings().sAjaxSource = url
    oTable.fnDraw()

  update_parent_categories_count = (element) ->
    element.parents("li").each ->
      span = $(this).children("a").children("span")
      span.html parseInt(span.text()) + 1

  extract_category_name = (node) ->
    link = $(node).children("a")
    link.text().replace link.children("span").text(), ""

  set_category_droppable = (selector, type) ->
    category = $(selector)
    if category.length > 0
      require ['jqueryui/jquery.ui.droppable'], ->
        category.droppable
          hoverClass: "ui-state-hover"
          drop: (ev, ui) ->
            droppable = $(this)

            require ['forgeos/core/admin/base'], (Base) ->
              $.ajax
                data:
                  element_id: Base.get_rails_element_id($(ui.draggable))

                success: (request) ->
                  droppable.effect "highlight", {}, 1000

                type: "post"
                url: _forgeos_js_vars.mount_paths.core + "/admin/categories/" + Base.get_rails_element_id(category.parent()) + "/add_element"

  addBlockClasses = ->
    $(".block-selected").each ->
      block_id = $(this).val()
      $(".blocks-tree").find(".block").each ->
        $(this).addClass "active"  if $(this).parent().attr("id").substr(6) is block_id

  addPageClasses = (block_id) ->
    $("#links_block_" + block_id).find(".block-selected").each ->
      page_id = $(this).attr("id").split("_")[3]
      $(".pages-tree").find(".page").each ->
        $(this).addClass "active"  if $(this).parent().attr("id").substr(5) is page_id

  createNewLevel = (parent_node, item, TREE_OBJ, level) ->
    $(item).each ->
      level = $(this)
      require ['forgeos/core/admin/base'], (Base) ->
        cat_id = Base.get_rails_element_id(level)
        parent_ul = $(TREE_OBJ).children()
        position = $(parent_ul).children("li").index(level)
        position = position + 1
        unless level.attr("tagName") is "UL"
          if level.children().length > 1
            parent_node["category_" + cat_id] = {}
            createNewLevel parent_node["category_" + cat_id], level.children().children(), TREE_OBJ
          else
            parent_node["category_" + cat_id] = cat_id

  setup_jstree = ->
    $.jstree.THEMES_DIR = "/assets/forgeos/jstree/themes/"

  init_caching_tree = ->
    tree = $("#caching-tree")
    if tree.length > 0
      plugins = [ 'ui', 'themes', 'checkbox', 'json' ]
      require require_jstree_plugins(plugins), ->
        setup_jstree()
        tree.jstree
          json:
            ajax:
              url: _forgeos_js_vars.mount_paths.core + "/admin/cachings.json"
              data: (n) ->
                id: (if n.data then n.data("name") else 0)
          plugins: plugins

  init_category_trees = ->
    $('.category-tree').each ->
      tree = $(this)
      init_category_tree tree, tree.data('model_name'), tree.data('url')

  initialize = ->
    init_category_trees()
    init_association_category_tree "#association-attachment-tree", null, "attachment_category", "association_categories"
    init_caching_tree()

  # public methods
  new: initialize
