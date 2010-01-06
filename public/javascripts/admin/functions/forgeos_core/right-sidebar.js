//init the cookie
var COOKIE_NAME = 'closed_panels_list';
var OPTIONS = { path: '/admin/', expires: 10 };
if($.cookie(COOKIE_NAME) == null){
  $.cookie(COOKIE_NAME, '',OPTIONS);
}

/*
 *Init the steps in right sidebar
 **/
function init_steps(){
  var step = $(this).parent();
  var closed_panels_cookie = $.cookie(COOKIE_NAME);

  if ($(this).parent().hasClass('disabled')) {
    $(this).next().hide();
  }
  else if( closed_panels_cookie && closed_panels_cookie.match(step.attr('id'))){
    $(this).next().hide();
    step.toggleClass('open');
  }
}

/*
 *Show/Hide steps content in right sidebar
 **/
function toggle_steps(){
  if (!$(this).parent().hasClass('disabled')) {
    var step = $(this).parent();
    if (step.hasClass('open')) {
      tmce_unload_children(step);
    } else {
      tmce_load_children(step);
    }
    $(this).next().toggle('blind');
    step.toggleClass('open');
    set_cookie_for_panels($(this));
  }
  return false;
}

/*
 *manage the cookie for panels
 */
function set_cookie_for_panels (panel){
  var closed_panels_cookie = $.cookie(COOKIE_NAME);
  var step = panel.parent();
  var closed_cookie_info = step.attr('id');

  if(!step.hasClass('open')){
    //Add closed_cookie_info in the cookie
    $.cookie(COOKIE_NAME, closed_panels_cookie+';'+closed_cookie_info, OPTIONS);
  }
  else{
    //Remove closed_cookie_info from the cookie
    $.cookie(COOKIE_NAME, closed_panels_cookie.replace(';'+closed_cookie_info,''), OPTIONS);
  }
}