function duplicate_category(node, type, parent_id){
  var name = extract_category_name(node)
  var children = jQuery(node).children('ul').children('li');
  var parent_node = jQuery(node).parent().parent('li');

  // get parent_id from parent_node
  if ((parent_id == undefined) && (parent_node[0] != undefined))
    parent_id = get_rails_element_id(parent_node);

  jQuery.ajax({
    "url": '/admin/categories/create',
    // update node id and duplicate node children
    "complete": function(request){
      var cat_id = request.responseText;
      jQuery(node).attr('id', 'cageory_' + cat_id);
      children.each(function(){ duplicate_category(jQuery(this), type, cat_id); });

      jQuery(node).children('a').attr('id', 'link_category_' + cat_id);
      jQuery(node).children('a').children('span').attr('id', 'span_category_' + cat_id);

      set_category_droppable(cat_id, type);
    },
    "data": get_category_data(name, type, parent_id),
    "dataType": 'text',
    "type": 'post'
  });
}

// return category data with or without parent category
function get_category_data(name, type, parent_id) {
  if (parent_id)
    return {authenticity_token:window._forgeos_js_vars.token, format: 'json', 'category[name]': name, 'category[kind]': type, 'category[parent_id]': parent_id};
  else
    return {authenticity_token:window._forgeos_js_vars.token, format: 'json', 'category[name]': name, 'category[kind]': type};
}

