jQuery(document).ready(function(){
  //when click on selects, resize the otions container to stretch with the select's size
  $('.dropdown').bind('click', function()
  {
    var divOption=$(this).find('.options');
    divOption.width($(this).width()-15);
  });
});