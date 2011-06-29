/* Roles */

/* Plugin unwrap: remove an element around an other */
jQuery.fn.unwrap = function() {
  this.parent(':not(body)')
    .each(function(){
      jQuery(this).replaceWith( this.childNodes );
    });

  return this;
};

/* Discard inline crud */
function discard() {
  jQuery('#new_row').remove();
  //$('.create-right').parent().show();
  jQuery('#table').find('.edit-link').show();
  jQuery('#table').find('.duplicate-link').show();
  jQuery('#table').unwrap();
}

/* Disable all edit-right & duplicate-right & the create right button*/
function disable_links() {
  //$('.create-right').parent().hide();
  jQuery('#table').find('.edit-link').hide();
  jQuery('#table').find('.duplicate-link').hide();
}

function form_ajax_right(url, method){
  onsubmit_ajax = "jQuery.ajax({\n\
      success: function(result){\n\
        eval(jQuery('#table').data('dataTables_init_function')+'()'); \n\
        jQuery('#table').unwrap(); \n\
        jQuery('.create-right').parent().show();\n\
      }, \n\
      error: function(){\n\
        display_notifications();\n\
      }, \n\
      data: jQuery.param(jQuery(this).serializeArray()) + '&authenticity_token=' + encodeURIComponent('" + window._forgeos_js_vars.token + "'), \n\
      dataType: 'script', \n\
      type: '"+method+"', \n\
      url: '"+url+"'\n\
    }); \n\
    return false;"

  return onsubmit_ajax;
}
