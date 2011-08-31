jQuery(document).ready(function(){
  //init closed_panels_list cookie
  if(typeof jQuery.cookie === "undefined") { throw "jsTree cookie: jQuery cookie plugin not included."; }
  if(jQuery.cookie('closed_panels_list') == null ){
    jQuery.cookie('closed_panels_list', '', { path: '/admin/', expires: 10 });
  }

  /*
   *Add change function on .check-me-it-appears items
   *Those items are checkboxes that show/hide the
   *next .i-will-appear item
   **/
  jQuery('.check-me-it-appears').change(function(){
    jQuery(this).next('.i-will-appear').toggle();
  });

  /* RIGHT SIDEBAR STEPS */
  jQuery('a.step-title, a.panel').bind('click',toggle_steps);
  jQuery('a.step-title, a.panel').each(init_steps);

  jQuery('#tag').bind("keypress", function(e){
    if (e.which == 13) {

      e.preventDefault();
      var input = jQuery(this);
      var hidden_field_tag_name = '<input type="hidden" name="tag_list[]" value="'+input.val()+'" />';
      var destroy = '<a href="#" class="big-icons gray-destroy">&nbsp;</a>';
      var new_tag = '<span >'+input.val()+hidden_field_tag_name+destroy+'</span>';

      jQuery('.tags .wrap_tags').append(new_tag);

      input.val('');
      var tags = [];
      jQuery(jQuery(this.form).serializeArray()).each(function(){
        if (this.name == 'tag_list[]' && this.value != ''){
          tags.push(this.value);
        }
      });
      var element = jQuery('textarea:regex(id,.+_meta_info_attributes_keywords)');
      if (element.is(':visible')){
        element.val(tags.join(', '));
      }
    }
  });
});
