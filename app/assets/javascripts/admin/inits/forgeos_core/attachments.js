jQuery(document).ready(function(){
  /*
   * One mouseover media attachment's images
	 * Make the full image appear with high z-index
   **/
  jQuery('.media-image-container').mouseover(function(){
	 jQuery(this).addClass('image_on_top');
  });

 jQuery('.media-image-container').mouseout(function(){
	 jQuery(this).removeClass('image_on_top');
  });
})
