function check_import_progress(data){
  var pgb = jQuery('#progressbar');
  var value = parseFloat(data).toFixed(0);
  pgb.progressbar('value', value);
  pgb.find('span').text(value + '%');
  if (value != 100) setTimeout("jQuery.get('/admin/import/progress',check_import_progress);",5000);
}
jQuery(document).ready(function(){
  jQuery('#map_fields_form .interact-links input').live('click',function(e){
    e.preventDefault();
    jQuery.ajax({
      type: 'POST',
      url: jQuery('#map_fields_form').attr('action'),
      data: jQuery('#map_fields_form').serialize(),
      complete: function(data, statusText){
        if (statusText == 'error') jQuery('#progressbar').text(data.responseText);
        jQuery('#progressbar').removeClass('running');
        display_notifications();
      }
    });
    jQuery('#progressbar').progressbar().addClass('running').append('<span>0%</span>');
    check_import_progress('0');
    return false;
  });
});
