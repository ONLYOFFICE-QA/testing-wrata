/**
 * Created by lobashov-2 on 7/7/15.
 */

function scrollLogEventToElem(elem) {
    elem.mCustomScrollbar({
            set_width: '580px',
            set_height: '300px',
            scrollButtons: {
                enable: true
            }
        }
    );
}

function showMoreHistoryForServer() {
    var current_showed = $('tbody tr').length;
    var server = $('#server').text();
    $.ajax({
        url: '/server_history/show_more',
        context: this,
        type: 'GET',
        data: {
            'showed': current_showed,
            'server': server
        },
        success: function (data) {
            var trimmed_data = trim_data(data);
            $('tbody').append(trimmed_data);
            scrollLogEventToElem(trimmed_data.find('.log'));
            logUpEventToElem(trimmed_data.find('.log-up'));
            logDownEventToElem(trimmed_data.find('.log-down'));
            openLogInHistoryEventToElem(trimmed_data.find('.history-log'));
            eventToDeleteHistoryLine(trimmed_data.find('.delete-line'));
            eventToSetAnalysedToHistory(trimmed_data.find('.analyse-area'));
            eventToOpenRspecResults(trimmed_data.find('.open-results'));
            eventToOpenMoreOptions(trimmed_data.find('.open-options'));
            eventToShowFullStartOption(trimmed_data.find('.open-full-command'));
            eventToRetest(trimmed_data.find('.retest'));
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown)
        }
    });
}

function showMoreHistoryForClient() {
    var current_showed = $('tbody tr').length;
    var name = $('#client').text();
    $.ajax({
        url: '/client_history/show_more',
        context: this,
        type: 'GET',
        data: {
            'showed': current_showed,
            'name': name
        },
        success: function (data) {
            var trimmed_data = trim_data(data);
            $('tbody').append(trimmed_data);
            scrollLogEventToElem(trimmed_data.find('.log'));
            logUpEventToElem(trimmed_data.find('.log-up'));
            logDownEventToElem(trimmed_data.find('.log-down'));
            openLogInHistoryEventToElem(trimmed_data.find('.history-log'));
            eventToDeleteHistoryLine(trimmed_data.find('.delete-line'));
            eventToSetAnalysedToHistory(trimmed_data.find('.analyse-area'));
            eventToOpenRspecResults(trimmed_data.find('.open-results'));
            eventToOpenMoreOptions(trimmed_data.find('.open-options'));
            eventToShowFullStartOption(trimmed_data.find('.open-full-command'));
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown)
        }
    });
}

function logUpEvent() {
    $('.log-up').on('click', function () {
        $(this).parent().parent().find('.log').trigger('scrollContent', [-0.02]);
    });
}

function logDownEvent() {
    $('.log-down').on('click', function () {
        $(this).parent().parent().find('.log').trigger('scrollContent', [0.02]);
    });
}

function openLogInHistoryEvent() {
    $('.history-log').on('click', function () {
        var log_window = $(this).next();
        var currentDisplay = log_window.css('display');
        if (currentDisplay == 'none') {
            log_window.slideDown();
        }
        else {
            log_window.slideUp();
        }
    });
    $('.log-window').css('display', 'none');
}
