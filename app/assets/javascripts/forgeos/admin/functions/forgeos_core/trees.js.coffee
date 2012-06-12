window.duplicate_category = (node, type, parent_id, base_url) ->
  name = extract_category_name(node)
  children = jQuery(node).children("ul").children("li")
  parent_node = jQuery(node).parent().parent("li")
  parent_id = get_rails_element_id(parent_node)  if (parent_id is `undefined`) and (parent_node[0] isnt `undefined`)
  jQuery.ajax
    url: base_url
    complete: (request) ->
      cat_id = request.responseText
      jnode = jQuery(node)
      jnode.attr "id", "category_" + cat_id
      children.each ->
        duplicate_category jQuery(this), type, cat_id, base_url

      set_category_droppable jnode.children("a"), type

    data: get_category_data(name, type, parent_id)
    dataType: "json"
    type: "post"

window.get_category_data = (name, type, parent_id) ->
  datas =
    "category[name]": name
    "category[kind]": type

  datas["category[parent_id]"] = parent_id  if parent_id
  datas

window.init_category_tree = (selector, type, source) ->
  unless jQuery(selector).size() is 0
    base_url = source.replace(".json", "/")
    jQuery(selector).bind("loaded.jstree", (e, data) ->
      jQuery(e.target).find("li > a").each (index, selector) ->
        set_category_droppable selector
    ).bind("after_open.jstree", (e, data) ->
      jQuery(data.rslt.obj).find("li > a").each (index, selector) ->
        set_category_droppable selector
    ).bind("create_node.jstree", (e, data) ->
      jnode = jQuery(data.rslt.obj)
      jQuery.ajax
        url: base_url
        complete: (request) ->
          cat_id = request.responseText
          jnode.attr "id", "category_" + cat_id
          set_category_droppable jnode.children("a"), type
          if jQuery(".parent_id_hidden").size() is 0
            jQuery(document.body).append "<input type=\"hidden\" id=\"parent_id_tmp\" name=\"parent_id_tmp\" class=\"parent_id_hidden\" value=\"" + cat_id + "\" />"
          else
            jQuery("#parent_id_tmp").val cat_id

        data: get_category_data("New folder", type, get_rails_element_id(data.rslt.parent))
        dataType: "text"
        type: "post"
    ).bind("rename_node.jstree", (e, data) ->
      jQuery.ajax
        url: base_url + get_rails_element_id(data.rslt.obj)
        data:
          "category[name]": data.rslt.name

        dataType: "json"
        type: "put"
    ).bind("move_node.jstree", (e, data) ->
      jQuery.ajax
        url: base_url + get_rails_element_id(data.rslt.o)
        data:
          "category[parent_id]": get_rails_element_id(data.rslt.r)
          "category[position]": data.rslt.cp

        dataType: "json"
        type: "put"
    ).bind("delete_node.jstree", (e, data) ->
      NODE = data.rslt.obj
      cat_id = get_rails_element_id(NODE)
      jQuery.ajax
        url: base_url + cat_id
        success: (request) ->
          jQuery(NODE).attr "id", "category_" + request.responseText

        dataType: "json"
        type: "delete"
    ).bind("copy.jstree", (e, data) ->
      duplicate_category data.rslt.obj, type, `undefined`, base_url
    ).bind("select_node.jstree", (e, data) ->
      NODE = data.rslt.obj
      cat_id = get_rails_element_id(NODE)
      current_table = jQuery("#table").dataTableInstance()
      url = current_table.fnSettings().sAjaxSource
      url_base = url.split("?")[0]
      params = get_json_params_from_url(url)
      params.category_id = cat_id
      params = stringify_params_from_json(params)
      update_current_dataTable_source current_table, url_base + "?" + params
      if jQuery(".parent_id_hidden").size() is 0
        jQuery(document.body).append "<input type=\"hidden\" id=\"parent_id_tmp\" name=\"parent_id_tmp\" class=\"parent_id_hidden\" value=\"" + cat_id + "\" />"
      else
        jQuery("#parent_id_tmp").val cat_id
      jQuery("#category_sort").show()
      true
    ).bind("deselect_node.jstree, deselect_all.jstree", (e, data) ->
      jQuery("#category_sort").hide()
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
              jQuery.each obj, ->
                tree.remove this

          add_image:
            label: "Changer l'image"
            icon: "image"
            action: (obj) ->
              jQuery(".add-image").removeClass ".current"
              jQuery(obj).addClass("add-image").addClass "current"
              jQuery(obj).data "callback", "add_picture_to_category"
              openimageUploadDialog()
              false

      themes:
        theme: "categories"

      plugins: [ "ui", "themes", "json_data", "contextmenu", "crrm", "dnd" ]
window.check_jsTree_selected = (element) ->
  unless typeof (jQuery.jstree._reference(element).selected) is "undefined"
    true
  else
    false
window.error_on_jsTree_action = (message) ->
  alert(message)

window.init_association_category_tree = (selector, object_name, category_name, theme) ->
  unless jQuery(selector).size() is 0
    jQuery(selector).bind("check_node.jstree", (e, data) ->
      jnode = jQuery(data.rslt.obj)
      if typeof (object_name) is "undefined"
        oname = jnode.attr("id").split("_")[0]
      else
        oname = object_name
      category_id = get_rails_element_id(jnode)
      jnode.append "<input type=\"hidden\" id=\"" + oname + "_" + category_name + "_ids_" + category_id + "\" name=\"" + oname + "[" + category_name + "_ids][]\" value=\"" + category_id + "\" />"
      jnode.addClass "jstree-clicked"
    ).bind("uncheck_node.jstree", (e, data) ->
      jnode = jQuery(data.rslt.obj)
      jnode.children("input").remove()
      jnode.removeClass "jstree-clicked"
    ).jstree
      themes:
        theme: theme

      ui:
        selected_parent_close: false

      plugins: [ "html_data", "ui", "themes", "checkbox" ]
window.select_all_elements_by_url = (url) ->
  oTable.fnSettings().sAjaxSource = url
  oTable.fnDraw()
window.select_all_elements_without_category = (tree_id) ->
  t = jQuery.jstree._focused()
  t.deselect_all()  if t
  current_table = jQuery("#table").dataTableInstance()
  url = current_table.fnSettings().sAjaxSource
  url_base = url.split("?")[0]
  params = undefined
  params = get_json_params_from_url(url)
  params.category_id = null
  params = stringify_params_from_json(params)
  update_current_dataTable_source current_table, url_base + "?" + params
  jQuery("#parent_id_tmp").remove()
  true
window.update_parent_categories_count = (element) ->
  element.parents("li").each ->
    span = jQuery(this).children("a").children("span")
    span.html parseInt(span.text()) + 1
window.extract_category_name = (node) ->
  link = jQuery(node).children("a")
  link.text().replace link.children("span").text(), ""
window.set_category_droppable = (selector, type) ->
  category = jQuery(selector)
  category.droppable
    hoverClass: "ui-state-hover"
    drop: (ev, ui) ->
      droppable = jQuery(this)
      jQuery.ajax
        data:
          element_id: get_rails_element_id(jQuery(ui.draggable))

        success: (request) ->
          droppable.effect "highlight", {}, 1000

        type: "post"
        url: window._forgeos_js_vars.mount_paths.core + "/admin/categories/" + get_rails_element_id(category.parent()) + "/add_element"
window.removeClasses = ->
  elementsWithClassName = jQuery(".lightbox-container").find(".clicked, .active")
  elementsWithClassName.removeClass "clicked active"
window.addBlockClasses = ->
  jQuery(".block-selected").each ->
    block_id = jQuery(this).val()
    jQuery(".blocks-tree").find(".block").each ->
      jQuery(this).addClass "active"  if jQuery(this).parent().attr("id").substr(6) is block_id
window.addPageClasses = (block_id) ->
  jQuery("#links_block_" + block_id).find(".block-selected").each ->
    page_id = jQuery(this).attr("id").split("_")[3]
    jQuery(".pages-tree").find(".page").each ->
      jQuery(this).addClass "active"  if jQuery(this).parent().attr("id").substr(5) is page_id
window.createNewLevel = (parent_node, item, TREE_OBJ, level) ->
  jQuery(item).each ->
    cat_id = get_rails_element_id(jQuery(this))
    parent_ul = jQuery(TREE_OBJ).children()
    position = jQuery(parent_ul).children("li").index(jQuery(this))
    position = position + 1
    unless jQuery(this).attr("tagName") is "UL"
      if jQuery(this).children().length > 1
        parent_node["category_" + cat_id] = {}
        createNewLevel parent_node["category_" + cat_id], jQuery(this).children().children(), TREE_OBJ
      else
        parent_node["category_" + cat_id] = cat_id
