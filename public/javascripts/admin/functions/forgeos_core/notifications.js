// Get notifications
function display_notifications(){
  jQuery.getJSON('/admin/notifications',function(data){
    if (data.notice != null) {
      display_notification_message('success',data.notice, 5000)
    }
    if (data.error != null) {
      display_notification_message('error',data.error)
    }
    if (data.warning != null) {
      display_notification_message('warning',data.warning)
    }
  });
}

function display_notification_message(type,message, delay){
  var notification_dom = '<div class="notification '+type+'"><span class="small-icons message">'+message+'</span><a href="#" class="big-icons gray-destroy"></a></div>';
  if (jQuery('#notifications').children(notification_dom).length == 0) {
    jQuery('#notifications').append(notification_dom);
    if (typeof(delay) != 'undefined')
      setTimeout("jQuery('#notifications').children('.notification."+type+":first').remove();",delay);
  }
}