// initialise tree theme and callbacks
function init_category_tree(selector, type, source) {
  jQuery(selector).tree({
    data:{
      type: 'json',
      opts: {
        url: source
      }
    },
    plugins: {
      'contextmenu': {
        items : {
          create : {
            label : "Créer",
            icon  : "create",
            visible : function (NODE, TREE_OBJ) {
              if(NODE.length != 1) return 0;
              return TREE_OBJ.check("creatable", NODE);
            },
            action  : function (NODE, TREE_OBJ) {
              TREE_OBJ.create(false, TREE_OBJ.get_node(NODE[0]));
            },
            separator_after : false
          },
          rename : {
            label : "Renommer",
            icon  : "rename",
            visible : function (NODE, TREE_OBJ) {
              if(NODE.length != 1) return false;
              return TREE_OBJ.check("renameable", NODE);
            },
            action  : function (NODE, TREE_OBJ) {
              TREE_OBJ.rename(NODE);
            }
          },
          remove : {
            label : "Supprimer",
            icon  : "remove",
            visible : function (NODE, TREE_OBJ) {
              var ok = true;
              jQuery.each(NODE, function () {
                if(TREE_OBJ.check("deletable", this) == false) {
                  ok = false;
                  return false;
                }
              });
              return ok;
            },
            action  : function (NODE, TREE_OBJ) {
              jQuery.each(NODE, function () {
                TREE_OBJ.remove(this);
              });
            }
          },
          add_image : {
            label : "Add image",
            icon  : "image",
            visible : function (NODE, TREE_OBJ) {
              var ok = true;
              jQuery.each(NODE, function () {
                if(TREE_OBJ.check("deletable", this) == false) {
                  ok = false;
                  return false;
                }
              });
              return ok;
            },
            action  : function (NODE, TREE_OBJ) {
              var cat_id = get_rails_element_id(NODE);
              jQuery('.tree-li-selected-to-add-image').each(function(){
                jQuery(this).removeClass('tree-li-selected-to-add-image');
              });
              jQuery(NODE).addClass("tree-li-selected-to-add-image");

              openimageUploadDialogLeftSidebar(cat_id);
              return false;
            }
          }
        }
      }
    },
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : 'categories',
      selected_parent_close: false
    },
    callback: {
      onload: function(TREE_OBJ){
        tree_id = jQuery(TREE_OBJ.container).attr('id');
        //display_notifications();
        jQuery(TREE_OBJ.container).removeClass('tree-default');
        jQuery(TREE_OBJ.container).find('a').each(function(index,selector){
          var category_id = get_rails_element_id(jQuery(selector).parent('li'));
          jQuery(selector).droppable({
            hoverClass: 'ui-state-hover',
            drop:function(ev, ui){
              jQuery.ajax({
              data: {element_id:get_rails_element_id(jQuery(ui.draggable)), authenticity_token: encodeURIComponent(window._forgeos_js_vars.token)},
              success:function(request){jQuery(ev.target).find('span').html(request);},
              type:'post',
              url:'/admin/categories/' + category_id + '/add_element'
              });
            }
          });
        });
      },
      oncreate: function(NODE,REF_NODE,TYPE,TREE_OBJ,RB){
        var parent_node = jQuery(NODE).parent().parent('li');
        var parent_id;
        // get parent_id if parent node exists
        if (parent_node[0] != undefined)
          parent_id = get_rails_element_id(parent_node);

        jQuery.ajax({
          url: '/admin/categories/create',
          complete: function(request){
            var cat_id = request.responseText

            jQuery(NODE).attr('id', 'cageory_' + cat_id);
            jQuery(NODE).children('a').attr('id', 'link_category_' + cat_id);
            set_category_droppable(cat_id, type);

            if( jQuery(".parent_id_hidden").size() == 0){
              jQuery(document.body).append('<input type="hidden" id="parent_id_tmp" name="parent_id_tmp" class="parent_id_hidden" value="'+cat_id+'" />');
            } else {
              jQuery('#parent_id_tmp').val(cat_id);
            }

          },
          data: get_category_data('New folder', type, parent_id),
          dataType: 'text',
          type: 'post'
        });
      },
      onrename: function(NODE,LANG,TREE_OBJ,RB){
        var cat_id = get_rails_element_id(NODE);
        jQuery.ajax({
            url: '/admin/categories/' + cat_id,
              // update elements count
              complete: function(request) {
                jQuery.tree.focused().refresh();
              },
              data: {authenticity_token:window._forgeos_js_vars.token, format: 'json', 'category[name]': jQuery(NODE).children('a').text()},
              dataType:'text',
              type:'put'
              });
      },
      onmove: function(NODE,LANG,TREE_OBJ,RB){
        var cat_id = get_rails_element_id(NODE);
        var parent_id = '';
        var parent_ul = jQuery(NODE).parents('ul:first');
        var position = jQuery(parent_ul).children('li').index(jQuery(NODE));
        var tree_id = jQuery(RB.container).attr('id');

        position = position+1;
        if (jQuery(NODE).parent().parent('li').length > 0){
          parent_id = get_rails_element_id(jQuery(NODE).parent().parent('li'));
        }
        jQuery.ajax({
          url: '/admin/categories/' + cat_id,
            // update elements count
            complete: function(request) {
              //jQuery.tree.focused().refresh();
            },
            data: {authenticity_token:window._forgeos_js_vars.token, format: 'json', 'categories_hash': get_current_categories( tree_id ) },
            dataType:'text',
            type:'put'
        });
      },
      ondelete: function(NODE,TREE_OBJ){
        var cat_id = get_rails_element_id(NODE);
        jQuery.ajax({
            url: '/admin/categories/' + cat_id,
              success: function(request){
                jQuery(NODE).attr('id', 'cageory_' + request.responseText);
              },
              data: {authenticity_token:window._forgeos_js_vars.token, format: 'json'},
              dataType:'text',
              type:'delete'
              });
      },
      oncopy: function(NODE,REF_NODE,TYPE,TREE_OBJ,RB) { duplicate_category(NODE, type); },
      onselect: function(NODE,TREE_OBJ) {
        jQuery(".parent_id_hidden").remove();
        var cat_id = get_rails_element_id(NODE);
        var table = jQuery('#table');
        if (table.length == 0){
          var table = jQuery('.table');
        }
        var current_table = table.dataTableInstance();
        var url = current_table.fnSettings().sAjaxSource;
        var url_base = url.split('?')[0];

        jQuery('#category_sort').show();
        // update category id
        var params = get_json_params_from_url(url);
        params.category_id = cat_id;
        params = stringify_params_from_json(params);

        // construct url and redraw table
        update_current_dataTable_source(table.attr('id'),url_base + '?' + params);

        object_name = jQuery(NODE).attr('id').split('_')[0];
        category_id = get_rails_element_id(NODE);
        if(jQuery(".parent_id_hidden").size() == 0){
          jQuery(document.body).append('<input type="hidden" id="parent_id_tmp" name="parent_id_tmp" class="parent_id_hidden" value="'+category_id+'" />');
        } else {
          jQuery('#parent_id_tmp').val(category_id);
        }
        return true;
      },
      ondeselect: function(NODE,TREE_OBJ) {
        jQuery('#category_sort').hide();
        return true;
      },
      // remove count span
      beforerename: function(NODE,LANG,TREE_OBJ) {
        jQuery(NODE).children('a').html(extract_category_name(NODE));
        jQuery(NODE).children('a').addClass('folder');
        return true;
      },
      // add class big-icons to new category
      beforecreate: function(NODE,REF_NODE,TYPE,TREE_OBJ) {
        jQuery(NODE).children('a').addClass('folder');
        jQuery(NODE).children('a').addClass('big-icons');
        return true
      }
    }
  });
}

