jQuery(document).ready(function(){
  //when click on selects, resize the otions container to stretch with the select's size
  InitCustomSelects();
  jQuery('.dropdown').bind('click', function() {
    var divOption=jQuery(this).find('.options');
    divOption.width(jQuery(this).width()-15);
  });
});
