jQuery(document).ready(function(){
  //add spans in current's page tab
  $('#menu .current').append('<span class="after-current"></span>');
  $('#menu .current').prepend('<span class="before-current"></span>');
});
