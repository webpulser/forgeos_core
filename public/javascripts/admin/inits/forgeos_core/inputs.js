jQuery(document).ready(function(){
  // init delayedObserver to generate url from name
  $('input:regex(id,.+_(name|title))').change(function() {
     var value = $(this).val();
     var id = $(this).attr('id');
     var element_name = id.split('_')[0];
     var element = $('textarea:regex(id,.+_meta_info_attributes_title)');
     if (element.is(':visible')){
       element.val(value);
     }


     $.ajax({
       beforeSend:function(request){$('input:regex(id,.+_url)').addClass('loading');},
       data: { url: value, authenticity_token: AUTH_TOKEN },
       dataType:'text',
       success:function(request){
         var target = $('input:regex(id,.+_url)');
         target.val(request);
         target.removeClass('loading');
       },
       type:'post',
       url: '/admin/'+element_name+'s/url'
     });
  });

  $('textarea.mceEditor:regex(id,.+_(description|content))').change(function() {
     var value = $(this).text();
     var element = $('textarea:regex(id,.+_meta_info_attributes_description)');
     if (element.is(':visible')){
       element.val(value);
     }
  });

  //init sortable
  $('.sortable').each(function(){
    $(this).sortable({
      handle:'.handler',
      placeholder: 'ui-state-highlight'
    });
  });

  //init nested_sortable
  $('.nested_sortable').each(function(){
    $(this).sortable({
      handle:'.handler',
      placeholder: 'ui-state-highlight',
      update: function(event, ui){
        update_block_container_positions($(this));
       }
    });
  });

  $('.defaultValue').each(function(){
    if($(this).val() == ""){
      $(this).val($(this).attr('title'));
    }
  });

  $('.defaultValue').focus(function(){
    if($(this).val() == $(this).attr('title')){
      $(this).val('');
    }
    return false;
  });

  $('.defaultValue').blur(function(){
    if($(this).val() == ""){
      $(this).val($(this).attr('title'));
    }
    return false;
  });

	$('#tag').parent().append('<div id="tag_autocomplete_container"><span class="shadow"></span><span id="tag_autocomplete"></span></div>');
	$('#tag').attr("autocomplete","off")

  $('#tag').keyup(function(){
		if($('#tag').val().length>2){
			var value = $(this).val();
			var target = $('#tag_autocomplete');
			var out = "";
	    $.ajax({
	      beforeSend:function(request){$('#tag').addClass('loading');},
	      data: { tag: value, authenticity_token: AUTH_TOKEN },
	      dataType:'json',
	      success:function(request){
					if(request.length>0){
		        for (var i=0; i<request.length; i++){
							out += "<span>"+request[i]+"</span>";
						}
						$('#tag_autocomplete').html(out);
						$('#tag_autocomplete_container').show();
		        target.removeClass('loading');
					}
					else{
						flush_tag_autocomplete();
					}
	      },
				error:function(request){
					flush_tag_autocomplete();
				},
	      type:'post',
	      url: '/admin/tags/tag'
	    });
		}
		else{
			flush_tag_autocomplete();
		}
  });

	$('#tag_autocomplete').find('span').live('click', function(){
		$('#tag').val($(this).text());
		flush_tag_autocomplete();
		//TODO give the input focus back
		$('#tag').focus();
	})

	function flush_tag_autocomplete(){
		$('#tag_autocomplete').html('');
		$('#tag_autocomplete_container').hide();
	}

    $('input.date-picker').datepicker({
      dateFormat: 'dd/mm/yy',
      showOn: 'both',
      buttonText: '',
      changeMonth: true,
      changeYear: true
    });
});
