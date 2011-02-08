// update position of block-containers
function update_block_container_positions(container){
  $(container).children('.block-container:visible').each(function(){
    var index = $(this).parent().children('.block-container:visible').index(this);
    var item_position = $(this).find('input:regex(id,.+_position)');
    item_position.val(index);
  });
}

function remove_rails_nested_object(selector){
  if ($(selector).find('input.delete').size() > 0) {
    $(selector).find('input.delete').val(1);
    tmce_unload_children(selector);
    $(selector).hide('explode', 500);
  } else {
    $(selector).hide('explode',500).remove();
  }
}
