function duplicate_category(node, type, parent_id, base_url){
  var name = extract_category_name(node)
  var children = jQuery(node).children('ul').children('li');
  var parent_node = jQuery(node).parent().parent('li');

  // get parent_id from parent_node
  if ((parent_id == undefined) && (parent_node[0] != undefined))
    parent_id = get_rails_element_id(parent_node);

  jQuery.ajax({
    "url": base_url,
    // update node id and duplicate node children
    "complete": function(request){
      var cat_id = request.responseText;
      var jnode = jQuery(node);
      jnode.attr('id', 'category_' + cat_id);
      children.each(function(){ duplicate_category(jQuery(this), type, cat_id, base_url); });
      set_category_droppable(jnode.children('a'), type);
    },
    "data": get_category_data(name, type, parent_id),
    "dataType": 'text',
    "type": 'post'
  });
}

// return category data with or without parent category
function get_category_data(name, type, parent_id) {
  var datas = {
    "authenticity_token": window._forgeos_js_vars.token,
    "format": 'json',
    "category[name]": name,
    "category[kind]": type
  };

  if (parent_id) {
    datas["category[parent_id]"] = parent_id;
  }

  return datas;
}

// initialise tree theme and callbacks
function init_category_tree(selector, type, source) {
  if (jQuery(selector).size() != 0) {
    var base_url = source.replace('.json','/');

    jQuery(selector).bind('loaded.jstree',function(e, data){
      jQuery(e.target).find('a').each(function(index,selector){
        set_category_droppable(selector);
      });
    }).bind('create_node.jstree', function(e, data){

      var jnode = jQuery(data.rslt.obj);

      jQuery.ajax({
        "url": base_url,
        "complete": function(request){
          var cat_id = request.responseText;
          jnode.attr('id', 'category_' + cat_id);
          set_category_droppable(jnode.children('a'), type);

          if( jQuery(".parent_id_hidden").size() == 0){
            jQuery(document.body).append('<input type="hidden" id="parent_id_tmp" name="parent_id_tmp" class="parent_id_hidden" value="'+cat_id+'" />');
          } else {
            jQuery('#parent_id_tmp').val(cat_id);
          }
        },
        "data": get_category_data('New folder', type, get_rails_element_id(data.rslt.parent)),
        "dataType": 'text',
        "type": 'post'
      });
    }).bind('rename_node.jstree', function(e, data){
      jQuery.ajax({
        "url": base_url + get_rails_element_id(data.rslt.obj),
        "data": {
          "authenticity_token": window._forgeos_js_vars.token,
          "format": 'json',
          "category[name]": data.rslt.name
        },
        "dataType":'text',
        "type":'put'
      });

    }).bind('move_node.jstree', function(e, data){

      jQuery.ajax({
        "url": base_url + get_rails_element_id(data.rslt.o),
        "data": {
          "authenticity_token": window._forgeos_js_vars.token,
          "format": 'json',
          "category[parent_id]": get_rails_element_id(data.rslt.r),
          "category[position]": data.rslt.cp
        },
        "dataType": 'text',
        "type": 'put'
      });

    }).bind('delete_node.jstree', function(e, data){
      var NODE = data.rslt.obj;
      var cat_id = get_rails_element_id(NODE);
      jQuery.ajax({
        "url": base_url + cat_id,
        "success": function(request){
          jQuery(NODE).attr('id', 'category_' + request.responseText);
        },
        "data": {
          "authenticity_token": window._forgeos_js_vars.token,
          "format": 'json'
        },
        "dataType": 'text',
        "type": 'delete'
      });
    }).bind('copy.jstree', function(e, data) {
      duplicate_category(data.rslt.obj, type, undefined, base_url);
    }).bind('select_node.jstree', function(e, data) {

      var NODE = data.rslt.obj;
      var cat_id = get_rails_element_id(NODE);
      var current_table = jQuery('#table').dataTableInstance();
      var url = current_table.fnSettings().sAjaxSource;
      var url_base = url.split('?')[0];


      // update category id
      var params = get_json_params_from_url(url);
      params.category_id = cat_id;
      params = stringify_params_from_json(params);

      // construct url and redraw table
      update_current_dataTable_source('#table',url_base + '?' + params);

      // add parent_id_tmp for uploads
      var category_id = get_rails_element_id(NODE);
      if(jQuery(".parent_id_hidden").size() == 0){
        jQuery(document.body).append('<input type="hidden" id="parent_id_tmp" name="parent_id_tmp" class="parent_id_hidden" value="'+category_id+'" />');
      } else {
        jQuery('#parent_id_tmp').val(category_id);
      }
      jQuery('#category_sort').show();

      return true;

    }).bind('deselect_node.jstree', function(e, data) {
      jQuery('#category_sort').hide();
      return true;
    }).jstree({
      "json_data":{
        "ajax": {
          "url": source,
          "data" : function (n) {
             return { id: (n.data ? n.data('id') : 0) };
          }
        },
        "progressive_render": true
      },
      "contextmenu": {
        "items": {
          "create": {
            "label": "Créer",
            "icon": "create",
            "action": function(obj) {
              this.create(this._get_node(obj), 0, {}, null, false);
            },
            separator_after : false
          },
          "rename": {
            "label": "Renommer",
            "icon": "rename",
            "action": function(obj) {
              this.rename(obj);
            }
          },
          "remove": {
            "label": "Supprimer",
            "icon": "remove",
            "action": function(obj) {
              var tree = this;
              jQuery.each(obj, function () {
                tree.remove(this);
              });
            }
          },
          "add_image": {
            "label": "Changer l'image",
            "icon": "image",
            "action": function(obj) {
              jQuery('.add-image').removeClass('.current');
              jQuery(obj).addClass('add-image').addClass('current');
              jQuery(obj).data('callback', 'add_picture_to_category');

              openimageUploadDialog();
              return false;
            }
          }
        }
      },
      "themes": {
        "theme": 'categories'
      },
      "plugins": ['ui', 'themes', 'json_data', 'contextmenu', 'crrm', 'dnd']
    });
  }
}

