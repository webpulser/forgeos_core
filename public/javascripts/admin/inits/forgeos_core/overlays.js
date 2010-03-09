jQuery(document).ready(function(){
  //init dialog Box
  $('.lightbox-container').dialog({
     autoOpen:false,
     modal:true,
     minHeight: 380,
     width: 500,
      resizable:'se'
  });

  $('#imageUploadDialog').dialog({
    autoOpen:false,
    modal:true,
    width: 500,
    buttons: {
      Upload: function() {
        $('#imageUpload').uploadifyUpload();
      },
      'Clear queue': function() {
        $('#imageUpload').uploadifyClearQueue();
      }
    },
    resizable:'se'
  });

  $('#imageUploadDialogLeftSidebar').dialog({
    autoOpen:false,
    modal:true,
    width: 500,
    buttons: {
      Upload: function() {
        $('#imageUploadLeftSidebar').uploadifyUpload();
      },
      'Clear queue': function() {
        $('#imageUploadLeftSidebar').uploadifyClearQueue();
      }
    },
    resizable:'se'
  }); 

 $('#imageSelectDialogLeftSidebar').dialog({
    autoOpen:false,
    modal:true,
    width: 800,
    buttons: {
      Ok: function() {
       	add_picture_to_category();
      },
    },
    resizable:'se'
  });

	
  $('#fileUploadDialog').dialog({
    autoOpen:false,
    modal:true,
    width: 500,
    buttons: {
      Upload: function() {
        $('#fileUpload').uploadifyUpload();
      },
      'Clear queue': function() {
        $('#fileUpload').uploadifyClearQueue();
      }
    },
    resizable:'se'
  });


  $('.display-thumbnails').click( function() {
    if($(this).hasClass('off')){
      $(this).toggleClass('off');
      $('.display-list').toggleClass('off');
      $('.media-hoverlay-content').toggleClass('hidden');
      var search_element = $('#search.image');
      search_element.removeClass('image');
      search_element.addClass('thumbnails');
    }
    return false;
  });

  $('.display-list').click( function() {
    if($(this).hasClass('off')){
      $(this).toggleClass('off');
      $('.display-thumbnails').toggleClass('off');
      $('.media-hoverlay-content').toggleClass('hidden');
      var search_element = $('#search.thumbnails');
      search_element.removeClass('thumbnails');
      search_element.addClass('image');
    }
    return false;
  });

  /*
   *Add click function on .add-picture items
   *Those items are links that show dialog Box to uploads media
   **/
  $('#add-picture').live('click',function(){
     openimageUploadDialog($(this));
     return false;
  });

  $('#add-attachment').live('click',function(){
    openimageUploadDialog($(this));
    return false;
  });

  $('#add-file').live('click',function(){
    openfileUploadDialog();
    return false;
  });

  /*
  *Add click function on .fieldset a.backgrounds  items
  *Those items are links that shows dialogBox to add some blocks/widgets
  **/
  $('#add-block, #add-widget').bind('click',function(){
    openBlockDialog($(this));
    return false;
  });


  $('#fileSelectDialog #inner-lightbox a').live('click',function(){
    $('#fileSelectDialog #inner-lightbox a').removeClass('selected');
    $(this).addClass('selected');
  });

  jQuery(document).ready(function(){
  /*
  *Add click function on a.page-link  items
  *Those items are links that shows dialogBox to add a page to blocks
  **/
  $('a.page-link').live('click',function(){
    openPageDialog($(this));
    return false;
  });

  /*
  *Add click function on .small-icons.page items
  *Those items are li in page tree (in dialog box)
  * sends ajax request to link a page with a block
  * add the new linked page in pages list
  *and close the dialogg box
  **/
  $('.link-page.small-icons.page').bind('click',function(){
    if(!$(this).hasClass('active')){
      var url = $(this).attr('href');
      var block_id = url.split('/')[5];
      var page_id = $(this).parent().attr('id').substr(5);
      $.ajax({
          url: url,
            complete: putInPageList($(this).text(), $(this).attr('title'), block_id, page_id),
            data: 'authenticity_token=' + encodeURIComponent(AUTH_TOKEN),
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
  $('.static-tab,.widget-tab').bind('click',function(){
    toggleHoverlayTrees($(this).attr('class'));
    return false;
  });

 $('.lightbox-actuality').dialog({
       autoOpen:false,
       modal:true,
       minHeight: 400,
       width: 950,
       open: function(){ tmce_load_children('#form_actuality'); },
       beforeclose: function(){ tmce_unload_children('#form_actuality'); },
       resizable: 'se'
  });

  $('.add-actuality').live('click',function(){
    empty_actuality_overlay_fields();
    tmce_unload_children('#form_actuality');
    $('.lightbox-actuality').dialog('open');
    $('#submit_actuality').addClass('create-actuality');
    $('#submit_actuality').removeClass('update-actuality');
    return false;
  });

  $('.edit-actuality').live('click',function(){
    tmce_unload_children('#form_actuality');
    $('.lightbox-actuality').dialog('open');
    $('#submit_actuality').removeClass('create-actuality');
    $('#submit_actuality').addClass('update-actuality');
    return false;
  });

  $('#imageSelectDialog').dialog({
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
        $('#imageSelectDialog').dialog('close');
      }
    },
    open: function(){ $('#image-table:visible,#thumbnail-table:visible').dataTableInstance().fnDraw(); }
  });

  $('#fileSelectDialog').dialog({
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
        $('#fileSelectDialog').dialog('close');
      }
    },
    open: function(){ $('#table-files').dataTableInstance().fnDraw(); }
  });


});

});
