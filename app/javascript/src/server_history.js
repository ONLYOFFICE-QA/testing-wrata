/**
 * Created by lobashov-2 on 7/7/15.
 */

window.showMoreData = function(data) {
    if (data.length === 0) {
        $('#show-more').hide();
    } else {
        var trimmed_data = trim_data(data);
        $('tbody').append(trimmed_data);
        eventToDeleteHistoryLine(trimmed_data.find('.delete-line'));
        eventToOpenRspecResults(trimmed_data.find('.open-results'));
        eventToShowFullStartOption(trimmed_data.find('.open-full-command'));
        eventToRetest(trimmed_data.find('.retest'));
    }
};

window.showMoreHistoryForServer = function() {
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
            showMoreData(data);
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
};

window.showMoreHistoryForClient = function() {
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
            showMoreData(data);
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
};

window.clearHistoryOnServer = function(server_name) {
    $.ajax({
        url: '/servers/clear_history',
        type: 'POST',
        data: {
            'server': server_name
        },
        beforeSend: function () {
            showOverlay('Deleting history for server');
        },
        complete: function () {
            hideOverlay();
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
};

window.eventToDeleteHistoryLine = function(elem) {
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
};

window.eventToRetest = function(elem) {
    elem.on('click', function () {
        var clicked = $(this);
        $.ajax({
            url: '/queue/retest',
            data: {
                test_path: clicked.attr('data-path'),
                start_option_id: clicked.attr('data-start-option-id')
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
};

window.eventToShowFullStartOption = function(elem) {
    elem.click(
        function () {
            var to_show = $(this.parentNode).find('.full-command');
            $(to_show).fadeToggle();
        });
};

window.eventToClearHistoryOnServer = function(elem) {
    elem.on('click', function () {
        var server_name = $('#server').text();
        clearHistoryOnServer(server_name);
    });
};

window.eventToClearHistoryOnClient = function(elem) {
    elem.on('click', function () {
        var name = $('#client').text();
        clearHistoryOnClient(name);
    });
};

window.eventToOpenRspecResults = function(elem) {
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
};