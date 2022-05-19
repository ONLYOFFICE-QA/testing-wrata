/**
 * Created by lobashov-2 on 09.03.17.
 */


window.isServerCreated = function(serverSize) {
    var destroyButton = $("#" + serverSize + ' .destroy');
    return destroyButton.length == 1;
};

window.setServerSize = function(serverSize, size) {
    var serverSizeSelect = $("#" + serverSize + ' .server-size-select');
    serverSizeSelect.val(size);
};

window.getSelectedServerSize = function(serverName) {
    var serverSizeSelect = $("#" + serverName + ' .server-size-select');
    return serverSizeSelect.val();
};


window.disableSelectServerSize = function(serverName) {
    if (isServerCreated(serverName)) {
        $("#" + serverName + ' .server-size-select').attr("disabled", true);
    } else {
        $("#" + serverName + ' .server-size-select').removeAttr("disabled");
    }
};

window.eventForCreateAndDestroyServer = function(serverName) {
    var actionButton = $("#" + serverName + ' .fa-power-off');
    actionButton.on('click', function () {
        var action = actionButton.find('.hidden-tool').text();
        bootbox.confirm('Are you really want to ' + action + ' this server?', function(confirmed) {
            if(confirmed) {
                var serverSize = getSelectedServerSize(serverName);
                createAndDestroyServer(action, serverName, serverSize);
            }
        });
    });
};

window.initEventsForCreateDestroyButtons = function() {
    var servers = serverList();
    servers.forEach(function(element) {
        eventForCreateAndDestroyServer(element);
    });
};

window.createAndDestroyServer = function(action, serverName, serverSize) {
    if (action == 'create') {
        showServerSectionOverlay(serverName, 'Creating...');
        createServer(serverName, serverSize);
    } else {
        showServerSectionOverlay(serverName, 'Destroying...');
        destroyServer(serverName);
    }
    disableSelectServerSize(serverName);
};
window.showServerSectionOverlay = function(server, message) {
    var selector = 'div#' + server + ' .section-overlay';
    $(selector).find('.overlay-text').text(message);
    $(selector).show();
    $("#" + server + ' .fa-power-off').hide();
};
window.hideServerSectionOverlay = function(server) {
    var selector = 'div#' + server + ' .section-overlay';
    $(selector).hide();
    $("#" + server + ' .fa-power-off').show();
};
window.createServer = function(server, size) {
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
};
window.destroyServer = function(server) {
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
};

window.serverList = function() {
    var servers = [];
    $("#servers div.server").each(function(index, element) {
        servers.push(element.id);
    });
    return servers;
};