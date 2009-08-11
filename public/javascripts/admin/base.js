/* Devs */
function add_rule(name){
  var rule = $('p.'+name+'.pattern').clone().show().removeClass('pattern');
  $('#'+name+'s').append(rule);
  check_remove_icon_status(name);
}
function remove_rule(element,name){
  if (!$(element).hasClass('disabled')) {
    $(element).parent().remove();
    check_remove_icon_status(name);
  }
}

function check_remove_icon_status(name){
  var c = $('#'+name+'s p.'+name);
  var icon = $('#'+name+'s p.'+name+' a.moins')[0];
  if (c.size() == 1) {
    $(icon).addClass('disabled'); 
  } else { 
    $(icon).removeClass('disabled');
  }
}

function change_rule(element, name){
  $(element).parent().replaceWith($('.rule-'+$(element).val().replace(/\s+/g,"")+'.pattern').clone().removeClass('pattern').removeClass('rule-'+$(element).val().replace(/\s+/g,"")).addClass('rule-condition'))
  check_remove_icon_status(name);
}

function change_select_for(element){
  if ($(element).val() != 'Category'){
    $('#rule_builder_target').hide()
    if ($(element).val() == 'Cart'){
      $('#rule-conditions').replaceWith("<div id='rule-conditions'></div>")
      $('#rule-conditions').append($('.rule-Totalitemsquantity.pattern').clone().removeClass('pattern').removeClass('rule-Totalitemsquantity').addClass('rule-condition')) 
    }
    else{
      $('#rule-conditions').replaceWith("<div id='rule-conditions'></div>")
      $('#rule-conditions').append($('.rule-condition.pattern').clone().removeClass('pattern'))
    }
  }
  else{
    $('#rule_builder_target').show()
    $('#rule-conditions').replaceWith("<div id='rule-conditions'></div>")
    $('#rule-conditions').append($('.rule-condition.pattern').clone().removeClass('pattern'))
  }
  check_remove_icon_status('rule-condition')
}

function change_action(element, name){
  $(element).parent().replaceWith($('.action-'+$(element).val().replace(/\s+/g,"")+'.pattern').clone().removeClass('pattern').removeClass('action-'+$(element).val().replace(/\s+/g,"")).addClass('action-condition'))
  check_remove_icon_status(name);
}

function add_cart_rule(){
  $('#rule-conditions').append($('.rule-Totalitemsquantity.pattern').clone().removeClass('pattern').removeClass('rule-Totalitemsquantity').addClass('rule-condition')) 
  check_remove_icon_status('rule-condition')
}

function SkinSelects(){
  $('select').select_skin({ class: 'ui-corner-all'});
}

function toggleActivate(selector){
  var link = $(selector);
  link.toggleClass('see-on');
  link.toggleClass('see-off');
}

/* Jean Charles */
$(function(){
  //init the tree items
  $("#product-tree").tree({
    ui: { theme_path: '/stylesheets/jstree/themes/', theme_name : 'product_category'
  }});
  $('#product-tree').removeClass('tree-default');
  //stretch the sidebar to the content's height
  $("#sidebar").height($("#content").height());

  //init the resizable sidebar
  $("#sidebar").resizable({
    handles:'e',
    containment: '#page',
    maxWidth: 400,
    minWidth: 150
  });

  $("#sidebar").resize( function() { 
    //when resize sidebar have to resize content
    $("#content").width($("#page").width()-($("#sidebar").width()+1));
  });

  //when click on add-product-link open the div below
  $('#add-product-link').bind('click', function() 
  {
    $('#existing-products').toggleClass('open');
    $('#existing-products').toggle('blind');
    //init the slider
    /*$("#myController").jFlow({
      slides: "#mySlides",
      width: "680px",
      height: "85px",
      duration: 400
    });*/
    
  });
  
  //when click on selects resize the otions container to stratch with the select's size
  $('.dropdown').bind('click', function() 
  {
    var divOption=$(this).find('.options');
    divOption.width($(this).width()-15);  
  });
  
  //init the tabulation only if there's some tabs 
  if($("#page").children('ul')[0]!=undefined){
    $("#page").tabs();
  }
  
  
  /* RIGHT SIDEBAR STEPS */ 
  $('a.step-title').bind('click', function() 
  {
    $(this).parent().toggleClass('open');
    $(this).next().toggle('blind');
    return false;

  });
  
  $('#menu .current').append('<span class="after-current"></span>');
  $('#menu .current').prepend('<span class="before-current"></span>');
  
  
  $('#search .search-link').bind('click',function(){
    $('#search .search-form').toggle('blind');
    $('#search').toggleClass('open');
    return false;
   });  

  $('#search .search-form').html($('.dataTables_filter').clone(true));
  $('.top .dataTables_filter').remove();
  
  
});
/*
$(function() {
  $('textarea.tinymce').tinymce({
    // General options
    script_url : '../scripts/tiny_mce/tiny_mce.js',
    mode : "textareas",
    theme : "advanced",
    skin : "forgeos",
    
      // Theme options
    theme_advanced_buttons1 : "styleselect,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,outdent,indent,|,code",
    theme_advanced_buttons2 :"",
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_adavnced_statusbar_location : "bottom",
    theme_advanced_resizing : true
    // Example content CSS (should be your site CSS)
    //content_css : "styles/style.css"
    
  });
});
*/