//check if something is selected in jsTree
function check_jsTree_selected(element){
  if(jQuery.tree_reference(element).selected!=undefined){
    return true;
  }
  return false;
}

// unselect current node and refresh dataTables
function select_all_elements_by_url(url) {
  // change dataTables ajax source en redraw the table
  oTable.fnSettings().sAjaxSource = url;
  oTable.fnDraw();
}

// unselect current node, remove category and refresh dataTable
function select_all_elements_without_category(tree_id) {
  var t = jQuery.tree.focused();

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
function set_category_droppable(category_id, type) {
  jQuery('#link_category_' + category_id).droppable({
    hoverClass: 'ui-state-hover',
    drop: function(ev, ui){
      jQuery.ajax({
        data: { element_id:get_rails_element_id(jQuery(ui.draggable)),authenticity_token: encodeURIComponent(window._forgeos_js_vars.token)},
        success:function(request){jQuery('#span_category_' + category_id).html(request);},
        type:'post',
        url:'/admin/categories/' + category_id + '/add_element'
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

//Return current tree to json
function get_current_categories( tree_id ){
  return JSON.stringify(jQuery.tree.reference("#"+tree_id ).get());
}

function createNewLevel(parent,item, TREE_OBJ, level) {
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
        parent["category_"+cat_id] = {};
        createNewLevel(parent["category_"+cat_id],jQuery(this).children().children(), TREE_OBJ);
      }
      else{
        parent["category_"+cat_id] = cat_id;
      }
    }
  });
}

/*
 *call when ther's a problem with jsTree control
 *param : message
 **/
function error_on_jsTree_action(message){
}

// initialize tree for category associations
function init_association_category_tree(selector, object_name, category_name, theme){
  jQuery(selector).tree({
    ui: {
      theme_path: '/stylesheets/jstree/themes/',
      theme_name : theme,
      selected_parent_close: false
    },
    rules: { multiple:'on' },
    callback: {
      onload: function(TREE_OBJ){
        tree_id = jQuery(TREE_OBJ.container).attr('id');
        jQuery(TREE_OBJ.container).removeClass('tree-default');
      },
      onrgtclk: function(NODE,TREE_OBJ,EV){
        EV.preventDefault(); EV.stopPropagation(); return false;
      },
      onselect: function(NODE,TREE_OBJ){
        if (typeof(object_name) == 'undefined') {
          var oname = jQuery(NODE).attr('id').split('_')[0];
        } else {
          var oname = object_name;
        }
        var category_id = get_rails_element_id(NODE);
        jQuery(NODE).append('<input type="hidden" id="'+oname+'_'+category_name+'_ids_'+category_id+'" name="'+oname+'['+category_name+'_ids][]" value="'+category_id+'" />');
        jQuery(NODE).addClass('clicked');
      },
      ondeselect: function(NODE,TREE_OBJ){
        jQuery(NODE).children('input').remove();
        jQuery(NODE).removeClass('clicked');
      }
    }
  });
}
