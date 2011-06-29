jQuery(document).ready(function(){
  jQuery("#blocks-header.backgrounds.settings").tabs();
 
  jQuery('#setting_mailer_delivery_method').change(function(){
    var value = jQuery('#setting_mailer_delivery_method').val();
    jQuery('.delivery_method_settings').hide();
    jQuery('#'+value).show();
  })

  if (jQuery('#setting_mailer_delivery_method').val() != null){
    var value = jQuery('#setting_mailer_delivery_method').val();
    jQuery('.delivery_method_settings').hide();
    jQuery('#'+value).show();
  }
});
