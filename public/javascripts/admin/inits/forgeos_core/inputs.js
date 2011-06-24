jQuery(document).ready(function(){
  // init delayedObserver to generate url from name
  jQuery('.field_name').change(function() {
     var value = jQuery(this).val();
     var id = jQuery(this).attr('id');
     var element_name = id.split('_')[0];
     var element = jQuery('textarea:regex(id,.+_meta_info_attributes_title)');
     if (element.is(':visible')){
       element.val(value);
     }


     jQuery.ajax({
       beforeSend:function(request){jQuery('input:regex(id,.+_url)').addClass('loading');},
       data: { url: value, authenticity_token: window._forgeos_js_vars.token },
       dataType:'text',
       success:function(request){
         var target = jQuery('input:regex(id,.+_url)');
         target.val(request);
         target.removeClass('loading');
       },
       type:'post',
       url: '/admin/'+element_name+'s/url'
     });
  });

  jQuery('textarea.mceEditor:regex(id,.+_(description|content))').change(function() {
     var value = jQuery(this).text();
     var element = jQuery('textarea:regex(id,.+_meta_info_attributes_description)');
     if (element.is(':visible')){
       element.val(value);
     }
  });

  //init sortable
  jQuery('.sortable').each(function(){
    jQuery(this).sortable({
      handle:'.handler',
      placeholder: 'ui-state-highlight'
    });
  });

  //init nested_sortable
  jQuery('.nested_sortable').each(function(){
    jQuery(this).sortable({
      handle:'.handler',
      placeholder: 'ui-state-highlight',
      update: function(event, ui){
        update_block_container_positions(jQuery(this));
       }
    });
  });

  jQuery('.defaultValue').each(function(){
    if(jQuery(this).val() == ""){
      jQuery(this).val(jQuery(this).attr('title'));
    }
  });

  jQuery('.defaultValue').focus(function(){
    if(jQuery(this).val() == jQuery(this).attr('title')){
      jQuery(this).val('');
    }
    return false;
  });

  jQuery('.defaultValue').blur(function(){
    if(jQuery(this).val() == ""){
      jQuery(this).val(jQuery(this).attr('title'));
    }
    return false;
  });

 jQuery('#tag').parent().append('<div id="tag_autocomplete_container"><span class="shadow"></span><span id="tag_autocomplete"></span></div>');
 jQuery('#tag').attr("autocomplete","off")

  jQuery('#tag').keyup(function(){
    if(jQuery('#tag').val().length>2){
      var value = jQuery(this).val();
      var target = jQuery('#tag_autocomplete');
      var out = "";
      jQuery.ajax({
        beforeSend:function(request){jQuery('#tag').addClass('loading');},
        data: { tag: value, authenticity_token: window._forgeos_js_vars.token },
        dataType:'json',
        success:function(request){
          if(request.length>0){
            for (var i=0; i<request.length; i++){
              out += "<span>"+request[i]+"</span>";
            }
           jQuery('#tag_autocomplete').html(out);
           jQuery('#tag_autocomplete_container').show();
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

 jQuery('#tag_autocomplete').find('span').live('click', function(){
   jQuery('#tag').val(jQuery(this).text());
    flush_tag_autocomplete();
    //TODO give the input focus back
   jQuery('#tag').focus();
  })

  function flush_tag_autocomplete(){
   jQuery('#tag_autocomplete').html('');
   jQuery('#tag_autocomplete_container').hide();
  }

    jQuery('input.date-picker').datepicker({
      dateFormat: 'dd/mm/yy',
      showOn: 'both',
      buttonText: '',
      changeMonth: true,
      changeYear: true
    });
});
