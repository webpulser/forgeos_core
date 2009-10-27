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
    $(aTrs[i]).removeClass('row_selected');
    $(aTrs[i]).find("input[type='checkbox']").attr('checked',0);
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
  oTable.fnDeleteRow(
      oTable.fnGetPosition($(selector).parents('tr')[0])
  );
}

function DataTablesDrawCallBack() {
  InitCustomSelects();
  showObjectsAssociated();
  display_notifications();
  hide_paginate();
}

// set id to each row and set it draggable
function DataTablesRowCallBack(nRow, aData, iDisplayIndex){
  div = $(nRow).children('td').children('div');
  if (div.length != 0) {
    div_id = div[0].id;
    row_id = 'row_' + div_id;
    $(nRow).attr('id', row_id);
  }

  if($(oTables[current_table_index]).hasClass('draggable_rows')){
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

  if ($(oTables[current_table_index]).hasClass('selectable_rows')){
    $(nRow).children('td:first').prepend('<input id="select_'+$(nRow).attr('id')+'" type="checkbox" name="none"/>');
    $(nRow).click(function() {
      $(this).toggleClass('row_selected');
      var checkbox = $(this).find('input[type=checkbox]');
      checkbox.attr('checked',(checkbox.is(':checked')?0:1));
    });
    $(nRow).find('input[type=checkbox]').click(function(){
      $(this).attr('checked',($(this).is(':checked')?0:1));
    });
  }
  return nRow;
}

function update_current_dataTable_source(source){
  oTables[current_table_index].fnSettings().sAjaxSource = source;
  oTables[current_table_index].fnDraw();
}

function hide_paginate(){
  var paginate_childrens = oTables[current_table_index].fnSettings().nPaginateList.children;
   
  if(paginate_childrens.length>1){
    $('.dataTables_paginate.paging_full_numbers').show()
  } 
	else{
		$('.dataTables_paginate.paging_full_numbers').hide()
	}
}
