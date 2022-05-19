/**
 * Created by runner on 3/3/14.
 */

window.eventForOpenDelayRuns = function(elem) {
    elem.on('click', function(){
        openDelayRuns();
    });
};

window.openDelayRuns = function() {
    $.ajax({
        url: '/delay_run',
        type: 'GET',
        success: function (data) {
            showPopup();
            var trimmed_data = trim_data(data);
            delayRunsEvents(trimmed_data);
            $('.popup-window').html(trimmed_data);
        }
    });
};

window.saveDelayedRun = function(name, method, start_time, location) {
    $.ajax({
        url: 'delay_run/add_run',
        data: {
            method:      method,
            start_time:  start_time,
            name:        name,
            location:    location
        },
        type: 'POST',
        success: function (data) {
            var trimmed_data = trim_data(data);
            dataChangeEvent(trimmed_data.find('input'));
            dataChangeEvent(trimmed_data.find('select'));
            dataChangeEvent(trimmed_data.find('.date input'));
            eventForCalendar(trimmed_data.find('.date input'));
            eventToChangeDelayedRun(trimmed_data.find('.save-changed-run'));
            eventToDeleteDelayedRun(trimmed_data.find('.delete-run'));
            trimmed_data.appendTo($('#added-test-lists')).fadeIn('slow');
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
};

window.saveChangedRun = function(run_id, method, start_time, location) {
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
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
};

window.deleteRun = function(run_id) {
    $.ajax({
        url: 'delay_run/delete_run',
        data: {
            id: run_id
        },
        type: 'POST',
        success: function (data) {
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
};

window.eventToChangeDelayedRun = function(elem) {
    elem.click(function(){
        var row = $(this).parent();
        var id = row.attr('data-id');
        var start_date = row.find('.date input').val();
        var start_time_h = row.find('.time .hour').val();
        var start_time_m = row.find('.time .min').val();
        var start_time = start_date + ' ' + start_time_h + ':' + start_time_m;
        var location = row.find('.location select').val();
        var method = parseRunMethod(row.find('.run-method input').val(), row.find('.each-time .hour').val(), row.find('.each-time .min').val());
        saveChangedRun(id, method, start_time, location);
        $(this).find('i').fadeOut('slow');
    });
};

window.eventToSaveDelayedRun = function(elem) {
    elem.click(function(){
        var row = $(this).parent();
        var name = row.find('.list-name select').val();
        var start_date = row.find('.date input').val();
        var start_time_h = row.find('.time .hour').val();
        var start_time_m = row.find('.time .min').val();
        var start_time = start_date + ' ' + start_time_h + ':' + start_time_m;
        var location = row.find('.location select').val();
        var method = parseRunMethod(row.find('.run-method select').val(), row.find('.each-time .hour').val(), row.find('.each-time .min').val());
        saveDelayedRun(name, method, start_time, location);
        row.fadeOut('slow');
    });
};

window.eventToDeleteDelayedRun = function(elem) {
    elem.click(function(){
        var row = $(this).parent();
        var id = row.attr('data-id');
        deleteRun(id);
        row.fadeOut('slow', function(){
            $(this).remove();
        });
    });
};

window.eventForCalendar = function(input) {
    input.pickmeup({
        hide_on_select:  true,
        format:         'd/m/Y'
    });
};

window.parseRunMethod = function(method, hour, min) {
    var run_method = '';
    if (method == 'once') {
        run_method = method;
    }else if (method == 'each day') {
        run_method = 'each_24_hours';
    }else if (method == 'each week'){
        run_method = 'each_168_hours';
    }else if (method == 'each time'){
        run_method = 'each';
        if (hour !== ''){
            run_method = run_method + '_' + hour + '_hours';
        }
        if (min !== ''){
            run_method = run_method + '_' + min + '_minutes';
        }
    }
    return run_method;
};

window.addRow = function() {
    $.ajax({
        url: 'delay_run/add_delayed_row',
        type: 'GET',
        success: function (data) {
            if (data.errors === undefined) {
                var trimmed_data = trim_data(data);
                eventToShowEachTimeInputs(trimmed_data.find('.run-method select'));
                eventToSaveDelayedRun(trimmed_data.find('.save-delayed-run'));
                eventForCalendar(trimmed_data.find('.date input'));
                eventToDeleteRow(trimmed_data.find('.delete-row'));
                trimmed_data.appendTo($('#test-lists')).fadeIn('slow');
            } else {
                showInfoAlert(data.errors);
            }
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
};

window.eventToShowEachTimeInputs = function(select) {

    select.change(function(){
        if ($(this).val() == 'each time') {
            $(this).parent().next().css('display','inline-block');
        }
        else {
            $(this).parent().next().fadeOut();
        }
    });
};

window.eventToDeleteRow = function(elem) {
    elem.on('click', function(){
        $(this).parent().fadeOut('slow', function(){
            $(this).remove();
        });
    });
};

window.eventToAddRow = function(elem) {
    elem.on('click', function() {
        addRow();
    });
};

window.dataChangeEvent = function(elem) {
    elem.keyup(function () {
        $(this).parent().parent().find('.save-changed-run i').fadeIn();
    });
    elem.change(function () {
        $(this).parent().parent().find('.save-changed-run i').fadeIn();
    });
};

window.delayRunsEvents = function(trimmed_data) {
    eventForCalendar(trimmed_data.find('.date input'));
    eventToChangeDelayedRun(trimmed_data.find('.save-changed-run'));
    eventToDeleteDelayedRun(trimmed_data.find('.delete-run'));
    dataChangeEvent(trimmed_data.find('input'));
    dataChangeEvent(trimmed_data.find('select'));
    dataChangeEvent(trimmed_data.find('.date input'));
    eventToAddRow(trimmed_data.find('.add-run-button'));
};

$(document).ready(function(){
    eventForOpenDelayRuns($('#delay-runs'));
});