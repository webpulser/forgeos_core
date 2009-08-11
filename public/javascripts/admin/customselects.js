var z = 999;

checkExternalClick = function(event)
{
	if ($(event.target).parents('.activedropdown').length === 0)
	{
		$('.activedropdown').removeClass('activedropdown');
		$('.options').hide();
	}
};




$(document).ready(function()
{
	$(document).mousedown(checkExternalClick);

	$('select').each(function() 
	{
		if(!$(this).parent().hasClass('enhanced'))
		{
			targetselect = $(this);
			targetselect.hide();

			// set our target as the parent and mark as such
			var target = targetselect.parent();
			target.addClass('enhanced');

			// prep the target for our new markup
			target.append('<dl class="dropdown '+$(this).val()+'"><dt><a class="dropdown_toggle" href="#"></a></dt><dd><div class="options"><ul></ul></div></dd></dl>');
			target.find('.dropdown').css('zIndex',z);
			z--;

			// we don't want to see it yet
			target.find('.options').hide();

			// parse all options within the select and set indices
			var i = 0;
			targetselect.find('option').each(function() 
			{
				// add the option
				target.find('.options ul').append('<li><a href="#"><span class="value">' + $(this).text() + '</span><span class="hidden index">' + i + '</span></a></li>');

				// check to see if this is what the default should be
				if($(this).attr('selected') == true)
				{
					targetselect.parent().find('a.dropdown_toggle').append('<span></span>').find('span').text($(this).text());
				}
				i++;
			});
		}
	});


	// let's hook our links, ya?
	$('a.dropdown_toggle').live('click', function() 
	{
		var theseOptions = $(this).parent().parent().find('.options');
		if(theseOptions.css('display')=='block')
		{
			$('.activedropdown').removeClass('activedropdown');
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
	$('.options a').live('click', function(e)
	{
		$('.options').hide();

		var enhanced = $(this).parent().parent().parent().parent().parent().parent();
		var realselect = enhanced.find('select');

		// set the proper index
		realselect[0].selectedIndex = $(this).find('span.index').text();
		$(realselect[0]).trigger('onchange'); //Webpulser
		var dropdown=enhanced.find('.dropdown');//Webpulser
		dropdown.removeClass();//Webpulser
		dropdown.addClass("dropdown "+$(realselect[0]).val()+"");//Webpulser
		
		// update the pseudo selected element
		enhanced.find('.dropdown_toggle').empty().append('<span></span>').find('span').text($(this).find('span.value').text());

		return false;
	});
});