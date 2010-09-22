function duplicate_category(node, type, parent_id){
  var name = extract_category_name(node)
  var children = $(node).children('ul').children('li');
  var parent_node = $(node).parent().parent('li');

  // get parent_id from parent_node
  if ((parent_id == undefined) && (parent_node[0] != undefined))
    parent_id = get_rails_element_id(parent_node);

  $.ajax({
      url: '/admin/categories/create',
        // update node id and duplicate node children
        complete: function(request){
          var cat_id = request.responseText;
          $(node).attr('id', 'cageory_' + cat_id);
          children.each(function(){ duplicate_category($(this), type, cat_id); });

          $(node).children('a').attr('id', 'link_category_' + cat_id);
          $(node).children('a').children('span').attr('id', 'span_category_' + cat_id);

          set_category_droppable(cat_id, type);
        },
        data: get_category_data(name, type, parent_id),
        dataType: 'text',
        type: 'post'
        });
}

// return category data with or without parent category
function get_category_data(name, type, parent_id) {
  if (parent_id)
    return {authenticity_token:AUTH_TOKEN, format: 'json', 'category[name]': name, 'category[kind]': type, 'category[parent_id]': parent_id};
  else
    return {authenticity_token:AUTH_TOKEN, format: 'json', 'category[name]': name, 'category[kind]': type};
}

// initialise tree theme and callbacks
function init_category_tree(selector, type, source) {
  $(selector).tree({
    data:{
      type: 'json',
      opts: {
        url: source
      }
    },
    plugins: {
      'cookie': {},
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
              $.each(NODE, function () {
                if(TREE_OBJ.check("deletable", this) == false) {
                  ok = false;
                  return false;
                }
              });
              return ok;
            },
            action  : function (NODE, TREE_OBJ) {
              $.each(NODE, function () {
                TREE_OBJ.remove(this);
              });
            }
          },
          add_image : {
            label : "Add image",
            icon  : "image",
            visible : function (NODE, TREE_OBJ) {
              var ok = true;
              $.each(NODE, function () {
                if(TREE_OBJ.check("deletable", this) == false) {
                  ok = false;
                  return false;
                }
              });
              return ok;
            },
            action  : function (NODE, TREE_OBJ) {
              var cat_id = get_rails_element_id(NODE);
              $('.tree-li-selected-to-add-image').each(function(){
                $(this).removeClass('tree-li-selected-to-add-image');
              });
              $(NODE).addClass("tree-li-selected-to-add-image");

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
        tree_id = $(TREE_OBJ.container).attr('id');
        display_notifications();
        $(TREE_OBJ.container).removeClass('tree-default');
        $(TREE_OBJ.container).find('a').each(function(index,selector){
          var category_id = get_rails_element_id($(selector).parent('li'));
          $(selector).droppable({
            hoverClass: 'ui-state-hover',
            drop:function(ev, ui){
              $.ajax({
              data: {element_id:get_rails_element_id($(ui.draggable)), authenticity_token: encodeURIComponent(AUTH_TOKEN)},
              success:function(request){$.tree.focused().refresh();},
              type:'post',
              url:'/admin/categories/' + category_id + '/add_element'
              });
            }
          });
        });
      },
      oncreate: function(NODE,REF_NODE,TYPE,TREE_OBJ,RB){
        var parent_node = $(NODE).parent().parent('li');
        var parent_id;
        // get parent_id if parent node exists
        if (parent_node[0] != undefined)
          parent_id = get_rails_element_id(parent_node);

        $.ajax({
            url: '/admin/categories/create',
              complete: function(request){
                var cat_id = request.responseText

                $(NODE).attr('id', 'cageory_' + cat_id);
                $(NODE).children('a').attr('id', 'link_category_' + cat_id);
                set_category_droppable(cat_id, type);
              },
              data: get_category_data('New folder', type, parent_id),
              dataType: 'text',
              type: 'post'
              });
      },
      onrename: function(NODE,LANG,TREE_OBJ,RB){
        var cat_id = get_rails_element_id(NODE);
        $.ajax({
            url: '/admin/categories/' + cat_id,
              // update elements count
              complete: function(request) {
                $.tree.focused().refresh();
              },
              data: {authenticity_token:AUTH_TOKEN, format: 'json', 'category[name]': $(NODE).children('a').text()},
              dataType:'text',
              type:'put'
              });
      },
      onmove: function(NODE,LANG,TREE_OBJ,RB){
        var cat_id = get_rails_element_id(NODE);
        var parent_id = '';
        if ($(NODE).parent().parent('li').length > 0){
          parent_id = get_rails_element_id($(NODE).parent().parent('li'));
        }
        $.ajax({
            url: '/admin/categories/' + cat_id,
              // update elements count
              complete: function(request) {
                $.tree.focused().refresh();
              },
              data: {authenticity_token:AUTH_TOKEN, format: 'json', 'category[parent_id]': parent_id},
              dataType:'text',
              type:'put'
              });
      },
      ondelete: function(NODE,TREE_OBJ){
        var cat_id = get_rails_element_id(NODE);
        $.ajax({
            url: '/admin/categories/' + cat_id,
              success: function(request){
                $(NODE).attr('id', 'cageory_' + request.responseText);
              },
              data: {authenticity_token:AUTH_TOKEN, format: 'json'},
              dataType:'text',
              type:'delete'
              });
      },
      oncopy: function(NODE,REF_NODE,TYPE,TREE_OBJ,RB) { duplicate_category(NODE, type); },
      onselect: function(NODE,TREE_OBJ) {
        var cat_id = get_rails_element_id(NODE);
        var current_table = $('#table').dataTableInstance();
        var url = current_table.fnSettings().sAjaxSource;
        var url_base = url.split('?')[0];
        var params;


        // update category id
        params = get_json_params_from_url(url);
        params.category_id = cat_id;
        params = stringify_params_from_json(params);

        // construct url and redraw table
        update_current_dataTable_source('#table',url_base + '?' + params);

        object_name = $(NODE).attr('id').split('_')[0];
        category_id = get_rails_element_id(NODE);
        if ($("#parent_id_tmp").length == 0) {
          $(NODE).append('<input type="hidden" id="parent_id_tmp" name="parent_id_tmp" value="'+category_id+'" />');
        } else {
          $("#parent_id_tmp").val(category_id);
        }
        return true;
      },
      ondeselect: function(NODE,TREE_OBJ) {
        $("#parent_id_tmp").remove();
        return true;
      },
      // remove count span
      beforerename: function(NODE,LANG,TREE_OBJ) {
        $(NODE).children('a').html(extract_category_name(NODE));
        $(NODE).children('a').addClass('folder');
        return true;
      },
      // add class big-icons to new category
      beforecreate: function(NODE,REF_NODE,TYPE,TREE_OBJ) {
        $(NODE).children('a').addClass('folder');
        $(NODE).children('a').addClass('big-icons');
        return true
      }
    }
  });
}

