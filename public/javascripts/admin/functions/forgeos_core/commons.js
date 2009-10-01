function toggleActivate(selector){
  var link = $(selector);
  link.toggleClass('see-on');
  link.toggleClass('see-off');
}

function showObjectsAssociated(){
  $('.plus').bind('click',function(){
    var element=$(this);
    var tr=element.parents('tr');
    tr.toggleClass('open');
  });
}


function get_rails_element_id(element){
  var id = $(element).attr('id').split('_');
  return id[id.length-1];
}

function get_rails_element_ids(list){
  var ids = new Array();
  for(var i=0; i<list.length; i++) {
    ids.push(get_rails_element_id(list[i]))
  }
  return ids;
}

function get_id_from_rails_url(){
  var numbers = document.location.pathname.match(/\d+/);
  return numbers == null ? '' : numbers[0];
}

function jquery_obj_to_str(obj){
  return $('<div>').append($(obj).clone()).remove().html();
}

function add_item_on_add_click() {
  false_id = -1;
  var new_choice = '<li class="block-container">';
  new_choice += '<span class="block-type"> <span class="handler"> <span class="inner" /> </span> </span> </span>';
  new_choice += '<span class="block-name"> <input type="text" id="option_values_name_" size="30" name ="'+object_name+'[option_values_attributes]['+false_id+'][name]" /> ';
  new_choice += '<input type="hidden" class="delete" name="'+object_name+'[option_values_attributes]['+false_id+'][_delete]" />';
  new_choice += '</span> <span class="small-icons red-delete-icon" />';
  new_choice += '</span> <span class="small-icons green-add-icon" />';
  new_choice += '</li>';

  false_id--;
  $('.sortable-choices').append(new_choice);
  return false;
}