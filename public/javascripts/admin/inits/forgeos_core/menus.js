jQuery(document).ready(function(){
  // Edition mode in menu link edit
  $('.tree-menu-tree li .menu_link .action-links .edit-link, .tree-menu-tree li .menu_link .actions .back-link').live('click',function(){
    var menuContainer = $(this).parents('.menu_link');
    var menuLinks = menuContainer.children('.tree-link');

    menuLinks.toggle();
    return false;
  });
});
