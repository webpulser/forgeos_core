jQuery(document).ready(function(){
  // init delayedObserver to generate url from name
  $('input:regex(id,.+_(name|title))').change(function() {
     var value = $(this).val();
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
       url: '/admin/products/url'
     });
  });

  $('textarea:regex(id,.+_description)').change(function() {
     var value = $(this).text();
     var element = $('textarea:regex(id,.+_meta_info_attributes_description)');
     if (element.is(':visible')){
       element.val(value);
     }
  });
});
