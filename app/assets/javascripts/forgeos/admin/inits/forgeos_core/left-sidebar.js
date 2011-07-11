jQuery(document).ready(function(){
  //init the resizable sidebar
  jQuery("#content.grid_12").resizable({
    handles:'w',
    maxWidth: 790,
    minWidth: 640
  });
  jQuery("#sidebar").resizable({
    handles:'e',
    maxWidth: 300,
    minWidth: 150
  });

  jQuery("#sidebar").resize( function() {
    //when resize sidebar have to resize content
    jQuery("#content").width(jQuery("#page").width()-(jQuery(this).width()+1));
  });

  jQuery("#content").resize( function() {
    jQuery(this).css({ left: '0px' });
    jQuery("#sidebar").width(jQuery("#page").width()-(jQuery(this).width()+1));
  });

  /*
   *Add click function on .create-action items
   *Those items are links that show jstree control panel (creation)
   **/
  jQuery('.create-action').bind('click',function(){
    if(!jQuery('.create-list').hasClass('displayed')){
      jQuery('.update-list').removeClass('displayed');
      jQuery('.create-list').addClass('displayed');
      jQuery('.update-list').find('.shadow').hide();
      jQuery(this).find('.shadow').show();
    }
    else{
      jQuery('.create-list').removeClass('displayed');
      jQuery(this).find('.shadow').hide();
    }
  });

  /*
   *Add click function on .update-action items
   *Those items are links that show jstree control panel (update)
   **/
  jQuery('.update-action').live('click',function(){
   if(!jQuery('.update-list').hasClass('displayed')){
      jQuery('.create-list').removeClass('displayed');
      jQuery('.update-list').addClass('displayed');
      jQuery('.create-list').find('.shadow').hide();
      jQuery(this).find('.shadow').show();
    }
    else{
      jQuery('.update-list').removeClass('displayed');
      jQuery(this).find('.shadow').hide();
    }
  });

  /*
   *Add click function on .widget-action items
   *Those items are links that show jstree control panel (widget)
   **/
  jQuery('.widget-action').live('click',function(){
   if(!jQuery('.widget-types').hasClass('displayed')){
      jQuery('.create-list').removeClass('displayed');
      jQuery('.widget-types').addClass('displayed');
    }
    else{
      jQuery('.widget-types').removeClass('displayed');
    }
  });

  jQuery('.select_choice').live('click',function(){
   if(!jQuery(this).find('.choices_list').hasClass('displayed')){
      jQuery('.choices_list').removeClass('displayed');
      jQuery(this).find('.choices_list').addClass('displayed');
    }
    else{
      jQuery(this).find('.choices_list').removeClass('displayed');
    }
  });

  /*
   *Add click function on .create-action childrens items
   *Those items are links that create categories in jstree
   *param : tree_id => id of current-tree line 104
   **/
  jQuery('.create-folder, .create-smart').live('click',function(){
    var tree_id = jQuery('.category-tree').attr('id');
    var t = jQuery.jstree._reference(tree_id);
    if(t.get_selected()){
      t.create(t.get_selected(),0);
    } else {
      t.create(null,0);
    }
  });

  /*
   *Add click function on .update-action  items
   *Those items are links that rename categories in jstree
   *param : tree_id => id of current-tree  line 104
   **/
  jQuery('.modify-folder').live('click',function(){
    var t = jQuery.jstree._focused();
    if(t.get_selected()){
       t.rename(t.get_selected());
    } else {
       error_on_jsTree_action("please select a category first");
    }
  });

  /*
   *Add click function on .delete-action  items
   *Those items are links that destroy categories in jstree
   *param : tree_id => id of current-tree line 104
   **/
  jQuery('.delete-folder').live('click',function(){
    var t = jQuery.jstree._focused();
    if(t.get_selected()){
       t.remove(t.get_selected());
    } else {
       error_on_jsTree_action("please select a category first");
    }
  });

  /*
   *Add click function on .duplicate-action  items
   *Those items are links that duplicate categories in jstree
   *param : tree_id => id of current-tree line 104
   **/
   jQuery('.duplicate-folder').live('click',function(){
    var t = jQuery.jstree._focused();
    if(t.get_selected()){
      t.copy();
      t.paste(-1);
    } else {
       error_on_jsTree_action("please select a category first");
    }
  });
});
