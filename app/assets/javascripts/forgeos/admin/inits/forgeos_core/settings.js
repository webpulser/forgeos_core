jQuery(document).ready(function(){
  jQuery("#blocks-header").tabs();

  jQuery('#setting_mailer_delivery_method').change(function(){
    var value = jQuery('#setting_mailer_delivery_method').val();
    jQuery('.delivery_method_settings').hide();
    jQuery('#'+value).show();
  })

  var current_mailer_setting = jQuery('#setting_mailer_delivery_method').val();
  if (current_mailer_setting != null){
    jQuery('.delivery_method_settings').hide();
    jQuery('#'+current_mailer_setting).show();
  }

  jQuery('#setting_smtp_settings_authentication').change(function() {
    if(this.value == 'none') {
      jQuery('#authentication').addClass('hidden');
    } else {
      jQuery('#authentication').removeClass('hidden');
    }
  });
});
