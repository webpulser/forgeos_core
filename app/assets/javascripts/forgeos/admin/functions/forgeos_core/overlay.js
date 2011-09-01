//open a standard dialog Box
function openStandardDialog(){
  jQuery('.lightbox-container').dialog('open');
}

//open an upload dialog Box
function openimageUploadDialog(link){
  forgeosInitUpload('#image');
  jQuery('#imageSelectDialog').dialog('open');
}

//open an upload dialog Box
function openfileUploadDialog(){
  forgeosInitUpload('#file');
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

function add_picture_to_category(data){
  var category = jQuery('.add-image.current');
  jQuery.ajax({
    "success": function(result){
      jQuery('#imageLeftSidebarSelectDialog').dialog('close');
      category.removeClass('add-image').removeClass('current');
      jQuery.jstree._focused().refresh(category.parents('li:first'));
    },
    "data":  {
      "category[attachment_ids][]": data.id,
      "authenticity_token": window._forgeos_js_vars.token
    },
    "dataType": 'json',
    "type": 'put',
    "url": '/admin/categories/'+ get_rails_element_id(category) +'.json',
  });
}
