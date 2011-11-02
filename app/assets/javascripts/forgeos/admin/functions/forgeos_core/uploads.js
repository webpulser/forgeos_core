function add_picture_to_element(data) {
  var object_name = jQuery('form#wrap').data('object_name');
  var input = jQuery('.add-image.current').data('input_name');
  jQuery(input + '-picture ul.sortable').html('<li><img src="' + data.path + '" alt="' + data.name + '"/><a href="#" onclick="jQuery(this).parents(\'li\').remove(); jQuery(\'' + input + '\').val(null); return false;" class="big-icons delete"></a></li>');
  jQuery(input).val(data.id);
}

function add_picture_to_visuals(data){
  var object_name= jQuery('form#wrap').data('object_name');
  jQuery('#visuals-picture ul.sortable').before('<li><a href="#" onclick="jQuery(this).parents(\'li\').remove(); return false;" class="big-icons trash"></a><input type="hidden" name="' + object_name + '[attachment_ids][]" value="' + data.id + '"/><img src="' + data.path + '" alt="' + data.name + '"/><div class="handler"><div class="inner"></div></div></li>');
}

function setup_upload_dialog(selector) {
  jQuery(selector + 'Dialog').dialog({
    "autoOpen": false,
    "modal": true,
    "width": 500,
    "buttons": {
      "Upload": function() {
        jQuery(selector).uploadifyUpload();
      },
      "Clear queue": function() {
        jQuery(selector).uploadifyClearQueue();
      }
    },
    "resizable": 'se'
  });
}

function setup_select_dialog(selector, table_selector) {
  jQuery(selector + 'Dialog').dialog({
    "autoOpen": false,
    "modal": true,
    "minHeight": 380,
    "width": 800,
    "resizable":'se',
    "buttons": {
      "Ok": function(){
        dataTableSelectRows(table_selector, function(current_table,indexes){
          for(var i=0; i<indexes.length; i++){
            var row = current_table.fnGetData(indexes[i]);
            var result = {
              "size": row.slice(-6,-5),
              "type": row.slice(-8,-7),
              "path": row.slice(-3, -2),
              "id": row.slice(-2,-1),
              "name": row.slice(-1)
            }
            var callback = jQuery('.add-image.current, .add-file.current').data('callback');
            eval(callback + '(result);');
          }
        });
        jQuery(selector + 'Dialog').dialog('close');
      }
    },
    "open": function(e,ui){
      eval(jQuery(table_selector).data('dataTables_init_function')+'()');
    }
  });
}

function forgeosInitUpload(selector) {
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
        result['name'] = fileObj.name;
        var callback = jQuery('.add-image.current,.add-file.current').data('callback');
        eval(callback + '(result);');
      } else {
        display_notification_message('error',result.error);
      }
    },
    "onAllComplete": function() {
      jQuery(dialog).dialog('close');
    }
  });
}

function initAttachmentUpload(file_type) {
  jQuery('#attachmentUploadDialog').dialog('open');
  //jQuery('#attachmentUploadDialog').html('<div id="attachmentUpload"></div>');
  var uploadify_datas = {
    "parent_id": jQuery('#parent_id_tmp').val(),
    "format": "json"
  };
  uploadify_datas[window._forgeos_js_vars.session_key] = window._forgeos_js_vars.session;

  jQuery('#attachmentUpload').uploadify({
    "uploader": '/assets/forgeos/uploadify/uploadify.swf',
    "cancelImg": '/assets/forgeos/admin/big-icons/delete-icon.png',
    "script": "/admin/attachments",
    "buttonImg": '/assets/forgeos/uploadify/upload-' + file_type + '_' + window._forgeos_js_vars.locale + '.png',
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
        oTable.fnDraw();
        jQuery.tree.focused().refresh();
      } else {
        display_notification_message('error', result.error);
      }
    },
    "onAllComplete": function() {
      jQuery('#attachmentUploadDialog').dialog('close');
    }
  });
}
