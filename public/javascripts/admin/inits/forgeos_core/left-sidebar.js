jQuery(document).ready(function(){
  //init the resizable sidebar
  $("#sidebar").resizable({
    handles:'e',
    containment: '#page',
    maxWidth: 300,
    minWidth: 150
  });
  $("#sidebar").resize( function() {
    //when resize sidebar have to resize content
    $("#content").width($("#page").width()-($("#sidebar").width()+1));
  });


  /*
   *Add click function on .create-action items
   *Those items are links that show jstree control panel (creation)
   **/
  $('.create-action').bind('click',function(){
    if(!$('.create-list').hasClass('displayed')){
      $('.update-list').removeClass('displayed');
      $('.create-list').addClass('displayed');
    }
    else{
      $('.create-list').removeClass('displayed');
    }
  });

  /*
   *Add click function on .update-action items
   *Those items are links that show jstree control panel (update)
   **/
  $('.update-action').live('click',function(){
   if(!$('.update-list').hasClass('displayed')){
      $('.create-list').removeClass('displayed');
      $('.update-list').addClass('displayed');
    }
    else{
      $('.update-list').removeClass('displayed');
    }
  });

  /*
   *Add click function on .widget-action items
   *Those items are links that show jstree control panel (widget)
   **/
  $('.widget-action').live('click',function(){
   if(!$('.widget-types').hasClass('displayed')){
      $('.create-list').removeClass('displayed');
      $('.widget-types').addClass('displayed');
    }
    else{
      $('.widget-types').removeClass('displayed');
    }
  });

  $('.select_choice').live('click',function(){
   if(!$(this).find('.choices_list').hasClass('displayed')){
      $('.choices_list').removeClass('displayed');
      $(this).find('.choices_list').addClass('displayed');
    }
    else{
      $(this).find('.choices_list').removeClass('displayed');
    }
  });

  /*
   *Add click function on .create-action childrens items
   *Those items are links that create categories in jstree
   *param : tree_id => id of current-tree line 104
   **/
  $('.create-folder, .create-smart').live('click',function(){
    var tree_id = $('.category-tree').attr('id');
    var t = $.tree.reference(tree_id);
    if(t.selected){
      t.create();
    }
    else{
      t.create({},-1)
    }
  });

  /*
   *Add click function on .update-action  items
   *Those items are links that rename categories in jstree
   *param : tree_id => id of current-tree  line 104
   **/
  $('.modify-folder').live('click',function(){
    var t = $.tree.focused();
    if(t.selected){
       t.rename()
    }
    else{
       error_on_jsTree_action("please select a category first");
    }
  });

  /*
   *Add click function on .delete-action  items
   *Those items are links that destroy categories in jstree
   *param : tree_id => id of current-tree line 104
   **/
  $('.delete-folder').live('click',function(){
    var t = $.tree.focused();
    if(t.selected){
       t.remove();
    }
    else{
       error_on_jsTree_action("please select a category first");
    }
  });

  /*
   *Add click function on .duplicate-action  items
   *Those items are links that duplicate categories in jstree
   *param : tree_id => id of current-tree line 104
   **/
   $('.duplicate-folder').live('click',function(){
    var t = $.tree.focused();
    if(t.selected){
      t.copy();
      t.paste(-1);

    }
    else{
       error_on_jsTree_action("please select a category first");
    }
  });
});