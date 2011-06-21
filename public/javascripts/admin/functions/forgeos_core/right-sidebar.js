//init the cookie
var COOKIE_NAME = 'closed_panels_list';
var OPTIONS = { path: '/admin/', expires: 10 };
if(jQuery.cookie(COOKIE_NAME) == null){
  jQuery.cookie(COOKIE_NAME, '',OPTIONS);
}

/*
 *Init the steps in right sidebar
 **/
function init_steps(){
  var step = jQuery(this).parent();
  var closed_panels_cookie = jQuery.cookie(COOKIE_NAME);

  if (jQuery(this).parent().hasClass('disabled')) {
    jQuery(this).next().hide();
  }
  else if( closed_panels_cookie && closed_panels_cookie.match(step.attr('id'))){
    jQuery(this).next().hide();
    step.toggleClass('open');
  }
}

/*
 *Show/Hide steps content in right sidebar
 **/
function toggle_steps(){
  if (!jQuery(this).parent().hasClass('disabled')) {
    var step = jQuery(this).parent();
    if (step.hasClass('open')) {
      tmce_unload_children(step);
    } else {
      tmce_load_children(step);
    }
    jQuery(this).next().toggle('blind');
    step.toggleClass('open');
    set_cookie_for_panels(jQuery(this));
  }
  return false;
}

/*
 *manage the cookie for panels
 */
function set_cookie_for_panels (panel){
  var closed_panels_cookie = jQuery.cookie(COOKIE_NAME);
  var step = panel.parent();
  var closed_cookie_info = step.attr('id');

  if(!step.hasClass('open')){
    //Add closed_cookie_info in the cookie
    jQuery.cookie(COOKIE_NAME, closed_panels_cookie+';'+closed_cookie_info, OPTIONS);
  }
  else{
    //Remove closed_cookie_info from the cookie
    jQuery.cookie(COOKIE_NAME, closed_panels_cookie.replace(';'+closed_cookie_info,''), OPTIONS);
  }
}