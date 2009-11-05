function toggle_menu_types_overlays(){
  if ($('#target-link').is(':visible')){
    $('#target-link').hide();
    $('#external-link').show();
  }
  else{
    $('#external-link').hide();
    $('#target-link').show();
  }
}