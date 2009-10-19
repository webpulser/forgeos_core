jQuery(document).ready(function(){
  /*
   *Add click function on .gray-destroy items
   *Those items are links to remove their parents (i.e. blocks)
   **/
  $('.gray-destroy').live('click', function(){
    $(this).parent().remove();
    return false;
  });
})
