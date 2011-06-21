// update position of block-containers
function update_block_container_positions(container){
  jQuery(container).children('.block-container:visible').each(function(){
    var index = jQuery(this).parent().children('.block-container:visible').index(this);
    var item_position = jQuery(this).find('input:regex(id,.+_position)');
    item_position.val(index);
  });
}

function remove_rails_nested_object(selector){
  var line = jQuery(selector);
  var del = line.find('input.destroy');
  if (del.length > 0) {
    del.val(1);
    tmce_unload_children(selector);
    line.hide('explode',{}, 3000);
  } else {
    line.hide('explode',{}, 3000,function(){ jQuery(this).remove(); });
  }
}
