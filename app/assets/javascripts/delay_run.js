/**
 * Created by runner on 3/3/14.
 */

function sendWork(f_type, name, method, start_time, location) {
    $.ajax({
        url: 'delay_run/add_run',
        data: {
            method:      method,
            f_type:      f_type,
            start_time:  start_time,
            name:        name,
            location:    location
        },
        type: 'POST',
        success: function () {
            alert('Job gon')
        },
        error: function (e) {
            console.log(e.message);
            failAlert();
        }
    })
}

function testDB() {
    $.ajax({
        url: '/delay_run/history_shit',
        type: 'POST',
        success: function () {
        },
        error: function (e) {
            console.log(e.message);
            failAlert();
        }
    })
}

$(document).ready(function(){

    $('.date input').pickmeup({
        hide_on_select:  true,
        format:         'd/m/Y'
    });

});