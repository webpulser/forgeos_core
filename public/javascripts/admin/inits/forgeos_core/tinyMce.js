jQuery(document).ready(function(){
  jQuery('textarea.mceEditor').each(function(){
    tmceInit('#'+jQuery(this).attr('id'));
  })
});
