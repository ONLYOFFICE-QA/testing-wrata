/**
 * Created by Pavel.Lobashov on 15.03.16.
 */


function enter_custom_portal_name() {
    return prompt("Please enter your custom portal", "http:// /");
}

function add_portal_to_list(list_element) {
    var portal_name = enter_custom_portal_name();
    list_element.get(0).add(new Option(portal_name));
    list_element.val(portal_name);
}

function eventForAddNewPortal(elem) {
    elem = elem || $("#portal-list");
    $( elem ).change(function() {
        if (elem.val() == 'custom')
        {
            add_portal_to_list(elem);
        }
    });
}

$(document).ready(function(){
    eventForAddNewPortal();
});