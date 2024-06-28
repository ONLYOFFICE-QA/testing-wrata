/**
 * Created by Pavel.Lobashov on 15.03.16.
 */

window.add_portal_to_list = function(list_element) {
    var defaultValue = "http://";
    bootbox.prompt(
        {
            title: "Enter Portal name",
            value: defaultValue,
            callback: function (portal_name) {
                if (portal_name === null ||
                    portal_name === defaultValue ||
                    portal_name === '') {
                    return null;
                }
                list_element.get(0).add(new Option(portal_name));
                list_element.val(portal_name);
            }
        });

};

window.eventForAddNewPortal = function(elem) {
    elem = elem || $("#portal-list");
    $(elem).change(function () {
        if (elem.val() == 'custom') {
            add_portal_to_list(elem);
        }
    });
};