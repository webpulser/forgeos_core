jQuery(document).ready(function(){
  /*
   *Add click function on .gray-destroy items
   *Those items are links to remove their parents (i.e. blocks)
   **/
  $('.gray-destroy').live('click', function(){
    $(this).parent().remove();
    return false;
  });
  $('a.destroy').live('click', function(e){
    e.preventDefault();
    line = $($(this).parent());
    var del = line.find('input.destroy');
    if (del.length > 0) {
      del.val(1);
      line.hide('highlight',{speed: 3000});
    } else {
      line.hide('highlight',{speed: 3000},function(){ $(this).remove(); });
    }
    return false;
  });
})
