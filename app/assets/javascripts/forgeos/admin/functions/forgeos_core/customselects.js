function InitCustomSelects() {
  var z = 500;

  jQuery(document).mousedown(function(event) {
    if (jQuery(event.target).parents('.activedropdown').length === 0) {
      jQuery('.activedropdown').removeClass('activedropdown');
      jQuery('.options').hide();
    }
  });


  jQuery('select.customize').each(function() {
    if(!jQuery(this).parent().hasClass('enhanced') && !jQuery(this).parent().hasClass('dataTables_length')) {
      var targetselect = jQuery(this);

      // set our target as the parent and mark as such
      var target = targetselect.parent();
      targetselect.hide();

      var val = targetselect.val();

      // prep the target for our new markup
      targetselect.before(
        "<dl class=\"dropdown "+ val +"\">\
        <dt><a class=\"dropdown_toggle\" href=\"#\"></a></dt>\
        <dd><div class=\"options\" style=\"display: none;\"><ul></ul></div></dd>\
        </dl>"
      );
      target.addClass('enhanced').find('.dropdown').css('zIndex',z);
      z--;

      // parse all options within the select and set indices
      var indexId = 0, optgroupId = 0;

      targetselect.find('option').each(function() {
        /* Webpulser modifications for optgroups */
        var option = jQuery(this);
        var optGroup = option.parents('optgroup:first');
        //if this option is in an optgroup
        if(optGroup.length > 0){
          if(option.data("drew")!=1){
            //add the optgroup label in the first target .options ul and add an id on optgroup
            target.find('.options ul:eq(0)').append(
              "<li class=\"optgroup\">\
                <a href=\"#\"><span class=\"opt-label\">" +
                  jQuery(optGroup).attr('label') +
                "</span></a>\
                <ul id=\"optgroup_content-"+ optgroupId +"\"></ul>\
              </li>"
            );

            //add an ul li in this optgroup by its id
            jQuery(optGroup).children('option').each(function(){
              var group = jQuery(this);
              group.data("drew", 1);
              target.find('.options ul #optgroup_content-'+optgroupId+'').append('<li class="option"><a href="#"><span class="value">' + group.text() + '</span><span class="hidden index">' + indexId + '</span></a></li>');
              if (group.is(':selected')) {
                targetselect.parents('dl').find('a.dropdown_toggle').
                append('<span>'+group.text()+'</span>');
              }
              indexId++;
            });
            optgroupId++;
          }
        } else {
        /* Eo Modifications for optgroups*/
          // add the option
          target.find('.options ul:eq(0)').append(
            "<li class=\"option\">\
              <a href=\"#\"><span class=\"value\">" +
                option.text() +
              "</span><span class=\"hidden index\">" +
                indexId +
              "</span></a>\
            </li>"
          );

          // check to see if this is what the default should be
          if (option.is(':selected')) {
            targetselect.siblings('dl').find('a.dropdown_toggle').
            append('<span>'+option.text()+'</span>');
          }
          indexId++;
        }
      });
    }
  });


  // let's hook our links, ya?
  jQuery('a.dropdown_toggle').live('click', function(e) {
    e.preventDefault();
    var theseOptions = jQuery(this).parent().parent().find('.options');
    if(theseOptions.css('display')=='block') {
      jQuery('.activedropdown').removeClass('activedropdown');
      theseOptions.hide();
    } else {
      theseOptions.show().parent().parent().addClass('activedropdown');
    }
    return false;
  });

  // bind to clicking a new option value
  jQuery('.options .option a').live('click', function(e) {
    e.preventDefault();
    var option = jQuery(this);
    jQuery('.options').hide();

    var enhanced = option.parents('.enhanced');
    var realselect = enhanced.find('select:first');

    // set the proper index
    realselect.selectedIndex = option.find('span.index').text();
    realselect.find('option').attr('selected', false);
    realselect.find('option:eq('+option.find('span.index').text()+')').attr('selected', true);
    /* Begin of Webpulser code */
    realselect.trigger('change');
    enhanced.find('.dropdown').addClass(realselect.val());
    /* End of Webpulser code */
    // update the pseudo selected element
    enhanced.find('.dropdown_toggle').
    html('<span>'+option.find('span.value').text()+'</span>');

    return false;
  });
  // No clicks on optgroup label
  jQuery('.options .optgroup a').live('click', function(e) {
    e.preventDefault();
    return false;
  });
}
