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
