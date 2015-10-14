/**
 * Created by Pavel.Lobashov on 14.10.15.
 */
fetch_server_ip = function (server) {
    var ip;
    $.ajax({
        url: '/servers/cloud_server_fetch_ip',
        type: 'GET',
        data: {
            'server': server
        },
        success: function (data) {
            update_ip_value(data['ip']);
        },
        error: function (e) {
            console.log(e.message);
        }
    });
};

update_ip_value = function(value) {
        $("#server_address").val(value);
}

$("#fetch-ip").on("click", function(){
    fetch_server_ip($( "#server_name" ).val());
})