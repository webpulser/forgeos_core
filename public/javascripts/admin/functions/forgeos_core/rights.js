/* Roles */

/* Plugin unwrap: remove an element around an other */
$.fn.unwrap = function() {
  this.parent(':not(body)')
    .each(function(){
      $(this).replaceWith( this.childNodes );
    });

  return this;
};

/* Discard inline crud */
function discard() {
  $('#new_row').remove();
  //$('.create-right').parent().show();
  $('#table').find('.edit-link').show();
  $('#table').find('.duplicate-link').show();
  $('#table').unwrap();
}

/* Disable all edit-right & duplicate-right & the create right button*/
function disable_links() {
  //$('.create-right').parent().hide();
  $('#table').find('.edit-link').hide();
  $('#table').find('.duplicate-link').hide();
}

function form_ajax_right(url, method){
  onsubmit_ajax = "$.ajax({\n\
      success: function(result){\n\
        $('#table').dataTableInstance().fnDraw(); \n\
        $('#table').unwrap(); \n\
        $('.create-right').parent().show();\n\
      }, \n\
      error: function(){\n\
        display_notifications();\n\
      }, \n\
      data: $.param($(this).serializeArray()) + '&authenticity_token=' + encodeURIComponent('" + AUTH_TOKEN + "'), \n\
      dataType: 'script', \n\
      type: '"+method+"', \n\
      url: '"+url+"'\n\
    }); \n\
    return false;"

  return onsubmit_ajax;
}
