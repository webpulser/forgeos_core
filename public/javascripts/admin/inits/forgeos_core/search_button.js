jQuery(document).ready(function(){
  //init search form
  jQuery('.search-form').html(jQuery('#table_wrapper .dataTables_filter').clone(true));
  jQuery('.search-form').append('<a href="#" class="backgrounds button-ok">OK</a>');
  jQuery('.search-form .button-ok').data('parent','');

  if(jQuery('.search-form-image')){
    jQuery('.search-form-image').html(jQuery('#image-table_wrapper .top .dataTables_filter').clone(true));
    jQuery('.search-form-image').append('<a href="#" class="backgrounds button-ok">OK</a>');
    jQuery('.search-form-image .button-ok').data('parent','image');
  }

  if(jQuery('.search-form-thumbnails')){
    jQuery('.search-form-thumbnails').html(jQuery('#thumbnail-table_wrapper .top .dataSlides_filter').clone(true));
    jQuery('.search-form-thumbnails').append('<a href="#" class="backgrounds button-ok">OK</a>');
    jQuery('.search-form-thumbnails .button-ok').data('parent','thumbnails');
  }

  if(jQuery('.search-form-files')){
    jQuery('.search-form-files').html(jQuery('#table-files_wrapper .top .dataTables_filter').clone(true));
    jQuery('.search-form-files').append('<a href="#" class="backgrounds button-ok">OK</a>');
    jQuery('.search-form-files .button-ok').data('parent','files');
  }

  jQuery('.top .dataSlides_filter').remove();
  jQuery('.top .dataTables_filter').remove();

  jQuery('.search-link').live('click',toggle_search_elements);
  jQuery('.button-ok').live('click',toggle_search_elements_ok);
})
