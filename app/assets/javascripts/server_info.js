/**
 * Created by lobashov-2 on 14.10.15.
 */
fetch_server_ip = function (server) {
    $.ajax({
        url: 'servers/cloud_server_create',
        type: 'GET',
        async: false,
        data: {
            'server': server
        },
        success: function (data) {
            alert(data)
        },
        error: function (e) {
            console.log(e.message);
        }
    });
};

$("#fetch-ip").on("click",function(){
    fetch_server_ip($( "#server_name" ).val());
});