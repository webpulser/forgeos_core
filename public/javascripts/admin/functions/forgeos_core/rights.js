/* Discard inline crud */
function discard() {
  $('#new_right').remove();
  $('.create-right').parent().show();
  $('#table').find('.edit-right').show();
  $('#table').find('.duplicate-right').show();
  $('#table').unwrap();
}

/* Disable all edit-right & duplicate-right & the create right button*/
function disable_links() {
  $('.create-right').parent().hide();
  $('#table').find('.edit-right').hide();
  $('#table').find('.duplicate-right').hide();
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
