jQuery(document).ready(function(){
  //init search form
  $('.search-form').html($('#table_wrapper .dataTables_filter').clone(true));
  $('.search-form').append('<a href="#" class="backgrounds button-ok">OK</a>');
  $('.search-form .button-ok').data('parent','');

  if($('.search-form-image')){
    $('.search-form-image').html($('#image-table_wrapper .top .dataTables_filter').clone(true));
    $('.search-form-image').append('<a href="#" class="backgrounds button-ok">OK</a>');
    $('.search-form-image .button-ok').data('parent','image');
  }

  if($('.search-form-thumbnails')){
    $('.search-form-thumbnails').html($('#thumbnail-table_wrapper .top .dataSlides_filter').clone(true));
    $('.search-form-thumbnails').append('<a href="#" class="backgrounds button-ok">OK</a>');
    $('.search-form-thumbnails .button-ok').data('parent','thumbnails');
  }

  if($('.search-form-files')){
    $('.search-form-files').html($('#table-files_wrapper .top .dataTables_filter').clone(true));
    $('.search-form-files').append('<a href="#" class="backgrounds button-ok">OK</a>');
    $('.search-form-files .button-ok').data('parent','files');
  }

  $('.top .dataSlides_filter').remove();
  $('.top .dataTables_filter').remove();

  $('.search-link').live('click',toggle_search_elements);
  $('.button-ok').live('click',toggle_search_elements_ok);
})
