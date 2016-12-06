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
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
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
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
}

function clearHistoryOnServer(server_name) {
    $.ajax({
        url: '/servers/clear_history',
        async: false,
        type: 'POST',
        data: {
            'server': server_name
        },
        beforeSend: function () {
            disableClearHistoryButton();
            showOverlay('Deleting...');
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        },
        complete: function() {
            location.reload();
        }
    });
}

function logUpEventToElem(elem) {
    elem.on('click', function () {
        $(this).parent().parent().find('.log').trigger('scrollContent', [-0.02]);
    });
}

function logDownEventToElem(elem) {
    elem.on('click', function () {
        $(this).parent().parent().find('.log').trigger('scrollContent', [0.02]);
    });
}

function openLogInHistoryEventToElem(elem) {
    elem.on('click', function () {
        var log_window = $(this).next();
        var currentDisplay = log_window.css('display');
        if (currentDisplay == 'none') {
            log_window.slideDown();
        }
        else {
            log_window.slideUp();
        }
    });
    elem.next().css('display', 'none');
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

function eventToDeleteHistoryLine(elem) {
    elem.on('click', function () {
        var clicked = $(this);
        $.ajax({
            url: clicked.attr('delete-data'),
            async: false,
            type: 'DELETE',
            success: function () {
                var tr = clicked.parent().parent();
                tr.hide('slow', function () {
                    tr.remove();
                });
            },
            error: function (xhr, type, errorThrown) {
                ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
            }
        });
    });
}

function eventToRetest(elem) {
    elem.on('click', function () {
        var clicked = $(this);
        $.ajax({
            url: '/queue/retest',
            data: {
                test_path: clicked.attr('data-path'),
                tm_branch: clicked.attr('data-tm-branch'),
                doc_branch: clicked.attr('data-doc-branch'),
                location: clicked.attr('data-location')
            },
            async: false,
            type: 'POST',
            success: function () {
                showInfoAlert('Test was added in your queue.');
            },
            error: function (xhr, type, errorThrown) {
                ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
            }
        });
    });
}

function eventToSetAnalysedToHistory(elem) {
    elem.on('click', function () {
        var clicked = $(this);
        $.ajax({
            url: '/histories/set_analysed',
            async: false,
            type: 'POST',
            data: {
                'id': clicked.attr('data-id')
            },
            success: function () {
                var el = clicked.parent();
                clearElementInside(el);
                el.append($("<i class='glyphicon glyphicon-ok icon-green'></i>"));
            },
            error: function (xhr, type, errorThrown) {
                ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
            }
        });

    });
}

function eventToOpenMoreOptions(elem) {
    elem.on('click', function () {
        var more_options = $(this).next('.more-options');
        var cur_display = more_options.css('display');
        if (cur_display == 'none') {
            more_options.slideDown();
        } else {
            more_options.slideUp();
        }
    });
}

function eventToShowFullStartOption(elem) {
    elem.click(
        function () {
            var to_show = $(this.parentNode).find('.full-command');
            $(to_show).fadeToggle();
        });
}

function eventToClearHistoryOnServer(elem) {
    elem.on('click', function () {
        var server_name = $('#server').text();
        clearHistoryOnServer(server_name);
    });
}

function eventToClearHistoryOnClient(elem) {
    elem.on('click', function () {
        var name = $('#client').text();
        clearHistoryOnClient(name);
    });
}

function eventToOpenRspecResults(elem) {
    elem.on('click', function () {
        var clicked = $(this);
        $.ajax({
            url: '/histories/show_html_results',
            async: false,
            type: 'GET',
            data: {
                'history_id': clicked.attr('data-id')
            },
            success: function (data) {
                showPopup();
                $('.popup-window').html(data);
                eventsForRspecPopup();
            },
            error: function (xhr, type, errorThrown) {
                ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
            }
        });
    });
}