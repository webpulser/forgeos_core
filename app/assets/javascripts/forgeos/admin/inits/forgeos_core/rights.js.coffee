jQuery(document).ready ->
  jQuery(".create-right").live "click", ->
    new_row = "<tr id=\"new_row\" class=\"even ui-draggable\">" + "<td><div class=\"small-icons right-ico\">&nbsp;</div></td>" + "<td><input type=\"text\" name=\"right[name]\" size=\"15\" /></td>" + "<td><input type=\"text\" name=\"right[controller_name]\" size=\"15\" /></td>" + "<td><input type=\"text\" name=\"right[action_name]\" size=\"15\" /></td>" + "<td>" + "<a href=\"#\" onclick=\"jQuery('#form_right').trigger('onsubmit'); return false;\"><span class=\"small-icons save\">&nbsp;</span></a>" + "<a href=\"#\" onclick=\"discard(); return false;\"><span class=\"small-icons cancel\">&nbsp;</span></a>" + "</td>" + "</tr>"
    jQuery("#table").prepend new_row
    jQuery("#table").wrap "<form action=\"" + window._forgeos_js_vars.mount_paths.core + "/admin/rights/create\" id=\"form_right\" method=\"POST\" onsubmit=\"" + form_ajax_right(window._forgeos_js_vars.mount_paths.core + "/admin/rights/create", "post") + "\"></form>"
    disable_links()
    false

  jQuery(".edit-right").live "click", ->
    row = jQuery(this).parents("tr")
    row_id = row.attr("id")
    right_id = get_rails_element_id(row)
    cell_name = row.children().get(1)
    cell_controller = row.children().get(2)
    cell_action = row.children().get(3)
    cell_actions = jQuery(this).parent()
    cell_name_value = jQuery(cell_name).children("div").html()
    cell_controller_value = jQuery(cell_controller).html()
    cell_action_value = jQuery(cell_action).html()
    jQuery("table").wrap "<form action=\"" + window._forgeos_js_vars.mount_paths.core + "/admin/rights/" + right_id + "\" id=\"form_right\" method=\"PUT\" onsubmit=\"" + form_ajax_right(window._forgeos_js_vars.mount_paths.core + "/admin/rights/" + right_id, "put") + "\"></form>"
    new_row = "<tr id=\"new_row\" class=\"odd ui-draggable\">"
    new_row += "<td><div class=\"small-icons right-ico\">&nbsp;</div></td>"
    new_row += "<td><input type=\"text\" value=\"" + cell_name_value + "\" name=\"right[name]\" size=\"15\"/></td>"
    new_row += "<td><input type=\"text\" value=\"" + cell_controller_value + "\" name=\"right[controller_name]\" size=\"15\"/></td>"
    new_row += "<td><input type=\"text\" value=\"" + cell_action_value + "\" name=\"right[action_name]\" size=\"15\"/></td>"
    new_row += "<td>"
    new_row += "<a href=\"#\" onclick=\"jQuery('#form_right').trigger('onsubmit'); return false;\"><span class=\"small-icons save\">&nbsp;</span></a>"
    new_row += "<a href=\"#\" onclick=\"discard(); row.show(); return false;\"><span class=\"small-icons cancel\">&nbsp;</span></a>"
    new_row += "</td>"
    new_row += "</tr>"
    row.hide()
    row.after new_row
    disable_links()

  jQuery(".duplicate-right").live "click", ->
    row = jQuery(this).parents("tr")
    cell_name = row.children().get(1)
    cell_controller = row.children().get(2)
    cell_action = row.children().get(3)
    cell_actions = jQuery(this).parent()
    cell_name_value = jQuery(cell_name).children("div").html()
    cell_controller_value = jQuery(cell_controller).html()
    cell_action_value = jQuery(cell_action).html()
    jQuery("#table").wrap "<form action=\"" + window._forgeos_js_vars.mount_paths.core + "/admin/rights/create\" id=\"form_right\" method=\"POST\" onsubmit=\"" + form_ajax_right(window._forgeos_js_vars.mount_paths.core + "/admin/rights/create", "post") + "\"></form>"
    new_row = "<tr id=\"new_row\" class=\"" + row.attr("class") + " ui-draggable\">"
    new_row += "<td><div class=\"small-icons right-ico\">&nbsp;</div></td>"
    new_row += "<td><input type=\"text\" value=\"" + cell_name_value + "\" name=\"right[name]\" size=\"15\" /></td>"
    new_row += "<td><input type=\"text\" value=\"" + cell_controller_value + "\" name=\"right[controller_name]\" size=\"15\" /></td>"
    new_row += "<td><input type=\"text\" value=\"" + cell_action_value + "\" name=\"right[action_name]\" size=\"15\" /></td>"
    new_row += "<td>"
    new_row += "<a href=\"#\" onclick=\"jQuery('#form_right').trigger('onsubmit'); return false;\"><span class=\"small-icons save\">&nbsp;</span></a>"
    new_row += "<a href=\"#\" onclick=\"discard(); return false;\"><span class=\"small-icons cancel\">&nbsp;</span></a>"
    new_row += "</td>"
    new_row += "</tr>"
    row.after new_row
    disable_links()
