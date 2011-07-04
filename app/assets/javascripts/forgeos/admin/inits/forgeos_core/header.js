jQuery(document).ready(function(){
  //add spans in current's page tab
  jQuery('#menu .current').append('<span class="after-current"></span>');
  jQuery('#menu .current').prepend('<span class="before-current"></span>');
});
