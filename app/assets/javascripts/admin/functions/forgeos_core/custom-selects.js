function change_rule(element, name){
  var selected = jQuery(element).val().replace(/\s+/g,"")
  //alert(selected)
  var condition = jQuery(element).parent().parent()
  condition.html('')
  condition.append(jQuery('.rule-'+selected+'.pattern').html())
  //condition.append(jQuery('.rule-'+selected+'.pattern').clone().removeClass('pattern'))
  //$(element).parent().replaceWith(jQuery('.rule-'+jQuery(element).val().replace(/\s+/g,"")+'.pattern').clone().removeClass('pattern').removeClass('rule-'+jQuery(element).val().replace(/\s+/g,"")).addClass('rule-condition'))
  //check_remove_icon_status(name);
  check_icons('rule-conditions');
  check_icons('end-conditions');
  InitCustomSelects();
  rezindex();
}

function rezindex(){
 var nb=990
 jQuery('.dropdown').each(function(){
   jQuery(this).css('zIndex',nb);
   nb--;
 });
}

function rebuild_custom_select(parent){
  // remove custom select classes
  jQuery(parent).removeClass('enhanced');
  jQuery(parent).children('.dropdown').remove();

  // reinit custom select and rebuild indexes
  InitCustomSelects();
  rezindex();
}