//check if something is selected in jsTree
function check_jsTree_selected(element){
  if($.tree_reference(element).selected!=undefined){
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
  var t = $.tree.focused();

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
  return true;
}

function update_parent_categories_count(element) {
  element.parents('li').each(function(){
    span = $(this).children('a').children('span');
    span.html(parseInt(span.text()) + 1);
  });
}

// return category name by extracting text from node link and by removing inner span
function extract_category_name(node) {
  var link = $(node).children('a');
  return link.text().replace(link.children('span').text(), '');
}

// on drop, the dropped element is added to the selected category
function set_category_droppable(category_id, type) {
  $('#link_category_' + category_id).droppable({
    hoverClass: 'ui-state-hover',
    drop: function(ev, ui){
      $.ajax({
        data: { element_id:get_rails_element_id($(ui.draggable)),authenticity_token: encodeURIComponent(AUTH_TOKEN)},
        success:function(request){$('#span_category_' + category_id).html(request);},
        type:'post',
        url:'/admin/categories/' + category_id + '/add_element'
      })
    }
  });
}

function removeClasses(){
  var elementsWithClassName=$('.lightbox-container').find('.clicked, .active');
  elementsWithClassName.removeClass('clicked active');
}

function addBlockClasses(){
  $('.block-selected').each(function(){
    var block_id = $(this).val();
    $('.blocks-tree').find('.block').each(function(){
      if($(this).parent().attr('id').substr(6) == block_id){
        $(this).addClass('active');
      }
    });
  });
}

function addPageClasses(block_id){
  $('#links_block_' + block_id).find('.block-selected').each(function(){
    var page_id = $(this).attr('id').split('_')[3];
    $('.pages-tree').find('.page').each(function(){
      if($(this).parent().attr('id').substr(5) == page_id){
        $(this).addClass('active');
      }
    });
  });
}

/*
 *call when ther's a problem with jsTree control
 *param : message
 **/
function error_on_jsTree_action(message){
}
