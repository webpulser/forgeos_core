/*
 * Sorting plug-ins for JQuery dataTables
 */

jQuery.fn.dataTableExt.oSort['currency-asc'] = function(a,b) {
  /* Remove the currency sign */
  var x = a.replace(/€/g, "");
  var y = b.replace(/€/g, "");

  /* Parse and return */
  x = parseFloat(x);
  y = parseFloat(y);
  return x - y;
};

jQuery.fn.dataTableExt.oSort['currency-desc'] = function(a,b) {
  /* Remove the currency sign */
  var x = a.replace(/€/g, "");
  var y = b.replace(/€/g, "");

  /* Parse and return */
  x = parseFloat(x);
  y = parseFloat(y);
  return y - x;
};

jQuery.fn.dataTableExt.oApi.fnGetSelectedNodes= function(){
  var aReturn = new Array();
  var aTrs = jQuery(this).dataTableInstance().fnGetNodes();

  for ( var i=0 ; i<aTrs.length ; i++ )
  {
    if ( jQuery(aTrs[i]).hasClass('row_selected') )
    {
      aReturn.push( aTrs[i] );
    }
  }
  return aReturn;
}

jQuery.fn.dataTableExt.oApi.fnUnSelectNodes= function(){
  var aTrs = jQuery(this).dataTableInstance().fnGetSelectedNodes();

  for ( var i=0 ; i<aTrs.length ; i++ )
  {
    jQuery(aTrs[i]).unselect();
  }
}

jQuery.fn.dataTableExt.oApi.fnGetSelectedIndexes= function(){
  var aReturn = new Array();
  var aTrs = jQuery(this).dataTableInstance().fnGetNodes();

  for ( var i=0 ; i<aTrs.length ; i++ )
  {
    if ( jQuery(aTrs[i]).hasClass('row_selected') )
    {
      aReturn.push( i );
    }
  }
  return aReturn;
}

jQuery.fn.dataSlideExt.oApi.fnGetSelectedNodes= function(){
  var aReturn = new Array();
  var aTrs = jQuery(this).dataTableInstance().fnGetNodes();

  for ( var i=0 ; i<aTrs.length ; i++ )
  {
    if ( jQuery(aTrs[i]).hasClass('row_selected') )
    {
      aReturn.push( aTrs[i] );
    }
  }
  return aReturn;
}

jQuery.fn.dataSlideExt.oApi.fnUnSelectNodes= function(){
  var aTrs = jQuery(this).dataTableInstance().fnGetSelectedNodes();

  for ( var i=0 ; i<aTrs.length ; i++ )
  {
    jQuery(aTrs[i]).unselect();
  }
}

jQuery.fn.dataSlideExt.oApi.fnGetSelectedIndexes= function(){
  var aReturn = new Array();
  var aTrs = jQuery(this).dataTableInstance().fnGetNodes();

  for ( var i=0 ; i<aTrs.length ; i++ )
  {
    if ( jQuery(aTrs[i]).hasClass('row_selected') )
    {
      aReturn.push( i );
    }
  }
  return aReturn;
}

jQuery.fn.extend({
  dataTableInstance : function(){
    var element = this;
    oTable = undefined;
    jQuery(oTables).each(function(){
      if (jQuery(this).attr('id') == jQuery(element).attr('id')) {
        oTable = this;
      }
    });
    return oTable;
  },
  select: function(){
    jQuery(this).addClass('row_selected');
    var checkbox = jQuery(this).find('input[type=checkbox]');
    checkbox.attr('checked',1);

    var datatable = jQuery(this).parents('.datatable').dataTableInstance();
    var datable_datas = jQuery(this).parents('.datatable').data('selected_rows');
    var index = jQuery(this).attr('id');
    datable_datas.push(index);
  },
  unselect: function(){
    jQuery(this).removeClass('row_selected');
    var checkbox = jQuery(this).find('input[type=checkbox]');
    checkbox.attr('checked',0);

    var datatable = jQuery(this).parents('.datatable').dataTableInstance();
    var datable_datas = jQuery(this).parents('.datatable').data('selected_rows');
    var index = jQuery(this).attr('id');
    var index_in_table = jQuery.inArray(index, datable_datas);
    datable_datas.splice(index_in_table,1);
  },
  toggleselect: function(){
    if (jQuery(this).hasClass('row_selected')) {
      jQuery(this).unselect();
    } else {
      jQuery(this).select();
    }
  }
});

jQuery.expr[':'].regex = function(elem, index, match) {
   var matchParams = match[3].split(','),
       validLabels = /^(data|css):/,
       attr = {
           method: matchParams[0].match(validLabels) ?
                       matchParams[0].split(':')[0] : 'attr',
           property: matchParams.shift().replace(validLabels,'')
       },
       regexFlags = 'ig',
       regex = new RegExp(matchParams.join('').replace(/^\s+|\s+$/g,''), regexFlags);
   return regex.test(jQuery(elem)[attr.method](attr.property));
}

function removedataTablesRow(selector){
  var current_table = jQuery(selector).parents('table:first').dataTableInstance();
  current_table.fnDeleteRow(
    current_table.fnGetPosition(jQuery(selector).parents('tr:first')[0])
  );
  display_notifications();
}

function DataTablesDrawCallBack(table) {
  InitCustomSelects();
  showObjectsAssociated();
  hide_paginate(table);
  moveDataTablesSearchField();
}

