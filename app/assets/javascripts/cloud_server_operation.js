/**
 * Created by lobashov-2 on 09.03.17.
 */


function isServerCreated(server_name) {
    var destroyButton = $("#" + server_name + ' .destroy');
    return destroyButton.length == 1
}

function setServerSize(server_name, size) {
    var serverSizeSelect = $("#" + server_name + ' .server-size-select');
    serverSizeSelect.val(size);
}

function disableSelectServerSize(serverName) {
    if (isServerCreated(serverName)) {
        $("#" + serverName + ' .server-size-select').attr("disabled", true);
    } else {
        $("#" + serverName + ' .server-size-select').removeAttr("disabled");
    }
}