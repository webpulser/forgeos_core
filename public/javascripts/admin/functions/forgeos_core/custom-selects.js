function change_rule(element, name){
  var selected = $(element).val().replace(/\s+/g,"")
  //alert(selected)
  var condition = $(element).parent().parent()
  condition.html('')
  condition.append($('.rule-'+selected+'.pattern').html())
  //condition.append($('.rule-'+selected+'.pattern').clone().removeClass('pattern'))
  //$(element).parent().replaceWith($('.rule-'+$(element).val().replace(/\s+/g,"")+'.pattern').clone().removeClass('pattern').removeClass('rule-'+$(element).val().replace(/\s+/g,"")).addClass('rule-condition'))
  //check_remove_icon_status(name);
  check_icons('rule-conditions');
  check_icons('end-conditions');
  rezindex();
}

function rezindex(){
 var nb=990
 $('.dropdown').each(function(){
   $(this).css('zIndex',nb);
   nb--;
 });
}
