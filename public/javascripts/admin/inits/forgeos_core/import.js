function check_import_progress(data){
  var pgb = $('#progressbar');
  var value = parseFloat(data).toFixed(0)+'%';
  pgb.css({width: value});
  pgb.text(value);
  setTimeout("$.get('/admin/import/progress',check_import_progress);",5000);
}
jQuery(document).ready(function(){
  $('#map_fields_form .interact-links input').live('click',function(){
    check_import_progress('0');
    $.post($('#map_fields_form').attr('action'),$('#map_fields_form').serialize(), display_notifications);
    return false;
  });
});
