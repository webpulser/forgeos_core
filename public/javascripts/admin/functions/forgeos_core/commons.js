function toggleActivate(selector){
  var link = jQuery(selector);
  link.toggleClass('see-on');
  link.toggleClass('see-off');
}

function showObjectsAssociated(){
  jQuery('.plus').bind('click',function(){
    var element= jQuery(this);
    var tr=element.parents('tr');
    tr.toggleClass('open');
  });
}

function get_rails_element_id(element){
  var id = jQuery(element).attr('id').split('_');
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

function get_rails_attribute_from_name(name){
  var attributes = name.split('[');
  return attributes[attributes.length-1].replace(']','');
}

function jquery_obj_to_str(obj){
  return jQuery('<div>').append(jQuery(obj).clone()).remove().html();
}

function get_json_params_from_url(url){
  var url_params = url.split('?')[1];
  var json_params = {}
  var params;

  // extract params and get them in json
  if (url_params){
    params = url_params ? url_params.split('&') : null;

    // create json params
    if (params){
      for (var i=0; i<params.length; i++){
        var key = params[i].split('=')[0];
        var value = params[i].split('=')[1];
        json_params[key] = value;
      }
    }
  }
  return json_params;
}

function stringify_params_from_json(json_params){
  var params = [];
  JSON.stringify(json_params, function (key, value) {
    if (key && value) {
      params.push(key+'='+value);
    }
    return value;
  });
  return params.join('&');
}

function capitalize(string){
  return string.charAt(0).toUpperCase() + string.slice(1);
}
