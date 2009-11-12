function toggle_menu_types_overlays(id){
  var overlay_to_turn_off = (id == 'target-link') ? '#external-link' : '#target-link';
  var overlay_to_turn_on = (id == 'target-link') ? '#target-link' : '#external-link';

  if ($(overlay_to_turn_off).is(':visible'))
    $(overlay_to_turn_off).hide();
  $(overlay_to_turn_on).show();
}

function update_menu_link(title, link_span, link, url, link_type, target_id, target_type, data){
  // update link
  if (title.val() == '')
    title.val(data.title);
  link_span.addClass(data.type);
  link.html(data.link_name);
  link.attr('href', data.link_url);

  // update hidden fields
  url.val(data.hidden_url);
  link_type.val(data.hidden_type);
  target_id.val(data.hidden_target_id);
  target_type.val(data.hidden_target_type);
}

function update_menu_span_icon(base_span, span_to_update){
  span_to_update.removeClass('external page product category');
  if (base_span.hasClass('external'))
    span_to_update.addClass('external');
  else if (base_span.hasClass('page'))
    span_to_update.addClass('page');
  else if (base_span.hasClass('product'))
    span_to_update.addClass('product');
  else if (base_span.hasClass('category'))
    span_to_update.addClass('category');
}

// mode is either 'open' or 'closed'
function toggle_menu_link(menu_link, mode){
  var folder = (mode == ('closed')) ? 'file' : 'folder';

  if (!menu_link.hasClass(mode)){
    menu_link.toggleClass('closed');
    menu_link.toggleClass('open');
  }

  if (!menu_link.hasClass(folder)){
    menu_link.toggleClass('file');
    menu_link.toggleClass('folder');
  }
}

// update position for each child of the list and for their children
function update_menu_positions(list){
  $(list).children('li').each(function(){
    var index = $(this).parent().children('li').index(this);
    var position = $(this).find('.menu_link:first').find('input:regex(id,.+_position)');
    var child_list = $(this).children('ul:first');

    position.val(index);

    // update those of its children    
    if (child_list.length > 0)
      update_menu_positions(child_list);
  });
}

// update name, id and parent_id for each child of the list and for their children
function update_menu_names_and_ids(list, base_name, base_id){
  $(list).children('li').each(function(){
    var index = $(this).parent().children('li').index(this);
    var name = base_name + '[' + index + ']';
    var id = base_id + index;

    var parent_id = $(this).parents('li:first').find('input:regex(id,.+_id)')[0];
    var input_parent_id = $(this).find('.menu_link:first').find('input:regex(id,.+_parent_id)');

    var child_list = $(this).children('ul:first');

    // update parent_id
    input_parent_id.val(parent_id ? $(parent_id).val() : '');

    // update name and attribute of each form field
    $(this).find('input, textarea, select').each(function(){
      if (attribute = get_rails_attribute_from_name($(this).attr('name'))){
        $(this).attr('name', name + '[' + attribute + ']');
        $(this).attr('id', id + '_' + attribute);
      }
    });
 
    // update those of its children
    if (child_list.length > 0)
      update_menu_names_and_ids(child_list, name + '[children_attributes]', id + '_children_attributes_');
  });
}