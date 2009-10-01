jQuery(document).ready(function(){
  $('textarea.mceEditor').each(function(){
    tmceInit('#'+$(this).attr('id'));
  })
});
