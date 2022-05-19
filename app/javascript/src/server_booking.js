/**
 * Created by lobashov-2 on 10.03.17.
 */


window.unbookServer = function(server_name, button, hide_button) {
    button = typeof button === 'undefined' ? null : button;
    hide_button = typeof hide_button === 'undefined' ? null : hide_button;
    $.ajax({
        url: 'queue/unbook_server',
        context: this,
        async: false,
        data: {
            'server': server_name
        },
        type: 'POST',
        success: function () {
            if (button != null) {
                button.unbind();
                changeUnbookButtonOnBook(button);
                if (hide_button) {
                    button.hide();
                }
                eventToBookServer(button);
                toggleUnbookAllServersButton();
                getUpdatedDataFromServer();
            }
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
};

window.changeUnbookButtonOnBook = function(button) {
    var className = button.attr('class');
    if (className.indexOf('unbook') != -1) {
        button.removeClass('unbook-button');
        button.text('book');
        button.addClass('book-button');
    }
};

window.changeBookButtonOnUnbook = function(button) {
    var className = button.attr('class');
    if (className.indexOf('unbook') == -1) {
        button.removeClass('book-button');
        button.text('unbook');
        button.addClass('unbook-button');
    }
};

window.eventToBookServer = function(elements) {
    offEventsOnElem(elements);
    elements.on('click', function() {
        bookServer($(this), $(this).attr('data-server'));
    });
};

window.toggleUnbookAllServersButton = function() {
    if (checkAnyBookedServers()) {
        $('#clear-servers').show();
    } else {
        $('#clear-servers').hide();
    }
};

window.bookServer = function(button, server_name) {
    $.ajax({
        url: 'queue/book_server',
        context: this,
        async: false,
        data: {
            'server': server_name
        },
        type: 'POST',
        success: function () {
            button.unbind();
            changeBookButtonOnUnbook(button);
            eventToUnbookServer(button, false);
            getUpdatedDataFromServer();
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
};

window.eventToUnbookServer = function(elements, hide_button) {
    offEventsOnElem(elements);
    elements.on('click', function() {
        unbookServer($(this).attr('data-server'), $(this), hide_button);
    });
};

window.checkAnyBookedServers = function() {
    return document.getElementById('server-queue').hasChildNodes();
};

window.toggleStopAllBookedServers = function() {
    if (checkAnyBookedServers()) {
        $('#stop-booked').show();
    } else {
        $('#stop-booked').hide();
    }
};