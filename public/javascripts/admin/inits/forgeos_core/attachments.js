jQuery(document).ready(function(){
  /*
   * One mouseover media attachment's images
	 * Make the full image appear with high z-index
   **/
  $('.media-image-container').mouseover(function(){
		$(this).addClass('image_on_top');
  });

	$('.media-image-container').mouseout(function(){
		$(this).removeClass('image_on_top');
  });
})
