/**
 * Created by runner on 3/3/14.
 */

function saveDelayedRun(f_type, name, method, start_time, location) {
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
        success: function (data) {
            var trimmed_data = trim_data(data);
            inputChangeEvent(trimmed_data.find('input'));
            eventForCalendar(trimmed_data.find('.date input'));
            trimmed_data.appendTo($('#added-test-lists')).show('fast');
        },
        error: function (e) {
            console.log(e.message);
            failAlert();
        }
    })
}

function saveChangedRun(run_id, method, start_time, location) {
    $.ajax({
        url: 'delay_run/change_run',
        data: {
            id: run_id,
            method:      method,
            start_time:  start_time,
            location:    location
        },
        type: 'POST',
        success: function (data) {

        },
        error: function (e) {
            console.log(e.message);
            failAlert();
        }
    })
}

function eventToSaveDelayedRun(elem) {
    elem.click(function(){
        var row = $(this).parent();
        var f_type = 'test_list';
        var name = row.find('.list-name select').val();
        var start_date = row.find('.date input').val();
        var start_time_h = row.find('.time .hour').val();
        var start_time_m = row.find('.time .min').val();
        var start_time = start_date + ' ' + start_time_h + ':' + start_time_m;
        var location = row.find('.location select').val();
        var method = parseRunMethod(row.find('.run-method select').val(), row.find('.each-time .hour').val(), row.find('.each-time .min').val());
        saveDelayedRun(f_type, name, method, start_time, location);
        row.hide('fast');
    })
}

function eventForCalendar(input) {
    input.pickmeup({
        hide_on_select:  true,
        format:         'd/m/Y'
    });
}

function eventToChangeDelayedRun(elem) {

}

function parseRunMethod(method, hour, min) {
    var run_method = '';
    if (method == 'once') {
        run_method = method
    }else if (method == 'each day') {
        run_method = 'each_24_hours'
    }else if (method == 'each week'){
        run_method = 'each_168_hours'
    }else if (method == 'each time'){
        run_method = 'each';
        if (hour != ''){
            run_method = run_method + '_' + hour + '_hours'
        }
        if (min != ''){
            run_method = run_method + '_' + min + '_minutes'
        }
    }
    return run_method;
}

function addRow() {
    $.ajax({
        url: 'delay_run/add_delayed_row',
        type: 'GET',
        success: function (data) {
            var trimmed_data = trim_data(data);
            eventToShowEachTimeInputs(trimmed_data.find('.run-method select'));
            eventToSaveDelayedRun(trimmed_data.find('.save-delayed-run'));
            eventForCalendar(trimmed_data.find('.date input'));
            $('#test-lists').append(trimmed_data);
        },
        error: function (e) {
            console.log(e.message);
            failAlert();
        }
    })
}

function eventToShowEachTimeInputs(select) {

    select.change(function(){
        if ($(this).val() == 'each time') {
            $(this).parent().next().css('display','inline-block');
        }
        else {
            $(this).parent().next().hide();
        }
    })
}

function inputChangeEvent(input) {
    input.keyup(function () {
        $(this).parent().parent().find('.save-changed-run').animate({opacity: 1}, 500)
    });
}

$(document).ready(function(){

    eventForCalendar($('.date input'));

    $('.add-run-button').click(function() {
        addRow();
    });

    inputChangeEvent($('input'));

});