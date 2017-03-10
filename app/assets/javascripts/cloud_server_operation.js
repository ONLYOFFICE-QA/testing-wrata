/**
 * Created by lobashov-2 on 09.03.17.
 */


function isServerCreated(serverSize) {
    var destroyButton = $("#" + serverSize + ' .destroy');
    return destroyButton.length == 1
}

function setServerSize(serverSize, size) {
    var serverSizeSelect = $("#" + serverSize + ' .server-size-select');
    serverSizeSelect.val(size);
}

function getSelectedServerSize(serverName) {
    var serverSizeSelect = $("#" + serverName + ' .server-size-select');
    return serverSizeSelect.val();
}


function disableSelectServerSize(serverName) {
    if (isServerCreated(serverName)) {
        $("#" + serverName + ' .server-size-select').attr("disabled", true);
    } else {
        $("#" + serverName + ' .server-size-select').removeAttr("disabled");
    }
}

function eventForCreateAndDestroyServer(serverName) {
    var actionButton = $("#" + serverName + ' .glyphicon-off');
    actionButton.on('click', function () {
        var action = actionButton.find('.hidden-tool').text();
        var result = confirm('Are you really want to ' + action + ' this server?');
        if (result) {
            var serverSize = getSelectedServerSize(serverName);
            createAndDestroyServer(action, serverName, serverSize);
        }
    });
}

function initEventsForCreateDestroyButtons() {
    var servers = serverList();
    servers.forEach(function(element) {
        eventForCreateAndDestroyServer(element);
    });
}

function createAndDestroyServer(action, serverName, serverSize) {
    if (action == 'create') {
        showServerSectionOverlay(serverName, 'Creating...');
        createServer(serverName, serverSize);
    } else {
        showServerSectionOverlay(serverName, 'Destroying...');
        destroyServer(serverName);
    }
    disableSelectServerSize(serverName);
}
function showServerSectionOverlay(server, message) {
    var selector = 'div#' + server + ' .section-overlay';
    $(selector).find('.overlay-text').text(message);
    $(selector).show();
}
function hideServerSectionOverlay(server) {
    var selector = 'div#' + server + ' .section-overlay';
    $(selector).hide();
}
function createServer(server, size) {
    $.ajax({
        url: 'servers/cloud_server_create',
        type: 'POST',
        async: true,
        data: {
            'server': server,
            'size': size
        },
        success: function () {
            hideServerSectionOverlay(server);
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
}
function destroyServer(server) {
    $.ajax({
        url: 'servers/cloud_server_destroy',
        type: 'POST',
        async: true,
        data: {
            'server': server
        },
        beforeSend: function () {
            unbookServer(server);
        },
        success: function () {
            hideServerSectionOverlay(server);
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
}

function serverList() {
    var servers = [];
    $("#servers div.server").each(function(index, element) {
        servers.push(element.id);
    });
    return servers;
}