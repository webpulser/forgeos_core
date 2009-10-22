// update position of block-containers
function update_block_container_positions(container){
  $(container).children('.block-container:visible').each(function(){
    var index = $(this).parent().children('.block-container:visible').index(this);
    var item_position = $(this).find('input:regex(id,.+_position)');
    item_position.val(index);
  });
}