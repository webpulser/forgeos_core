//open a standard dialog Box
function openStandardDialog(){
  jQuery('.lightbox-container').dialog('open');
}

//open an upload dialog Box
function openimageUploadDialog(link){
  initImageUpload(link);
  jQuery('#imageSelectDialog').dialog('open');
}

//open an upload dialog Box
function openimageLeftSidebarUploadDialog(link){
  jQuery('#imageLeftSidebarUploadDialog').dialog('open');
  forgeosInitUpload('#imageLeftSidebar','add_picture_to_category');
}

//open an upload dialog Box
function openfileUploadDialog(){
  initFileUpload();
  jQuery('#fileSelectDialog').dialog('open');
}

//Hide the dialog box
function closeDialogBox(){
  jQuery('.lightbox-container').dialog('close');
}

// Add class 'selected' to element and remove it from its siblings
function toggleSelectedOverlay(element){
  if(!jQuery(element).hasClass('selected')){
    jQuery(element).addClass('selected');
    jQuery(element).siblings().removeClass('selected');
  }
}

function add_picture_to_category(path, id, name){
  var cat_id = get_rails_element_id($('.tree-li-selected-to-add-image'));
  jQuery.ajax({
    "success": function(result){
      jQuery.jstree._focused().refresh();
      jQuery('#imageLeftSidebarSelectDialog').dialog('close');
    },
    "error": function(){},
    "data":  {
      'category[attachment_ids]': [id],
      authenticity_token: window._forgeos_js_vars.token
    },
    "dataType": 'json',
    "type": 'put',
    "url": '/admin/categories/'+ cat_id +'.json',
  });
}
