var z = 500;

checkExternalClick = function(event)
{
  if ($(event.target).parents('.activedropdown').length === 0)
  {
    jQuery('.activedropdown').removeClass('activedropdown');
    jQuery('.options').hide();
  }
};




function InitCustomSelects()
{
  jQuery(document).mousedown(checkExternalClick);

  jQuery('select').each(function()
  {
    if(!$(this).parent().hasClass('enhanced') && !$(this).parent().hasClass('dataTables_length') && jQuery(this).parents('.no-customselect').length == 0)
    {
      targetselect = jQuery(this);
      targetselect.hide();

      // set our target as the parent and mark as such
      var target = targetselect.parent();
      target.addClass('enhanced');

                        val = jQuery(this).val();

      // prep the target for our new markup
      targetselect.before('<dl class="dropdown '+ val +'"><dt><a class="dropdown_toggle" href="#"></a></dt><dd><div class="options"><ul></ul></div></dd></dl>');
      target.find('.dropdown').css('zIndex',z);
      z--;

      // we don't want to see it yet
      target.find('.options').hide();

      // parse all options within the select and set indices
      var indexId = 0, optgroupId = 0;
        targetselect.find('option').each(function()
        {
          /* Webpulser modifications for optgroups */
          var optGroup=$(this).parent('optgroup');
          //if this option is in an optgroup
          if(optGroup.length>0){
            if($.data(this, "drew")!=1){
              //add the optgroup label in the first target .otions ul and add an id on optgroup
              target.find('.options ul:eq(0)').append('<li class="optgroup"><a href="#"><span class="opt-label">' + jQuery(optGroup).attr('label') + '</span></a><ul id="optgroup_content-'+ optgroupId +'"></ul></li>');

              //add an ul li in this optgroup by its id
              jQuery(optGroup).children('option').each(function(){
                jQuery.data(this, "drew", 1)
                target.find('.options ul #optgroup_content-'+optgroupId+'').append('<li class="option"><a href="#"><span class="value">' + jQuery(this).text() + '</span><span class="hidden index">' + indexId + '</span></a></li>');
                if($(this).attr('selected') == true)
                {
                  targetselect.parent().find('a.dropdown_toggle').append('<span></span>').find('span').text($(this).text());
                }
                indexId++;
              });
              optgroupId++;
            }
          }
          else{
          /* Eo Modifications for optgroups*/
            // add the option
            target.find('.options ul:eq(0)').append('<li class="option"><a href="#"><span class="value">' + jQuery(this).text() + '</span><span class="hidden index">' + indexId + '</span></a></li>');

            // check to see if this is what the default should be
            if($(this).attr('selected') == true)
            {
              targetselect.parent().find('a.dropdown_toggle').append('<span></span>').find('span').text($(this).text());
            }
            indexId++;
          }
        });
      }
  });


  // let's hook our links, ya?
  jQuery('a.dropdown_toggle').live('click', function()
  {
    var theseOptions = jQuery(this).parent().parent().find('.options');
    if(theseOptions.css('display')=='block')
    {
      jQuery('.activedropdown').removeClass('activedropdown');
      theseOptions.hide();
    }
    else
    {
      theseOptions.parent().parent().addClass('activedropdown');
      theseOptions.show();
    }
    return false;
  });

  // bind to clicking a new option value
  jQuery('.options .option a').live('click', function(e)
  {
    jQuery('.options').hide();

    var enhanced = jQuery(this).parents('.enhanced');
    var realselect = enhanced.find('select');

    // set the proper index
    realselect[0].selectedIndex = jQuery(this).find('span.index').text();
    /* Begin of Webpulser code */
    jQuery(realselect[0]).change();
    enhanced.find('.dropdown').attr('class',"dropdown "+$(realselect[0]).val()+"");
    /* End of Webpulser code */
    // update the pseudo selected element
    enhanced.find('.dropdown_toggle').empty().append('<span></span>').find('span').text($(this).find('span.value').text());

    return false;
  });
  // No clicks on optgroup label
  jQuery('.options .optgroup a').live('click', function(e)
  {
    return false;
  });
}

InitCustomSelects();
