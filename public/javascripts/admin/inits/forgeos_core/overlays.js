jQuery(document).ready(function(){
  //init dialog Box
  $('.lightbox-container').dialog({
     autoOpen:false,
     modal:true,
     minHeight: 380,
     width: 500,
      resizable:'se'
  });

  $('#imageSelectDialog').dialog({
    autoOpen:false,
    modal:true,
    minHeight: 380,
    width: 800,
    resizable:'se',
    buttons: {
      Ok: function(){
        var current_table = $('#image-table:visible,#thumbnail-table:visible').dataTableInstance();
        indexes = current_table.fnGetSelectedIndexes();
        console.info(current_table);
        console.log(indexes);
        for(var i=0; i<indexes.length; i++){
          path = current_table.fnGetData(indexes[i]).slice(-3,-2);
          id = current_table.fnGetData(indexes[i]).slice(-2,-1);
          name = current_table.fnGetData(indexes[i]).slice(-1);
          add_picture_to_product(path,id,name);
        }
        check_product_first_image();
        $(current_table.fnGetSelectedNodes()).toggleClass('row_selected');
        $('#imageSelectDialog').dialog('close');
      }
    }
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


  $('#fileSelectDialog').dialog({
    autoOpen:false,
    modal:true,
    minHeight: 380,
    width: 800,
    resizable:'se',
    buttons: {
     Ok: function(){
       var current_table = $('#table-files').dataTableInstance();
       indexes = current_table.fnGetSelectedIndexes();
       for(var i=0; i<indexes.length; i++){
         size = current_table.fnGetData(indexes[i]).slice(-6,-5);
         type = current_table.fnGetData(indexes[i]).slice(-8,-7);
         id = current_table.fnGetData(indexes[i]).slice(-2,-1);
         name = current_table.fnGetData(indexes[i]).slice(-1);

         add_attachment_to_product(id,name,size,type);
       }
       $(current_table.fnGetSelectedNodes()).toggleClass('row_selected');
       $('#fileSelectDialog').dialog('close');
     }
    },
    open: function(){
     current_table_index = 2;
    }
  });

  current_table_index = 0;

  $('.display-thumbnails').click( function() {
    if($(this).hasClass('off')){
      $(this).toggleClass('off');
      $('.display-list').toggleClass('off');
      $('.media-hoverlay-content').toggleClass('hidden');
      var search_element = $('#search.image');
      search_element.removeClass('image');
      search_element.addClass('thumbnails');
      current_table_index = 0;
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
      current_table_index = 1;
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
  $('.fieldset a.backgrounds').bind('click',function(){
    openBlockDialog($(this));
    return false;
  });


  $('#fileSelectDialog #inner-lightbox a').live('click',function(){
    $('#fileSelectDialog #inner-lightbox a').removeClass('selected');
    $(this).addClass('selected');
  });
});
