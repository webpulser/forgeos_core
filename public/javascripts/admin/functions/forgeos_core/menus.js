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
