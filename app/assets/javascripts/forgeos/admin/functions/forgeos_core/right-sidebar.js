function submit_tag(input){
  var hidden_field_tag_name = '<input type="hidden" name="tag_list[]" value="'+input.val()+'" />';
  var destroy = '<a href="#" class="big-icons gray-destroy">&nbsp;</a>';
  var new_tag = '<span >'+input.val()+hidden_field_tag_name+destroy+'</span>';

  jQuery('.tags .wrap_tags').append(new_tag);

  input.val('');
  var tags = [];
  jQuery(jQuery(input.form).serializeArray()).each(function(){
    if (input.name == 'tag_list[]' && input.value != ''){
      tags.push(input.value);
    }
  });
  var element = jQuery('textarea:regex(id,.+_meta_info_attributes_keywords)');
  if (element.is(':visible')){
    element.val(tags.join(', '));
  }
}

/*
 *Init the steps in right sidebar
 **/
function init_steps(){
  if(typeof jQuery.cookie === "undefined") { throw "jsTree cookie: jQuery cookie plugin not included."; }
  var step = jQuery(this).parent();
  var closed_panels_cookie = jQuery.cookie('closed_panels_list');

  if (jQuery(this).parent().hasClass('disabled')) {
    jQuery(this).next().hide();
  } else if (closed_panels_cookie && closed_panels_cookie.match(step.attr('id'))) {
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
function set_cookie_for_panels(panel){
  if(typeof jQuery.cookie === "undefined") { throw "jsTree cookie: jQuery cookie plugin not included."; }
  var closed_panels_cookie = jQuery.cookie('closed_panels_list');
  if (closed_panels_cookie == null) closed_panels_cookie = '';
  var step = panel.parent();
  var closed_cookie_info = step.attr('id');

  if(!step.hasClass('open')){
    //Add closed_cookie_info in the cookie
    closed_panels_cookie += ';' + closed_cookie_info;
  } else {
    //Remove closed_cookie_info from the cookie
    closed_panels_cookie = closed_panels_cookie.replace(';'+closed_cookie_info,'');
  }
  jQuery.cookie('closed_panels_list', closed_panels_cookie, { path: '/admin/', expires: 10 });
}
