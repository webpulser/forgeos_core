jQuery(document).ready(function(){
  //init dialog Box
  jQuery('.lightbox-container').dialog({
    "autoOpen": false,
    "modal": true,
    "minHeight": 380,
    "width": 500,
    "resizable":'se'
  });

  setup_upload_dialog('#imageUpload');
  setup_upload_dialog('#attachmentUpload');
  setup_upload_dialog('#fileUpload');

  setup_select_dialog('#imageSelect', '#image-table:visible,#thumbnail-table:visible');
  setup_select_dialog('#fileSelect', '#table-files');

  jQuery('.display-thumbnails').click(function(e) {
    e.preventDefault();
    if(jQuery(this).hasClass('off')){
      jQuery(this).toggleClass('off');
      jQuery('.display-list').toggleClass('off');
      jQuery('.media-hoverlay-content').toggleClass('hidden');
      var search_element = jQuery('#search.image');
      search_element.removeClass('image');
      search_element.addClass('thumbnails');
      eval(jQuery('#image-table:visible,#thumbnail-table:visible').data('dataTables_init_function')+'()');
    }
    return false;
  });

  jQuery('.display-list').click(function(e) {
    e.preventDefault();
    if(jQuery(this).hasClass('off')){
      jQuery(this).toggleClass('off');
      jQuery('.display-thumbnails').toggleClass('off');
      jQuery('.media-hoverlay-content').toggleClass('hidden');
      var search_element = jQuery('#search.thumbnails');
      search_element.removeClass('thumbnails');
      search_element.addClass('image');
      eval(jQuery('#image-table:visible,#thumbnail-table:visible').data('dataTables_init_function')+'()');
    }
    return false;
  });

  /*
   *Add click function on .add-image items
   *Those items are links that show dialog Box to uploads media
   **/
  jQuery('.add-image').live('click',function(e){
    e.preventDefault();
    jQuery('.add-image, .add-file').removeClass('current');
    jQuery(this).addClass('current');
    openimageUploadDialog();
    return false;
  });

  jQuery('.add-file').live('click',function(e){
    e.preventDefault();
    jQuery('.add-image, .add-file').removeClass('current');
    jQuery(this).addClass('current');
    openfileUploadDialog();
    return false;
  });

  /*
  *Add click function on .fieldset a.backgrounds  items
  *Those items are links that shows dialogBox to add some blocks/widgets
  **/
  jQuery('#add-block, #add-widget').live('click',function(e){
    e.preventDefault();
    openBlockDialog(jQuery(this), jQuery(this).parent());
    return false;
  });

  jQuery('#add-attachment').live('click',function(e){
    e.preventDefault();
    initAttachmentUpload($(this).data('file_type'));
    return false;
  });

  jQuery('#fileSelectDialog #inner-lightbox a').live('click',function(){
    jQuery('#fileSelectDialog #inner-lightbox a').removeClass('selected');
    jQuery(this).addClass('selected');
  });

  /*
  *Add click function on a.page-link  items
  *Those items are links that shows dialogBox to add a page to blocks
  **/
  jQuery('a.page-link').live('click',function(e){
    e.preventDefault();
    openPageDialog(jQuery(this));
    return false;
  });

  /*
  *Add click function on .small-icons.page items
  *Those items are li in page tree (in dialog box)
  * sends ajax request to link a page with a block
  * add the new linked page in pages list
  *and close the dialogg box
  **/
  jQuery('.link-page.small-icons.page').live('click',function(){
    if(!jQuery(this).hasClass('active')){
      var url = jQuery(this).attr('href');
      var block_id = url.split('/')[5];
      var page_id = jQuery(this).parent().attr('id').substr(5);
      jQuery.ajax({
        "url": url,
        "complete": putInPageList(jQuery(this).text(), jQuery(this).attr('title'), block_id, page_id),
        "data": { "authenticity_token": encodeURIComponent(window._forgeos_js_vars.token) },
        "dataType": 'script',
        "type": 'post'
      });
      closeDialogBox();
    }
    return false;
  });

  /*
  *Add click function on .static-tab,.widget-tab items
  *Those items are headers links in blocks/widget dialog box
  *that display the widgets or blocks trees
  **/
  jQuery('.static-tab,.widget-tab').live('click',function(e){
    e.preventDefault();
    toggleHoverlayTrees(jQuery(this).attr('class'));
    return false;
  });

  jQuery('.lightbox-actuality').dialog({
    "autoOpen": false,
    "modal": true,
    "minHeight": 400,
    "width": 950,
    "open": function(){ tmce_load_children('#form_actuality'); },
    "beforeclose": function(){ tmce_unload_children('#form_actuality'); },
    "resizable": 'se'
  });

  jQuery('.add-actuality').live('click',function(){
    empty_actuality_overlay_fields();
    tmce_unload_children('#form_actuality');
    jQuery('.lightbox-actuality').dialog('open');
    jQuery('#submit_actuality').addClass('create-actuality');
    jQuery('#submit_actuality').removeClass('update-actuality');
    return false;
  });

  jQuery('.edit-actuality').live('click',function(){
    tmce_unload_children('#form_actuality');
    jQuery('.lightbox-actuality').dialog('open');
    jQuery('#submit_actuality').removeClass('create-actuality');
    jQuery('#submit_actuality').addClass('update-actuality');
    return false;
  });
});
