jQuery(document).ready(function(){
  /*
   *Add click function on .gray-destroy items
   *Those items are links to remove their parents (i.e. blocks)
   **/
  jQuery('.gray-destroy').live('click', function(){
    jQuery(this).parent().remove();
    return false;
  });
  jQuery('a.destroy').live('click', function(e){
    e.preventDefault();
    line = jQuery(jQuery(this).parent());
    var del = line.find('input.destroy');
    if (del.length > 0) {
      del.val(1);
      line.hide('highlight',{speed: 3000});
    } else {
      line.hide('highlight',{speed: 3000},function(){ jQuery(this).remove(); });
    }
    return false;
  });
})
