function check_import_progress(data){
  var pgb = jQuery('#progressbar');
  var value = parseFloat(data).toFixed(0);
  pgb.progressbar('value', value);
  pgb.find('span').text(value + '%');
  if (value != 100) setTimeout("jQuery.get('/admin/import/progress',check_import_progress);",5000);
}
