/**
 * Created by lobashov-2 on 09.03.17.
 */


function isServerCreated(droplet_name) {
    var destroyButton = $("#" + droplet_name + ' .destroy');
    return destroyButton.length == 1
}

function disableSelectServerSize(droplet_name) {
    if (isServerCreated(droplet_name)) {
        $("#" + droplet_name + ' .droplet-size-select').attr("disabled", true);
    } else {
        $("#" + droplet_name + ' .droplet-size-select').removeAttr("disabled");
    }
}