function setup_upload_dialog(selector) {
  jQuery(selector + 'Dialog').dialog({
    autoOpen:false,
    modal:true,
    width: 500,
    buttons: {
      Upload: function() {
        jQuery(selector).uploadifyUpload();
      },
      'Clear queue': function() {
        jQuery(selector).uploadifyClearQueue();
      }
    },
    resizable:'se'
  });
}

function forgeosInitUpload(selector, callback) {
  var upload = selector + 'Upload';
  var dialog = upload + 'Dialog';
  var select_dialog = selector + 'SelectDialog';

  jQuery(selector + 'Dialog').html('<div id="'+upload.replace('#','')+'"></div><div class="library-add"><span>or</span><a href="#" onclick="$("'+dialog+'").dialog(\'close\'); $("'+select_dialog+'").dialog(\'open\'); return false;">add from library</a></div>');

  var uploadify_datas = { "format": "json" };
  uploadify_datas[window._forgeos_js_vars.session_key] = window._forgeos_js_vars.session;

  $(upload).uploadify({
    "uploader": '/assets/forgeos/uploadify/uploadify.swf',
    "cancelImg": '/assets/forgeos/admin/big-icons/delete-icon.png',
    "script": "/admin/pictures",
    "buttonImg": '/assets/forgeos/uploadify/choose-picture_'+window._forgeos_js_vars.locale+'.png',
    "width": "154",
    "height": "24",
    "scriptData": uploadify_datas,
    "ScriptAccess": "always",
    "multi": "true",
    "displayData": "speed",
    "onComplete": function(e,queueID,fileObj,response,data) {
      if(typeof JSON=="object" && typeof JSON.parse=="function") {
        result = JSON.parse(response);
      } else{
        result = eval('(' + response + ')');
      }
      if (result.result == 'success'){
        eval(callback + '(result.path,result.id,fileObj.name);');
      } else {
        display_notification_message('error',result.error);
      }
    },
    "onAllComplete": function() {
      jQuery(dialog).dialog('close');
    }
  });
}