//check if something is selected in jsTree
function check_jsTree_selected(element){
  if(typeof(jQuery.jstree._reference(element).selected) != 'undefined'){
    return true;
  } else {
    return false;
  }
}

/*
 *call when ther's a problem with jsTree control
 *param : message
 **/
function error_on_jsTree_action(message){
}

// initialize tree for category associations
function init_association_category_tree(selector, object_name, category_name, theme){
  if (jQuery(selector).size() != 0) {
    jQuery(selector).bind('check_node.jstree', function(e, data){
      var jnode = jQuery(data.rslt.obj);
      if (typeof(object_name) == 'undefined') {
        var oname = jnode.attr('id').split('_')[0];
      } else {
        var oname = object_name;
      }
      var category_id = get_rails_element_id(jnode);
      jnode.append('<input type="hidden" id="'+oname+'_'+category_name+'_ids_'+category_id+'" name="'+oname+'['+category_name+'_ids][]" value="'+category_id+'" />');
      jnode.addClass('jstree-clicked');
    }).bind('uncheck_node.jstree', function(e, data){
      var jnode = jQuery(data.rslt.obj);
      jnode.children('input').remove();
      jnode.removeClass('jstree-clicked');
    }).jstree({
      "themes": {
        "theme": theme
      },
      "ui": {
        "selected_parent_close": false
      },
      "plugins": ['html_data', 'ui', 'themes', 'checkbox']
    });
  }
}

// unselect current node and refresh dataTables
function select_all_elements_by_url(url) {
  // change dataTables ajax source en redraw the table
  oTable.fnSettings().sAjaxSource = url;
  oTable.fnDraw();
}

// unselect current node, remove category and refresh dataTable
function select_all_elements_without_category(tree_id) {
  var t = jQuery.jstree._focused();

  // unselect current selected node
  if (t) {
    t.deselect_branch(t.selected);
    t.selected = null;
  }

  // remove category from dataTables ajax source and redraw the table
  var current_table = oTable;
  var url = current_table.fnSettings().sAjaxSource;
  var url_base = url.split('?')[0];
  var params;

  // update category id
  params = get_json_params_from_url(url);
  params.category_id = null;
  params = stringify_params_from_json(params);

  // construct url and redraw table
  update_current_dataTable_source('#'+oTable.sInstance,url_base + '?' + params);
  jQuery('#parent_id_tmp').remove();
  return true;
}

function update_parent_categories_count(element) {
  element.parents('li').each(function(){
    span = jQuery(this).children('a').children('span');
    span.html(parseInt(span.text()) + 1);
  });
}

// return category name by extracting text from node link and by removing inner span
function extract_category_name(node) {
  var link = jQuery(node).children('a');
  return link.text().replace(link.children('span').text(), '');
}

// on drop, the dropped element is added to the selected category
function set_category_droppable(selector, type) {
  var category = jQuery(selector);
  category.droppable({
    "hoverClass": 'ui-state-hover',
    "drop": function(ev, ui){
      var droppable = jQuery(this);
      jQuery.ajax({
        "data": {
          "element_id": get_rails_element_id(jQuery(ui.draggable)),
          "authenticity_token": encodeURIComponent(window._forgeos_js_vars.token)
        },
        "success": function(request){
          droppable.effect('highlight', {}, 1000);
        },
        "type": 'post',
        "url": '/admin/categories/' + get_rails_element_id(category.parent()) + '/add_element'
      })
    }
  });
}

function removeClasses(){
  var elementsWithClassName=jQuery('.lightbox-container').find('.clicked, .active');
  elementsWithClassName.removeClass('clicked active');
}

function addBlockClasses(){
  jQuery('.block-selected').each(function(){
    var block_id = jQuery(this).val();
    jQuery('.blocks-tree').find('.block').each(function(){
      if(jQuery(this).parent().attr('id').substr(6) == block_id){
        jQuery(this).addClass('active');
      }
    });
  });
}

function addPageClasses(block_id){
  jQuery('#links_block_' + block_id).find('.block-selected').each(function(){
    var page_id = jQuery(this).attr('id').split('_')[3];
    jQuery('.pages-tree').find('.page').each(function(){
      if(jQuery(this).parent().attr('id').substr(5) == page_id){
        jQuery(this).addClass('active');
      }
    });
  });
}

function createNewLevel(parent_node,item, TREE_OBJ, level) {
  jQuery(item).each(function(){
    var cat_id = get_rails_element_id(jQuery(this));
    var parent_ul = jQuery(TREE_OBJ).children();
    var position = jQuery(parent_ul).children('li').index(jQuery(this));
    position = position+1;

    if(jQuery(this).attr('tagName') == 'UL'){
      //parent["categorie_"+cat_id] = {};
      //createNewLevel(parent["categorie_"+cat_id],jQuery(this).children().children(), TREE_OBJ);
    }
    else{
      if(jQuery(this).children().length > 1){
        parent_node["category_"+cat_id] = {};
        createNewLevel(parent_node["category_"+cat_id],jQuery(this).children().children(), TREE_OBJ);
      } else{
        parent_node["category_"+cat_id] = cat_id;
      }
    }
  });
}
