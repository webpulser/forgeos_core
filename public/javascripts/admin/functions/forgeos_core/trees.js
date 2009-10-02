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
function init_tree(selector,type, url, source) {
  $(selector).tree({
    data:{
      type: 'json',
      url: source,
      async: false
    },
    ui: { theme_path: '/stylesheets/jstree/themes/', theme_name : 'product_category' },
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
              success:function(request){TREE_OBJ.refresh();},
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
                TREE_OBJ.refresh();
              },
              data: {authenticity_token:AUTH_TOKEN, format: 'json', 'category[name]': $(NODE).children('a').text()},
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
        oTable.fnSettings().sAjaxSource = url + '?category_id=' + cat_id;
        oTable.fnDraw();
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
function select_all_elements(url) {
  // unselect current selected node
  var tree_id = $('.init-tree').attr('id');
  if (tree_id != null) {
    var tree = $.tree_reference(tree_id);
    tree.deselect_branch(tree.selected);
    $.tree_reference(tree_id).selected = null;
  }
  // change dataTables ajax source en redraw the table
  oTable.fnSettings().sAjaxSource = url;
  oTable.fnDraw();
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