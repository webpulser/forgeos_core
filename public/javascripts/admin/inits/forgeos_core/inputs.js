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
  //init nested_sortable
  $('.nested_sortable').each(function(){
    $(this).sortable({
      handle:'.handler',
      placeholder: 'ui-state-highlight',
      update: function(event, ui){
        $(this).children('.block-container').each(function(){
          var index = $(this).parent().children('.block-container').index(this);
          var item_position = $(this).find('input:regex(id,.+_position)');
          item_position.val(index);
        });
      }
    });
  });
});
