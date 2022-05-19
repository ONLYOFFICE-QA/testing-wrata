/**
 * Created by Pavel.Lobashov on 14.10.15.
 */
window.fetch_server_ip = function(server) {
    $.ajax({
        url: '/servers/cloud_server_fetch_ip',
        type: 'GET',
        data: {
            'server': server
        },
        beforeSend: function() {
            showOverlay('Fetching current server IP');
        },
        complete: function() {
            hideOverlay();
        },
        success: function(data) {
            update_ip_value(data.ip);
        },
        error: function(e) {
            console.log(e.message);
        }
    });
};

window.update_ip_value = function(value) {
        $("#server_address").val(value);
};

window.fetchCurrentServerIp = function() {
    fetch_server_ip($( "#server_name" ).val());
};
