define 'forgeos/core/admin/trees', ['jquery', './base', './attachments', 'jquery.jstree', 'forgeos/jqueryui/jquery.ui.droppable'], ($, Base, Attachments) ->

  duplicate_category = (node, type, parent_id, base_url) ->
    name = extract_category_name(node)
    children = $(node).children("ul").children("li")
    parent_node = $(node).parent().parent("li")
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

  get_category_data = (name, type, parent_id) ->
    datas =
      "category[name]": name
      "category[kind]": type

    datas["category[parent_id]"] = parent_id  if parent_id
    datas

  init_category_tree = (tree, type, source) ->
      base_url = source.replace(".json", "/")
      tree.bind("loaded.jstree", (e, data) ->
        $(e.target).find("li > a").each (index, selector) ->
          set_category_droppable selector
      ).bind("after_open.jstree", (e, data) ->
        $(data.rslt.obj).find("li > a").each (index, selector) ->
          set_category_droppable selector
      ).bind("create_node.jstree", (e, data) ->
        jnode = $(data.rslt.obj)
        $.ajax
          url: base_url
          complete: (request) ->
            cat_id = request.responseText
            jnode.attr "id", "category_" + cat_id
            set_category_droppable jnode.children("a"), type
            if $(".parent_id_hidden").size() is 0
              $(document.body).append "<input type=\"hidden\" id=\"parent_id_tmp\" name=\"parent_id_tmp\" class=\"parent_id_hidden\" value=\"" + cat_id + "\" />"
            else
              $("#parent_id_tmp").val cat_id

          data: get_category_data("New folder", type, Base.get_rails_element_id(data.rslt.parent))
          dataType: "json"
          type: "post"
      ).bind("rename_node.jstree", (e, data) ->
        $.ajax
          url: base_url + Base.get_rails_element_id(data.rslt.obj)
          data:
            "category[name]": data.rslt.name

          dataType: "json"
          type: "put"
      ).bind("move_node.jstree", (e, data) ->
        $.ajax
          url: base_url + Base.get_rails_element_id(data.rslt.o)
          data:
            "category[parent_id]": Base.get_rails_element_id(data.rslt.r)
            "category[position]": data.rslt.cp

          dataType: "json"
          type: "put"
      ).bind("delete_node.jstree", (e, data) ->
        NODE = data.rslt.obj
        cat_id = Base.get_rails_element_id(NODE)
        $.ajax
          url: base_url + cat_id
          success: (request) ->
            $(NODE).attr "id", "category_" + request.responseText

          dataType: "json"
          type: "delete"
      ).bind("copy.jstree", (e, data) ->
        duplicate_category data.rslt.obj, type, `undefined`, base_url
      ).bind("select_node.jstree", (e, data) ->
        NODE = data.rslt.obj
        cat_id = Base.get_rails_element_id(NODE)
        current_table = $("#table").dataTableInstance()
        url = current_table.fnSettings().sAjaxSource
        url_base = url.split("?")[0]
        params = get_json_params_from_url(url)
        params.category_id = cat_id
        params = stringify_params_from_json(params)
        update_current_dataTable_source current_table, url_base + "?" + params
        if $(".parent_id_hidden").size() is 0
          $(document.body).append "<input type=\"hidden\" id=\"parent_id_tmp\" name=\"parent_id_tmp\" class=\"parent_id_hidden\" value=\"" + cat_id + "\" />"
        else
          $("#parent_id_tmp").val cat_id
        $("#category_sort").show()
        true
      ).bind("deselect_node.jstree, deselect_all.jstree", (e, data) ->
        $("#category_sort").hide()
        true
      ).jstree
        json_data:
          ajax:
            url: source
            data: (n) ->
              id: (if n.data then n.data("id") else 0)

          progressive_render: true

        contextmenu:
          items:
            create:
              label: "Créer"
              icon: "create"
              action: (obj) ->
                @create @_get_node(obj), 0, {}, null, false

              separator_after: false

            rename:
              label: "Renommer"
              icon: "rename"
              action: (obj) ->
                @rename obj

            remove:
              label: "Supprimer"
              icon: "remove"
              action: (obj) ->
                tree = this
                $.each obj, ->
                  tree.remove this

            add_image:
              label: "Changer l'image"
              icon: "image"
              action: (obj) ->
                button = $(obj)
                $(".add-image").removeClass ".current"
                button.addClass("add-image").addClass "current"
                button.data "callback", "add_picture_to_category"
                Attachments.open_upload_dialog('image', button)

                false

        themes:
          theme: "categories"

        plugins: [ "ui", "themes", "json_data", "contextmenu", "crrm", "dnd" ]

  check_jsTree_selected = (element) ->
    typeof ($.jstree._reference(element).selected) is "undefined"

  error_on_jsTree_action = (message) ->
    alert(message)

  init_association_category_tree = (selector, object_name, category_name, theme) ->
    unless $(selector).size() is 0
      $(selector).bind("check_node.jstree", (e, data) ->
        jnode = $(data.rslt.obj)
        if typeof (object_name) is "undefined"
          oname = jnode.attr("id").split("_")[0]
        else
          oname = object_name
        category_id = Base.get_rails_element_id(jnode)
        jnode.append "<input type=\"hidden\" id=\"" + oname + "_" + category_name + "_ids_" + category_id + "\" name=\"" + oname + "[" + category_name + "_ids][]\" value=\"" + category_id + "\" />"
        jnode.addClass "jstree-clicked"
      ).bind("uncheck_node.jstree", (e, data) ->
        jnode = $(data.rslt.obj)
        jnode.children("input").remove()
        jnode.removeClass "jstree-clicked"
      ).jstree
        themes:
          theme: theme

        ui:
          selected_parent_close: false

        plugins: [ "html_data", "ui", "themes", "checkbox" ]

  select_all_elements_by_url = (url) ->
    oTable.fnSettings().sAjaxSource = url
    oTable.fnDraw()

  select_all_elements_without_category = (tree_id) ->
    tree = $.jstree._focused()
    tree.deselect_all()  if tree

    table = $("##{tree_id}").parents('.row-fluid').find('.dataslide:visible,.datatable:visible')
    current_table = table.dataTableInstance()

    url = current_table.fnSettings().sAjaxSource
    url_base = url.split("?")[0]
    params = undefined
    params = get_json_params_from_url(url)
    params.category_id = null
    params = stringify_params_from_json(params)
    update_current_dataTable_source current_table, url_base + "?" + params
    $("#parent_id_tmp").remove()
    true

  update_parent_categories_count = (element) ->
    element.parents("li").each ->
      span = $(this).children("a").children("span")
      span.html parseInt(span.text()) + 1

  extract_category_name = (node) ->
    link = $(node).children("a")
    link.text().replace link.children("span").text(), ""

  set_category_droppable = (selector, type) ->
    category = $(selector)
    category.droppable
      hoverClass: "ui-state-hover"
      drop: (ev, ui) ->
        droppable = $(this)
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
      cat_id = Base.get_rails_element_id($(this))
      parent_ul = $(TREE_OBJ).children()
      position = $(parent_ul).children("li").index($(this))
      position = position + 1
      unless $(this).attr("tagName") is "UL"
        if $(this).children().length > 1
          parent_node["category_" + cat_id] = {}
          createNewLevel parent_node["category_" + cat_id], $(this).children().children(), TREE_OBJ
        else
          parent_node["category_" + cat_id] = cat_id

  init_caching_tree = ->
    $("#caching-tree").jstree
      json_data:
        ajax:
          url: _forgeos_js_vars.mount_paths.core + "/admin/cachings.json"
          data: (n) ->
            id: (if n.data then n.data("name") else 0)

      checkbox:
        real_checkboxes: true
        real_checkboxes_names: (n) ->
          [ "files[]", n.data("name") ]

      plugins: [ "ui", "themes", "checkbox", "json_data" ]

  initialize = ->
    $.jstree._themes = "/assets/forgeos/jstree/themes/"
    $('.category-tree').each ->
      tree = $(this)
      init_category_tree tree, tree.data('model_name'), tree.data('url')

    init_association_category_tree "#association-attachment-tree", `undefined`, "attachment_category", "association_categories"
    init_caching_tree()

  # public methods
  new: initialize
