/*
 *Show/Hide search form
 **/
function toggle_search_elements(){
  //Get back the parent's clicked element
  var parent = $(this).parents('#search');
  //get its classes
  var classe = parent.attr('class');
  var classes = new Array();
  classes = classe.split(' ');
  //get the second class (first is right, and third is open or nothing =>useless for references
  classe= classes[1];
  //Add the open class to the parent
  $(parent).toggleClass('open');
  if(classe!='' && classe!=undefined && classe!='open'){
    $('.search-form-'+classe).toggle();
  }
  else{
    $('.search-form').toggle();
  }
  return false;
}

function toggle_search_elements_ok(){
  var parent = $(this).data('parent');
  if(parent!='' && classe!=undefined && classe!='open'){
    $('#search.'+parent).toggleClass('open');
    $('.search-form-'+parent).toggle();
  }
  else{
    $('#search').toggleClass('open');
    $('.search-form').toggle();
  }
  return false;
}