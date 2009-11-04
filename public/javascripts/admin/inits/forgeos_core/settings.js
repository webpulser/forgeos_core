jQuery(document).ready(function(){
  $("#blocks-header.backgrounds.settings").tabs();
 
  $('#setting_mailer_delivery_method').change(function(){
    var value = $('#setting_mailer_delivery_method').val();
    $('.delivery_method_settings').hide();
    $('#'+value).show();
  })

  if ($('#setting_mailer_delivery_method').val() != null){
    var value = $('#setting_mailer_delivery_method').val();
    $('.delivery_method_settings').hide();
    $('#'+value).show();
  }
});
