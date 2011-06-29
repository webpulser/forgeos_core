jQuery(document).ready(function(){
  //init dialog Box
  jQuery('.lightbox-container').dialog({
    autoOpen:false,
    modal:true,
    minHeight: 380,
    width: 500,
    resizable:'se'
  });

  jQuery('#imageUploadDialog').dialog({
    autoOpen:false,
    modal:true,
    width: 500,
    buttons: {
      Upload: function() {
        jQuery('#imageUpload').uploadifyUpload();
      },
      'Clear queue': function() {
        jQuery('#imageUpload').uploadifyClearQueue();
      }
    },
    resizable:'se'
  });

  jQuery('#imageUploadDialogLeftSidebar').dialog({
    autoOpen:false,
    modal:true,
    width: 500,
    buttons: {
      Upload: function() {
        jQuery('#imageUploadLeftSidebar').uploadifyUpload();
      },
      'Clear queue': function() {
        jQuery('#imageUploadLeftSidebar').uploadifyClearQueue();
      }
    },
    resizable:'se'
  });

  jQuery('#imageSelectDialogLeftSidebar').dialog({
    autoOpen:false,
    modal:true,
    width: 800,
    buttons: {
      Ok: function() {
       	add_picture_to_category();
      },
    },
    open: function() { eval(jQuery('#image-table:visible,#thumbnail-table:visible').data('dataTables_init_function')+'()'); },
    resizable:'se'
  });


  jQuery('#fileUploadDialog').dialog({
    autoOpen:false,
    modal:true,
    width: 500,
    buttons: {
      Upload: function() {
        jQuery('#fileUpload').uploadifyUpload();
      },
      'Clear queue': function() {
        jQuery('#fileUpload').uploadifyClearQueue();
      }
    },
    resizable:'se'
  });

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
   *Add click function on .add-picture items
   *Those items are links that show dialog Box to uploads media
   **/
  jQuery('#add-picture').live('click',function(e){
    e.preventDefault();
    openimageUploadDialog(jQuery(this));
    return false;
  });

  jQuery('#add-attachment').live('click',function(e){
    e.preventDefault();
    openimageUploadDialog(jQuery(this));
    return false;
  });

  jQuery('#add-file').live('click',function(e){
    e.preventDefault();
    openfileUploadDialog();
    return false;
  });

  /*
  *Add click function on .fieldset a.backgrounds  items
  *Those items are links that shows dialogBox to add some blocks/widgets
  **/
  jQuery('#add-block, #add-widget').bind('click',function(e){
    e.preventDefault();
    openBlockDialog(jQuery(this), jQuery(this).parent());
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
  jQuery('.link-page.small-icons.page').bind('click',function(){
    if(!jQuery(this).hasClass('active')){
      var url = jQuery(this).attr('href');
      var block_id = url.split('/')[5];
      var page_id = jQuery(this).parent().attr('id').substr(5);
      jQuery.ajax({
          url: url,
            complete: putInPageList(jQuery(this).text(), jQuery(this).attr('title'), block_id, page_id),
            data: 'authenticity_token=' + encodeURIComponent(window._forgeos_js_vars.token),
            dataType:'script',
            type:'post'
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
    autoOpen:false,
    modal:true,
    minHeight: 400,
    width: 950,
    open: function(){ tmce_load_children('#form_actuality'); },
    beforeclose: function(){ tmce_unload_children('#form_actuality'); },
    resizable: 'se'
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

  jQuery('#imageSelectDialog').dialog({
    autoOpen:false,
    modal:true,
    minHeight: 380,
    width: 800,
    resizable:'se',
    buttons: {
      Ok: function(){
        dataTableSelectRows('#image-table:visible,#thumbnail-table:visible',function(current_table,indexes){
          for(var i=0; i<indexes.length; i++){
            var row = current_table.fnGetData(indexes[i]);
            var path = row.slice(-3,-2);
            var id = row.slice(-2,-1);
            var name = row.slice(-1);
            add_picture_to_element(path,id,name);
          }
          //check_product_first_image();
        });
        jQuery('#imageSelectDialog').dialog('close');
      }
    },
    open: function(e,ui){
      eval(jQuery('#image-table:visible,#thumbnail-table:visible').data('dataTables_init_function')+'()');
    }
  });

  jQuery('#fileSelectDialog').dialog({
    autoOpen:false,
    modal:true,
    minHeight: 380,
    width: 800,
    resizable:'se',
    buttons: {
      Ok: function(){
        dataTableSelectRows('#table-files', function(current_table, indexes) {
          for(var i=0; i<indexes.length; i++){
            var row = current_table.fnGetData(indexes[i]);
            var size = row.slice(-6,-5);
            var type = row.slice(-8,-7);
            var id = row.slice(-2,-1);
            var name = row.slice(-1);

            add_attachment_to_product(id,name,size,type);
          }
        });
        jQuery('#fileSelectDialog').dialog('close');
      }
    },
    open: function(e,ui){
      eval(jQuery('#table-files').data('dataTables_init_function')+'()');
    }
  });
});
