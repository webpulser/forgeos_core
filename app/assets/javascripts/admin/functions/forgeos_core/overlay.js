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
function openimageUploadDialogLeftSidebar(link){
  initImageUploadLeftSidebar(link);
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