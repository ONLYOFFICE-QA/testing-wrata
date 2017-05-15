/**
 * Created by lobashov-2 on 12.05.17.
 */

function fetch_server_log(server_name) {
    $.ajax({
        url: 'servers/log',
        data: { server: server_name },
        async: false,
        type: 'GET',
        success: function(data) {
            fill_server_log(server_name, data);
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
}

function fill_server_log(server_name, log) {
    var log_div = $("#" + server_name + ' .log');
    log_div.text(log);
}

function empty_server_log(server_name) {
    var log_div = $("#" + server_name + ' .log');
    log_div.text('');
}

function server_log_visible(server_name) {
    var log_div = $("#" + server_name + ' .log');
    return log_div.is(':visible');
}