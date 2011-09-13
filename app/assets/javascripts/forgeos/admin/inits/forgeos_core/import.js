jQuery(document).ready(function(){
  jQuery('form#import_form').attr('action', 'import/create_'+ jQuery('select#import_model').val());

  jQuery('select#import_model').live('change', function () {
    jQuery('form#import_form').attr('action', 'import/create_'+this.value);
  });
});
