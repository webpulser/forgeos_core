jQuery(document).ready(function(){

  setup_upload_dialog('#imagepictureUpload');
  setup_upload_dialog('#imageimageUpload');
  setup_upload_dialog('#imagevisualsUpload');


  // add a picture button
  jQuery('.add-picturepicture').live('click',function(){
     openpictureimageUploadDialog(jQuery(this));
     return false;
  });

  // add visuals button
  jQuery('.add-visualpictures').live('click',function(){
     openvisualsimageUploadDialog(jQuery(this));
     return false;
  });

  // add a image button
  jQuery('.add-imagepicture').live('click',function(){
     openimageimageUploadDialog(jQuery(this));
     return false;
  });

  // Dialog to select picture
  jQuery('#imagepictureSelectDialog.project').dialog({
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
        jQuery('#imagepictureSelectDialog').dialog('close');
      }
    },
    open: function(e,ui){
      eval(jQuery('#image-table-picture:visible,#thumbnail-table-picture:visible').data('dataTables_init_function')+'()');
    }
  });

  // Dialog to select picture
  jQuery('#imageimageSelectDialog.project').dialog({
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
        jQuery('#imageimageSelectDialog').dialog('close');
      }
    },
    open: function(e,ui){
      eval(jQuery('#image-table-image:visible,#thumbnail-table-image:visible').data('dataTables_init_function')+'()');
    }
  });

  // Dialog to select pictures
  jQuery('#imagevisualsSelectDialog.project').dialog({
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
        jQuery('#imagevisualsSelectDialog').dialog('close');
      }
    },
    open: function(e,ui){
      eval(jQuery('#image-table-visuals:visible,#thumbnail-table-visuals:visible').data('dataTables_init_function')+'()');
    }
  });

});
