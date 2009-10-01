function change_rule(element, name){
  var selected = $(element).val().replace(/\s+/g,"")
  //alert(selected)
  var condition = $(element).parent().parent()
  condition.html('')
  condition.append($('.rule-'+selected+'.pattern').html())
  //condition.append($('.rule-'+selected+'.pattern').clone().removeClass('pattern'))
  //$(element).parent().replaceWith($('.rule-'+$(element).val().replace(/\s+/g,"")+'.pattern').clone().removeClass('pattern').removeClass('rule-'+$(element).val().replace(/\s+/g,"")).addClass('rule-condition'))
  //check_remove_icon_status(name);
  check_icons('rule-conditions');
  check_icons('end-conditions');
  rezindex();
}

function rezindex(){
 var nb=990
 $('.dropdown').each(function(){
   $(this).css('zIndex',nb);
   nb--;
 });
}

function change_select_for(element){
  if ($(element).val() != 'Category'){
    $('#rule_builder_target').parent().hide()
    if ($(element).val() == 'Cart'){
      $('#rule-conditions').html('')
      $('#rule-conditions').append("<div class='condition'>"+$('.rule-Totalitemsquantity.pattern').html()+'</div>')

      // then actions only => Offer a product and Offer free delivery

      $('#action-conditions').html('')
      $('#action-conditions').append("<div class='condition'>"+$('.action-Offeraproduct-cart.pattern').html()+'</div>')

    }
    else{
      if ($('#rule_builder_for :selected').text() == 'Product in Cart'){

        $('#rule-conditions').replaceWith("<div id='rule-conditions'></div>")
        $('#rule-conditions').append($('.rule-condition.pattern').clone().removeClass('pattern'))

        $('#action-conditions').html('')
        $('#action-conditions').append($('.action-Discountpricethisproduct-productincart.pattern').clone().removeClass('pattern').removeClass('action-Discountpricethisproduct-productincart').addClass('action-condition'))
      } else {
        $('#rule-conditions').replaceWith("<div id='rule-conditions'></div>")
        $('#rule-conditions').append($('.rule-condition.pattern').clone().removeClass('pattern'))

        $('#action-conditions').html('')
        $('#action-conditions').append($('.action-Discountpricethisproduct-productinshop.pattern').clone().removeClass('pattern').removeClass('action-Discountpricethisproduct-productinshop').addClass('action-condition'))

      }
    }
  }
  else{
    $('#rule_builder_target').parent().show()
    $('#rule-conditions').replaceWith("<div id='rule-conditions'></div>")
    $('#rule-conditions').append($('.rule-condition.pattern').clone().removeClass('pattern'))

    $('#action-conditions').html('')
    $('#action-conditions').append($('.action-Discountpricethisproduct-category.pattern').clone().removeClass('pattern').removeClass('action-Discountpricethisproduct-category').addClass('action-condition'))
  }
  rezindex();
  //check_remove_icon_status('rule-condition')
  //check_remove_icon_status('action-condition')
  check_icons('action-conditions')
  check_icons('rule-conditions')
  check_icons('end-conditions');
}