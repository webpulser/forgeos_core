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
});
