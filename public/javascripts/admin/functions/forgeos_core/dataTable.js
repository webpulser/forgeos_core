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
  var aTrs = $(this).dataTableInstance().fnGetNodes();

  for ( var i=0 ; i<aTrs.length ; i++ )
  {
    if ( $(aTrs[i]).hasClass('row_selected') )
    {
      aReturn.push( aTrs[i] );
    }
  }
  return aReturn;
}

jQuery.fn.dataTableExt.oApi.fnUnSelectNodes= function(){
  var aTrs = $(this).dataTableInstance().fnGetSelectedNodes();

  for ( var i=0 ; i<aTrs.length ; i++ )
  {
    $(aTrs[i]).unselect();
  }
}

jQuery.fn.dataTableExt.oApi.fnGetSelectedIndexes= function(){
  var aReturn = new Array();
  var aTrs = $(this).dataTableInstance().fnGetNodes();

  for ( var i=0 ; i<aTrs.length ; i++ )
  {
    if ( $(aTrs[i]).hasClass('row_selected') )
    {
      aReturn.push( i );
    }
  }
  return aReturn;
}

jQuery.fn.dataSlideExt.oApi.fnGetSelectedNodes= function(){
  var aReturn = new Array();
  var aTrs = $(this).dataTableInstance().fnGetNodes();

  for ( var i=0 ; i<aTrs.length ; i++ )
  {
    if ( $(aTrs[i]).hasClass('row_selected') )
    {
      aReturn.push( aTrs[i] );
    }
  }
  return aReturn;
}

jQuery.fn.dataSlideExt.oApi.fnUnSelectNodes= function(){
  var aTrs = $(this).dataTableInstance().fnGetSelectedNodes();

  for ( var i=0 ; i<aTrs.length ; i++ )
  {
    $(aTrs[i]).unselect();
  }
}

jQuery.fn.dataSlideExt.oApi.fnGetSelectedIndexes= function(){
  var aReturn = new Array();
  var aTrs = $(this).dataTableInstance().fnGetNodes();

  for ( var i=0 ; i<aTrs.length ; i++ )
  {
    if ( $(aTrs[i]).hasClass('row_selected') )
    {
      aReturn.push( i );
    }
  }
  return aReturn;
}

jQuery.fn.extend({
  dataTableInstance : function(){
    var element = this;
    $(oTables).each(function(){
      if ($(this).attr('id') == $(element).attr('id')) {
        oTable = this;
      }
    });
    return oTable;
  },
  select: function(){
    $(this).addClass('row_selected');
    var checkbox = $(this).find('input[type=checkbox]');
    checkbox.attr('checked',1);

    var datatable = $(this).parents('.datatable').dataTableInstance();
    var datable_datas = $(this).parents('.datatable').data('selected_rows');
    var index = $(this).attr('id');
    datable_datas.push(index);
  },
  unselect: function(){
    $(this).removeClass('row_selected');
    var checkbox = $(this).find('input[type=checkbox]');
    checkbox.attr('checked',0);

    var datatable = $(this).parents('.datatable').dataTableInstance();
    var datable_datas = $(this).parents('.datatable').data('selected_rows');
    var index = $(this).attr('id');
    var index_in_table = jQuery.inArray(index, datable_datas);
    datable_datas.splice(index_in_table,1);
  },
  toggleselect: function(){
    if ($(this).hasClass('row_selected')) {
      $(this).unselect();
    } else {
      $(this).select();
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
  var current_table = $(selector).parents('table:first').dataTableInstance();
  current_table.fnDeleteRow(
    current_table.fnGetPosition($(selector).parents('tr:first')[0])
  );
}

function DataTablesDrawCallBack(table) {
  InitCustomSelects();
  showObjectsAssociated();
  display_notifications();
  hide_paginate(table);
}

// set id to each row and set it draggable
function DataTablesRowCallBack(nRow, aData, iDisplayIndex){
  var table = $('#'+this.sInstance);
  var div = $(nRow).find(":regex(id,.+_\\d+)");

  if (div.length != 0) {
    div_id = div[0].id;
    row_id = 'row_' + div_id;
    $(nRow).attr('id', row_id);
  }

  if(table.hasClass('draggable_rows')){
    $(nRow).draggable({
      revert: 'invalid',
      cursor: 'move',
      handle: '.handler',
      cursorAt: {top: 15, left: 75},
      helper: function(e){
        var element = $($(e.currentTarget).find('td a')[0]);
        var title = element.text();
        return '<div class="ui-helper ui-corner-all"><span class="handler"><span class="inner">&nbsp;</span></span>'+title+'</div>'
        },
      start: function(event, ui) {
        $('#page').addClass('sidebar_dragg');
        $(this).addClass('dragging');
      },
      stop: function(event, ui) {
        $('#page').removeClass('sidebar_dragg');
        $(this).removeClass('dragging');
      }
    });
  }

  if (table.hasClass('selectable_rows')){
    if (typeof(table.data('selected_rows')) == 'undefined') {
      table.data('selected_rows',[]);
    }

    var datable_datas = table.data('selected_rows');
    var index = $(nRow).attr('id');
    if (jQuery.inArray(index, datable_datas) < 0) {
      $(nRow).children('td:first').append('<input id="select_'+$(nRow).attr('id')+'" type="checkbox" name="none"/>');
    } else {
      $(nRow).addClass('row_selected');
      $(nRow).children('td:first').append('<input id="select_'+$(nRow).attr('id')+'" type="checkbox" name="none" checked="checked"/>');
    }

    $(nRow).click(function() {
      $(this).toggleselect();
    });

    $(nRow).find('input[type=checkbox]').click(function(){
      $(this).attr('checked',($(this).is(':checked')?0:1));
    });
  }
  return nRow;
}

function update_current_dataTable_source(selector,source){
  var current_table = $(selector).dataTableInstance() ;
  current_table.fnSettings().sAjaxSource = source;
  current_table.fnDraw();
}

function hide_paginate(dataTables){
  var pagination = $(dataTables.nPaginateList).parents(':first');
  var pages_number = dataTables.nPaginateList.children.length;
  (pages_number>1) ? pagination.show() : pagination.hide();
}

function dataTableSelectRows(selector,callback){
  var current_table = $(selector).dataTableInstance();

  source = current_table.fnSettings().sAjaxSource;
  var ids = []
  $($(selector).data('selected_rows')).each(function(){
    if (this.split) ids.push(this.split('_').slice(-1));
  });
  current_table.fnSettings().sAjaxSource = source + '&ids=' + ids.join(',');

  current_table.fnSettings().fnDrawCallback = function(){
    var current_table = $(this).dataTableInstance();
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
  var current_table = $('#table').dataTableInstance();
  var url = current_table.fnSettings().sAjaxSource;
  var params = get_json_params_from_url(url);
  var positions = [];
  var nNodes = current_table.fnGetNodes();
  for(i=0; i < nNodes.length; i++) {
    var node = nNodes[i];
    var pos = current_table.fnGetPosition(node);
    positions.push(current_table.fnGetData(pos).slice(id_pos,id_pos+1));
  };
  $.ajax({
    url: '/admin/categories/' + params.category_id,
      data: { authenticity_token: AUTH_TOKEN, format: 'json', 'category[element_ids][]': positions},
      dataType:'text',
      type:'put'
  });
}
