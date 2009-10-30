jQuery(document).ready(function(){
  /*
   *Add change function on .check-me-it-appears items
   *Those items are checkboxes that show/hide the
   *next .i-will-appear item
   **/
  $('.check-me-it-appears').change(function(){
    $(this).next('.i-will-appear').toggle();
  });

  /* RIGHT SIDEBAR STEPS */
  $('a.step-title, a.panel').bind('click',toggle_steps);
  $('a.step-title, a.panel').each(init_steps);

  $('#tag').bind("keypress", function(e){
    if (e.which == 13) {

      e.preventDefault();
			var input = $(this);
			var hidden_field_tag_name = '<input type="hidden" name="tag_list[]" value="'+input.val()+'" />';
		  var destroy = '<a href="#" class="big-icons gray-destroy">&nbsp;</a>';
		  var new_tag = '<span >'+input.val()+hidden_field_tag_name+destroy+'</span>';

		  $('.tags .wrap_tags').append(new_tag);

		  input.val('');
		  var tags = [];
		  $($(this.form).serializeArray()).each(function(){
		    if (this.name == 'tag_list[]' && this.value != ''){
		      tags.push(this.value);
		    }
		  });
		  var element = $('textarea:regex(id,.+_meta_info_attributes_keywords)');
		  if (element.is(':visible')){
		    element.val(tags.join(', '));
		  }
    }
  });
});


function submit_tag(input){
  var hidden_field_tag_name = '<input type="hidden" name="tag_list[]" value="'+input.val()+'" />';
  var destroy = '<a href="#" class="big-icons gray-destroy">&nbsp;</a>';
  var new_tag = '<span >'+input.val()+hidden_field_tag_name+destroy+'</span>';

  $('.tags .wrap_tags').append(new_tag);

  input.val('');
  var tags = [];
  $($(input.form).serializeArray()).each(function(){
    if (input.name == 'tag_list[]' && input.value != ''){
      tags.push(input.value);
    }
  });
  var element = $('textarea:regex(id,.+_meta_info_attributes_keywords)');
  if (element.is(':visible')){
    element.val(tags.join(', '));
  }
}