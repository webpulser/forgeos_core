/*
 *Show/Hide search form
 **/
function toggle_search_elements(){
  //Get back the parent's clicked element
  var parent = jQuery(this).parents('#search');
  //get its classes
  var classe = parent.attr('class');
  var classes = new Array();
  classes = classe.split(' ');
  //get the second class (first is right, and third is open or nothing =>useless for references
  classe= classes[1];
  //Add the open class to the parent
  jQuery(parent).toggleClass('open');
  if(classe!='' && classe!=undefined && classe!='open'){
    jQuery('.search-form-'+classe).toggle();
  }
  else{
    jQuery('.search-form').toggle();
  }
  return false;
}

function toggle_search_elements_ok(){
  var parent = jQuery(this).data('parent');
  if(parent!=''){
    jQuery('#search.'+parent).toggleClass('open');
    jQuery('.search-form-'+parent).toggle();
  }
  else{
    jQuery('#search').toggleClass('open');
    jQuery('.search-form').toggle();
  }
  return false;
}