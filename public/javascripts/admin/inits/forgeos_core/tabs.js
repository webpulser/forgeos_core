jQuery(document).ready(function(){
  //init the tabulation only if there's some tabs
  if(jQuery("#page").children('ul')[0]!=undefined){
    jQuery("#page").tabs({
      select: function(event, ui) {
        var url = jQuery.data(ui.tab, 'load.tabs');
        if( url ) {
            location.href = url;
            return false;
        }
        return true;
      }
    });
  }

  //tabs for dashboard
  jQuery(".to-tab").tabs({
    ui: { theme_path: '/stylesheets/jquery-ui/themes/', theme_name : 'dashboard'}
  });
  jQuery("#to-tab").tabs({
    ui: { theme_path: '/stylesheets/jquery-ui/themes/', theme_name : 'dashboard'}
  });
});