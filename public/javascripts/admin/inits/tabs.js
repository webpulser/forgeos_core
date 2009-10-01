jQuery(document).ready(function(){
  //init the tabulation only if there's some tabs
  if($("#page").children('ul')[0]!=undefined){
    $("#page").tabs({
      select: function(event, ui) {
        var url = $.data(ui.tab, 'load.tabs');
        if( url ) {
            location.href = url;
            return false;
        }
        return true;
      }
    });
  }

  //tabs for dashboard
  $(".to-tab").tabs({
    ui: { theme_path: '/stylesheets/jquery-ui/themes/', theme_name : 'dashboard'}
  });
  $("#to-tab").tabs({
    ui: { theme_path: '/stylesheets/jquery-ui/themes/', theme_name : 'dashboard'}
  });
});