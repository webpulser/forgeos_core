function check_import_progress(data){
  var pgb = $('#progressbar');
  var value = parseFloat(data).toFixed(0);
  pgb.progressbar('value', value);
  pgb.find('span').text(value + '%');
  if (value != 100) setTimeout("$.get('/admin/import/progress',check_import_progress);",5000);
}
jQuery(document).ready(function(){
  $('#map_fields_form .interact-links input').live('click',function(e){
    e.preventDefault();
    $.ajax({
      type: 'POST',
      url: $('#map_fields_form').attr('action'),
      data: $('#map_fields_form').serialize(),
      complete: function(data, statusText){
        if (statusText == 'error') $('#progressbar').text(data.responseText);
        $('#progressbar').removeClass('running');
        display_notifications();
      }
    });
    $('#progressbar').progressbar().addClass('running').append('<span>0%</span>');
    check_import_progress('0');
    return false;
  });
});
