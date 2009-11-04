jQuery(document).ready(function(){

  // Add root menu link
  $('.button-menu-link').live('click',function(){
    var menu = $('#menu-tree').children('ul');
    var new_menu_list = '<li class="file last closed">';
    new_menu_list += $('#empty_menu_link').html().replace(/EMPTY_ID/g, false_id);
    new_menu_list += '</li>';

    $(menu).append(new_menu_list);
    false_id--;
    return false;
  });

  // Add menu link
  $('.tree-menu-tree li .menu_link .action-links .add-green-plus').live('click',function(){
    // reference
    var menu_list = $(this).parents('li:first');
    var menuContainer = $(this).parents('.menu_link');

    console.info('hu');
    console.info($(this));

    // new link
    var new_menu_list = $('<li class="file last closed">').append(jquery_obj_to_str(menuContainer));
    var new_menuContainer = $(new_menu_list).find('.menu_link');
   
    var menuLinks = $(new_menuContainer).children('.tree-link');
    var edition_block = $(menuLinks).filter('.editing');
    var link = $(menuLinks).filter('a');
    
    $(menu_list).parent().append(new_menu_list);

    // set attributes
    $(edition_block).find('input, textarea, select').each(function(){
      var id = $(this).attr('id');
      var name = $(this).attr('name');

      var attributes = name.split('[');
      var attribute = attributes[attributes.length-1].replace(']','');

      // replace rails_id in id and name html attributes
      if (id != ""){      
        var previous_id = attributes[attributes.length-2].replace(']','');
        var re = new RegExp('^(.*)'+previous_id+'(.*?)$');

        $(this).attr('id', id.replace(re, '$1'+false_id+'$2'));
        $(this).attr('name', name.replace(re, '$1'+false_id+'$2'));
      }

      // reset attributes values
      switch(attribute)
        {
        // FIXME: link_to, interactivity
        case 'title':
          $(this).val('');
          link.find('.name').html('');
          break;

        case 'url':
          $(this).val('');
          link.attr('href', '');
          break;

        case 'active':
          status_span = link.find('.status');
          // update select
          $(this).val(1);
          rebuild_custom_select('.select-status');

          // set visible
          if (status_span.hasClass('see-off')){
            status_span.removeClass('see-off');
            status_span.addClass('see-on');
          }
          break;

        case 'id':
          $(this).remove();
          break;
         
        case 'kind':
          $(this).val('ExternalLink');
          break;

        case 'delete', 'target_id', 'target_type', 'position':
          $(this).val('');
          break;
        }
    });

    // set classes of spans to external
    var linked_to_span = $(edition_block).find('.linked-to-span');
    $(linked_to_span).removeClass();
    $(linked_to_span).addClass('small-icons external linked-to-span');
    $(linked_to_span).html('');

    var name_span = $(menuLinks).find('.name');
    $(name_span).removeClass();
    $(name_span).addClass('small-icons external name');
    $(name_span).html('');

    // set edition block visible
    menuLinks.toggle();
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
    var menu_list = $(this).parents('li:first');

    // set the menu link and all its children to deleted
    $(menu_list).find('.menu_link').each(function(){
      $(this).find('.delete').val(1);
    });

    // hide menu link and its children
    $(menu_list).hide();
    return false;
  });
});
