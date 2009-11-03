jQuery(document).ready(function(){
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
      console.info($(this));
      $(this).find('.delete').val(1);
    });

    // hide menu link and its children
    $(menu_list).hide();
    return false;
  });
});
