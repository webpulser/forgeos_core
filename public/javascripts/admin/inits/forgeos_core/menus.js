jQuery(document).ready(function(){

  // Dialog to change menu link type
  $('#menuLinkTypeDialog').dialog({
    autoOpen:false,
    modal:true,
    minHeight: 380,
    width: 800,
    resizable:'se',
    buttons: {
      Ok: function(){
        $('#fileSelectDialog').dialog('close');
      }
    },
    open: function(){ 
      $('#table-files').dataTableInstance().fnDraw(); 
    }
  });

  // Add root menu link
  $('.button-menu-link').live('click',function(){
    var menu = $('#menu-tree').children('ul');
    var new_menu_link = '<li class="file last closed">';
    new_menu_link += $('#empty_menu_link').html().replace(/EMPTY_ID/g, false_id).replace(/EMPTY_NAME/g, false_id);
    new_menu_link += '</li>';

    $(menu).append(new_menu_link);
    false_id--;
    return false;
  });

  // Add sub menu link
  $('.tree-menu-tree li .menu_link .action-links .add-green-plus').live('click',function(){
    var current_menu_link = $(this).parents('li:first');
   
    // get list of the current menu_link or create one
    var menu_list = $(current_menu_link).children('ul');
    if (menu_list.length == 0) {
      $(current_menu_link).append($('<ul>'));
      menu_list = $(current_menu_link).children('ul');
    }

    // get menu_link ancestors
    var ancestor_ids = [];
    $(this).parents('li').each(function(){
        var attributes = $(this).find('input:first').attr('name').split('[');
        var ancestor_id = attributes[attributes.length-2].replace(']','');
        ancestor_ids.push(ancestor_id);
    });

    // constructs new menu_link id/name depending on its ancestors
    var new_id = false_id;
    var new_name = false_id;
    if (ancestor_ids.length > 0){
      ancestor_ids = ancestor_ids.reverse();
      new_id = ancestor_ids.join('_children_attributes_') + '_children_attributes_' + false_id;
      new_name = ancestor_ids.join('][children_attributes][') + '][children_attributes][' + false_id;
    }

    // create new menu link and append it to the list of the current menu_link
    var new_menu_link = '<li class="file last closed">';
    new_menu_link += $('#empty_menu_link').html().replace(/EMPTY_ID/g, new_id).replace(/EMPTY_NAME/g, new_name);
    new_menu_link += '</li>';
    $(menu_list).append(new_menu_link);

    // TODO: refactor with remove menu link
    // open current menu_link if closed
    if (current_menu_link.hasClass('closed')){
      current_menu_link.removeClass('closed');
      current_menu_link.addClass('open');
    }
    if (current_menu_link.hasClass('file')){
      current_menu_link.removeClass('file');
      current_menu_link.addClass('folder');
    }

    false_id--;
    return false;
  });

  // Edition mode in menu link edit
  $('.tree-menu-tree li .menu_link .action-links .edit-link, .tree-menu-tree li .menu_link .actions .back-link').live('click',function(){
    var menuContainer = $(this).parents('.menu_link');
    var menuLinks = menuContainer.children('.tree-link');

    var edition_block = $(menuLinks).filter('.editing');
    var link = $(menuLinks).filter('a');

    menuLinks.toggle();

    // on closing edition part
    if (!$(edition_block).is(':visible')){
      var back_link = $(this).hasClass('back-link');

      // back-link is pressed then reset attributes else update attributes
      $(edition_block).find('input, textarea, select').each(function(){
        switch(get_rails_element_id($(this)))
          {
          // FIXME: link_to, interactivity
          case 'title':
            if (back_link)
              $(this).val(link.find('.name').html());
            else
              link.find('.name').html($(this).val());
            break;

          case 'url':
            if (back_link)
              $(this).val(link.attr('href'));
            else
              link.attr('href', $(this).val());
            break;

          case 'active':
            status_span = link.find('.status');
            if (back_link){
              // update select
              $(this).val(status_span.hasClass('see-on') ? 1 : 0);
              rebuild_custom_select('.select-status');
            }
            else {
              // set visible or not
              status_span.removeClass(($(this).val() == '1') ?  'see-off' : 'see-on');
              status_span.addClass(($(this).val() == '1') ?  'see-on' : 'see-off');
            }
            break;  
          }
      });
    }
    return false;
  });

  // Remove menu link
  $('.tree-menu-tree li .menu_link .action-links .destroy-link').live('click',function(){
    var menu_link = $(this).parents('li:first');

    // set the menu link and all its children to deleted
    $(menu_link).find('.menu_link').each(function(){
      $(this).find('.delete').val(1);
    });

    // hide menu link and its children
    $(menu_link).hide();

    // close parent menu_link if there was only one sub menu_link
    var parent_menu_link = menu_link.parents('li:first');
    var sub_menu_links = parent_menu_link.find('li.open:visible, li.closed:visible');

    // TODO: refactor with add sub menu link
    if (sub_menu_links.length == 0){
      if (parent_menu_link.hasClass('open')){
        parent_menu_link.removeClass('open');
        parent_menu_link.addClass('closed');
      }
      if (parent_menu_link.hasClass('folder')){
        parent_menu_link.removeClass('folder');
        parent_menu_link.addClass('file');
      }
    }
    return false;
  });

  // Change menu link type
  $('.tree-menu-tree li .menu_link .editing .change-type').live('click',function(){
    var edition_block = $(this).parents('.editing');
    var link_type = $(edition_block).find('.input-type').val();

    switch(link_type)
      {
      case 'ExternalLink':
        // update url input text field
        var url = $(edition_block).find('.input-url');
        var overlay_url = $('#overlay-url');
        overlay_url.val(url.val());

        $('#menuLinkTypeDialog').dialog('option', 'buttons', {
          "Ok": function(){         
            var link = $(edition_block).find('.linked-to-span a');

            link.html(overlay_url.val());
            link.attr('href', overlay_url.val());
            url.val(overlay_url.val());

            $(this).dialog("close"); 
          } 
        });
        break;

      case 'PageLink':
        // TODO
        break;

      case 'ProductLink':
        // TODO
        break;

      case 'CategoryLink':
        // TODO
        break;
      }

    $('#menuLinkTypeDialog').dialog('open');      
    return false;
  });
});