// set id to each row and set it draggable
function DataTablesRowCallBack(nRow, aData, iDisplayIndex){
  var table = jQuery('#'+this.sInstance);
  var div = jQuery(nRow).find(":regex(id,.+_\\d+)");

  if (div.length != 0) {
    div_id = div[0].id;
    row_id = 'row_' + div_id;
    jQuery(nRow).attr('id', row_id);
  }

  if(table.hasClass('draggable_rows')){
    jQuery(nRow).draggable({
      revert: 'invalid',
      cursor: 'move',
      handle: '.handler',
      cursorAt: {top: 15, left: 75},
      helper: function(e){
        var element = jQuery(jQuery(e.currentTarget).find('td a')[0]);
        var title = element.text();
        return '<div class="ui-helper ui-corner-all"><span class="handler"><span class="inner">&nbsp;</span></span>'+title+'</div>'
        },
      start: function(event, ui) {
        jQuery('#page').addClass('sidebar_dragg');
        jQuery(this).addClass('dragging');
      },
      stop: function(event, ui) {
        jQuery('#page').removeClass('sidebar_dragg');
        jQuery(this).removeClass('dragging');
      }
    });
  }

  if (table.hasClass('selectable_rows')){
    if (typeof(table.data('selected_rows')) == 'undefined') {
      table.data('selected_rows',[]);
    }

    var datable_datas = table.data('selected_rows');
    var index = jQuery(nRow).attr('id');
    if (jQuery.inArray(index, datable_datas) < 0) {
      jQuery(nRow).children('td:first').append('<input id="select_'+jQuery(nRow).attr('id')+'" type="checkbox" name="none"/>');
    } else {
      jQuery(nRow).addClass('row_selected');
      jQuery(nRow).children('td:first').append('<input id="select_'+jQuery(nRow).attr('id')+'" type="checkbox" name="none" checked="checked"/>');
    }

    jQuery(nRow).click(function() {
      jQuery(this).toggleselect();
    });

    jQuery(nRow).find('input[type=checkbox]').click(function(){
      jQuery(this).attr('checked',(jQuery(this).is(':checked')?0:1));
    });
  }
  return nRow;
}

function update_current_dataTable_source(selector,source){
  var current_table = jQuery(selector).dataTableInstance() ;
  current_table.fnSettings().sAjaxSource = source;
  current_table.fnDraw();
}

function hide_paginate(dataTables){
  var pagination = jQuery(dataTables.nPaginateList).parents(':first');
  var pages_number = dataTables.nPaginateList.children.length;
  (pages_number>1) ? pagination.show() : pagination.hide();
}

function dataTableSelectRows(selector,callback){
  var current_table = jQuery(selector).dataTableInstance();

  source = current_table.fnSettings().sAjaxSource;
  var ids = []
  jQuery(jQuery(selector).data('selected_rows')).each(function(){
    if (this.split) ids.push(this.split('_').slice(-1));
  });
  current_table.fnSettings().sAjaxSource = source + '&ids=' + ids.join(',');

  current_table.fnSettings().fnDrawCallback = function(){
    var indexes = current_table.fnGetSelectedIndexes();

    callback(current_table,indexes);

    current_table.fnUnSelectNodes();
    current_table.fnSettings().sAjaxSource = source;
    current_table.fnSettings().fnDrawCallback = DataTablesDrawCallBack;
    current_table.fnClearTable();
  }
  current_table.fnDraw();
}

function save_category_sort(type,id_pos){
  if (typeof(type)=='undefined')
    return true;
  var current_table = jQuery('#table').dataTableInstance();
  var url = current_table.fnSettings().sAjaxSource;
  var params = get_json_params_from_url(url);
  var positions = [];
  var nNodes = current_table.fnGetNodes();
  for(i=0; i < nNodes.length; i++) {
    var node = nNodes[i];
    var pos = current_table.fnGetPosition(node);
    positions.push(current_table.fnGetData(pos).slice(id_pos,id_pos+1));
  };
  jQuery.ajax({
    url: '/admin/categories/' + params.category_id,
      data: { authenticity_token: window._forgeos_js_vars.token, format: 'json', 'category[element_ids][]': positions},
      dataType:'text',
      type:'put'
  });
}

function replaceDataTablesSearchField(field_selector,input_selector,_parent){
  var input = jQuery(input_selector);
  var field = jQuery(field_selector);
  if (input.size()  != 0) {
    field.html(input.clone(true));
    field.
      append('<a href="#" class="backgrounds button-ok">OK</a>').
      find('.button-ok').data('parent',_parent).
      live('click',toggle_search_elements_ok);
    input.remove();
  }
}

function moveDataTablesSearchField(){
  replaceDataTablesSearchField(
    '.search-form',
    '#table_wrapper .dataTables_filter',
    ''
  );
  replaceDataTablesSearchField(
    '.search-form-image',
    '#image-table_wrapper .dataTables_filter',
    'image'
  );
  replaceDataTablesSearchField(
    '.search-form-thumbnails',
    '#thumbnail-table_wrapper .dataSlides_filter',
    'thumbnails'
  );
  replaceDataTablesSearchField(
    '.search-form-files',
    '#table-files_wrapper .dataTables_filter',
    'files'
  );
  jQuery('.search-link').live('click',toggle_search_elements);
}
