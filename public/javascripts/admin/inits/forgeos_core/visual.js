jQuery(document).ready(function(){

  // add a picture button
  $('.add-picturepicture').live('click',function(){
     openpictureimageUploadDialog($(this));
     return false;
  });	

  // Dialog to select picture
  $('#imagepictureSelectDialog.project').dialog({
    autoOpen:false,
    modal:true,
    minHeight: 380,
    width: 800,
    resizable:'se',
    buttons: {
      Ok: function(){
        dataTableSelectRows('#image-table-picture:visible,#thumbnail-table-picture:visible',function(current_table,indexes){
          for(var i=0; i<indexes.length; i++){
            var row = current_table.fnGetData(indexes[i]);
            var path = row.slice(-3,-2);
            var id = row.slice(-2,-1);
            var name = row.slice(-1);
            add_picture_picture_to_element(path,id,name);
          }
        });          
        $('#imagepictureSelectDialog').dialog('close');
      }
    },
    open: function(){ $('#image-table-picture:visible,#thumbnail-table-picture:visible').dataTableInstance().fnDraw(); }
  });
 
  $('#imagepictureUploadDialog').dialog({
    autoOpen:false,
    modal:true,
    width: 500,
    buttons: {
      Upload: function() {
        $('#imagepictureUpload').uploadifyUpload();
      },
      'Clear queue': function() {
        $('#imagepictureUpload').uploadifyClearQueue();
      }
    },
    resizable:'se'
  });

  // add a image button
  $('.add-imagepicture').live('click',function(){
     openimageimageUploadDialog($(this));
     return false;
  });	

  // Dialog to select picture
  $('#imageimageSelectDialog.project').dialog({
    autoOpen:false,
    modal:true,
    minHeight: 380,
    width: 800,
    resizable:'se',
    buttons: {
      Ok: function(){
        dataTableSelectRows('#image-table-image:visible,#thumbnail-table-image:visible',function(current_table,indexes){
          for(var i=0; i<indexes.length; i++){
            var row = current_table.fnGetData(indexes[i]);
            var path = row.slice(-3,-2);
            var id = row.slice(-2,-1);
            var name = row.slice(-1);
            add_image_picture_to_element(path,id,name);
          }
        });          
        $('#imageimageSelectDialog').dialog('close');
      }
    },
    open: function(){ $('#image-table-image:visible,#thumbnail-table-image:visible').dataTableInstance().fnDraw(); }
  });
 
  $('#imageimageUploadDialog').dialog({
    autoOpen:false,
    modal:true,
    width: 500,
    buttons: {
      Upload: function() {
        $('#imageimageUpload').uploadifyUpload();
      },
      'Clear queue': function() {
        $('#imageimageUpload').uploadifyClearQueue();
      }
    },
    resizable:'se'
  });

  // add visuals button	
  $('.add-visualpictures').live('click',function(){
     openvisualsimageUploadDialog($(this));
     return false;
  });
	
  // Dialog to select pictures
  $('#imagevisualsSelectDialog.project').dialog({
    autoOpen:false,
    modal:true,
    minHeight: 380,
    width: 800,
    resizable:'se',
    buttons: {
      Ok: function(){
        dataTableSelectRows('#image-table-visuals:visible,#thumbnail-table-visuals:visible',function(current_table,indexes){
          for(var i=0; i<indexes.length; i++){
            var row = current_table.fnGetData(indexes[i]);
            var path = row.slice(-3,-2);
            var id = row.slice(-2,-1);
            var name = row.slice(-1);
            add_picture_to_element(path,id,name);
          }
        });          
        $('#imagevisualsSelectDialog').dialog('close');
      }
    },
    open: function(){ $('#image-table-visuals:visible,#thumbnail-table-visuals:visible').dataTableInstance().fnDraw(); }
  });
 
  $('#imagevisualsUploadDialog').dialog({
    autoOpen:false,
    modal:true,
    width: 500,
    buttons: {
      Upload: function() {
        $('#imagevisualsUpload').uploadifyUpload();
      },
      'Clear queue': function() {
        $('#imagevisualsUpload').uploadifyClearQueue();
      }
    },
    resizable:'se'
  });

});
