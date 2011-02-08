// update position of block-containers
function update_block_container_positions(container){
  $(container).children('.block-container:visible').each(function(){
    var index = $(this).parent().children('.block-container:visible').index(this);
    var item_position = $(this).find('input:regex(id,.+_position)');
    item_position.val(index);
  });
}

function remove_rails_nested_object(selector){
  var line = $(selector);
  var del = line.find('input.destroy');
  if (del.length > 0) {
    del.val(1);
    tmce_unload_children(selector);
    line.hide('explode',{}, 3000);
  } else {
    line.hide('explode',{}, 3000,function(){ $(this).remove(); });
  }
}
