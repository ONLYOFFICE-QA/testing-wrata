/**
 * Created by Pavel.Lobashov on 15.03.16.
 */

function add_portal_to_list(list_element) {
    bootbox.prompt(
        {
            title: "Enter Portal name",
            callback: function (portal_name) {
                list_element.get(0).add(new Option(portal_name));
                list_element.val(portal_name);
            }
        });

}

function eventForAddNewPortal(elem) {
    elem = elem || $("#portal-list");
    $(elem).change(function () {
        if (elem.val() == 'custom') {
            add_portal_to_list(elem);
        }
    });
}

$(document).ready(function () {
    eventForAddNewPortal($("#portal-list-docs"));
    eventForAddNewPortal($("#portal-list-onlyoffice"));
});