jQuery(document).ready(function(){
  //add spans in current's page tab
  $('#menu .current').append('<span class="after-current"></span>');
  $('#menu .current').prepend('<span class="before-current"></span>');

  //remove borders arround submenu current item
  $('#submenu .current').next('li').addClass('next');
});
