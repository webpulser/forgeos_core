/*
 *Init the steps in right sidebar
 **/
function init_steps(){
  if ($(this).parent().hasClass('disabled')) {
    $(this).next().hide();
  }
}

/*
 *Show/Hide steps content in right sidebar
 **/
function toggle_steps(){
  if (!$(this).parent().hasClass('disabled')) {
    var step = $(this).parent();
    if (step.hasClass('open')) {
      tmce_unload_children(step);
    } else {
      tmce_load_children(step);
    }
    $(this).next().toggle('blind');
    step.toggleClass('open');
  }
  return false;
}