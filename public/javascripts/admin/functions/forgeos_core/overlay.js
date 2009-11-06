//open a standard dialog Box
function openStandardDialog(){
  $('.lightbox-container').dialog('open');
}

//open an upload dialog Box
function openimageUploadDialog(link){
  initImageUpload(link);
  $('#imageSelectDialog').dialog('open');
}

//open an upload dialog Box
function openimageUploadDialogLeftSidebar(link){
  initImageUploadLeftSidebar(link);
}

//open an upload dialog Box
function openfileUploadDialog(){
  initFileUpload();
  $('#fileSelectDialog').dialog('open');
}

//Hide the dialog box
function closeDialogBox(){
  $('.lightbox-container').dialog('close');
}

// Add class 'selected' to element and remove it from its siblings
function toggleSelectedOverlay(element){
  if(!$(element).hasClass('selected')){
    $(element).addClass('selected');
    $(element).siblings().removeClass('selected');
  }
}