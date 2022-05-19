/**
 * Created by lobashov-2 on 12.05.17.
 */

window.fetch_server_log = function(server_name) {
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
};

window.fill_server_log = function(server_name, log) {
    var log_div = $("#" + server_name + ' .log');
    log_div.text(log);
};

window.empty_server_log = function(server_name) {
    var log_div = $("#" + server_name + ' .log');
    log_div.text('');
};

window.server_log_visible = function(server_name) {
    var log_div = $("#" + server_name + ' .log');
    return log_div.is(':visible');
};