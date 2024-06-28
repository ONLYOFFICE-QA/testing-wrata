/**
 * Created by lobashov-2 on 10.03.17.
 */

window.getUpdatedDataFromServer = function() {
    $.ajax({
        url: 'runner/updated_data.json',
        type: 'GET',
        async: false,
        data: {
            'servers': getAllServers()
        },
        success: function (data) {
            setDataOnServersView(data.servers_data);
            clearServersQueue();
            clearTestsQueue();
            setDataOnQueuePanel(data.queue_data);
            toggleClearTestButton();
            toggleShuffleTestButton();
            toggleRemoveDuplicatesQueue();
            toggleUnbookAllServersButton();
            toggleStopAllBookedServers();
        },
        error: function (e) {
            console.log(e.message);
        }
    });
};

window.getAllServers = function() {
    var servers = [];
    $('.server').each(function () {
        var server_name = $(this).attr('id');
        var is_log_displayed = server_log_visible(server_name);
        servers.push({name: server_name, with_log: is_log_displayed});
    });
    return JSON.stringify(servers);
};

window.setDataOnServersView = function(data) {
    for (var i = 0; i < data.length; i++) {
        var selector = "div[id='" + data[i].name + "']";
        var server = $(selector);
        setStatusToServerView(server, data[i].status);
        setServerIp(server, data[i].server_ip);
        copyServerIpToClipboardEvent(data[i].name);
        disableSelectServerSize(data[i].name);
        setServerSize(data[i].name, data[i].size);
        if (data[i].status) {
            changeCreateOnDestroy(server.find('.fa-power-off'));
            if('test' in data[i]) {
                showTestProgress(server.find('.ui-progress-bar'), data[i].test.time, data[i].test.metadata);
                setTestNameAndOptions(server.find('.ui-progress-bar .hidden-tool'), data[i].test);
                fill_server_log(data[i].name, data[i].log);
                server.find('.fa-stop').show();
            } else {
                server.find('.ui-progress-bar').hide();
                server.find('.fa-stop').hide();
            }
            if('booked' in data[i]) {
                showBookedClient(server.find('.user-icon'), data[i].booked.booked_client);
                if (data[i].booked.booked_by_client) {
                    showUnbookButton(server.find("div.button"));
                } else {
                    hideUnbookButton(server.find("div.button"));
                }
            } else {
                hideBookedClient(server.find('.user-icon'));
                showBookButton(server.find("div.button"));
            }
        } else {
            server.find('.ui-progress-bar').hide();
            server.find('.fa-stop').hide();
            hideUnbookButton(server.find("div.button"));
            hideBookedClient(server.find('.user-icon'));
            changeDestroyOnCreate(server.find('.fa-power-off'));
        }
        if (data[i]._status  == 'destroying') {
            server.find('.server-content').show();
            showServerSectionOverlay(data[i].name, 'Destroying...');
        } else if (data[i]._status  == 'creating') {
            server.find('.server-content').show();
            showServerSectionOverlay(data[i].name, 'Creating...');
        } else {
            hideServerSectionOverlay(data[i].name);
        }
    }
};

window.setStatusToServerView = function(server, status) {
    if (status === true) {
        server.removeClass('off');
    }
    else {
        server.addClass('off');
    }
};

window.setServerIp = function(server, ip) {
    server.find('.server-ip span').text(ip);
};

window.changeCreateOnDestroy = function(button) {
    if (button.hasClass('create')) {
        button.removeClass('create');
        button.addClass('destroy');
        button.find('span').text('destroy');
    }
};

window.showTestProgress = function(progress_elem, time, metadata) {
    var progress = 0;
    if (metadata != null) {
        progress = metadata.processing;
    }
    var ui_progress = progress_elem.find('.ui-progress');
    ui_progress.css('width', progress + '%');
    if (metadata != null) {
        var totalCases = metadata.failed_count + metadata.passed_count + metadata.pending_count;
        progress_elem.find('.ui-progress-passed').css('width', (metadata.passed_count / totalCases) * 100 + '%');
        progress_elem.find('.ui-progress-pending').css('width', (metadata.pending_count / totalCases) * 100 + '%');
        progress_elem.find('.ui-progress-failed').css('width', (metadata.failed_count / totalCases) * 100 + '%');
    }
    progress_elem.find('.value').text(progress + '% ' + time);
    progress_elem.show();
};

window.setTestNameAndOptions = function(hidden_elem, test) {
    hidden_elem.find('.name').text(test.name);
    hidden_elem.find('.location').text(test.location);
    hidden_elem.find('.test-progress').text(testProgressLine(test));
    hidden_elem.find('.time').text(test.time);
    hidden_elem.find('.docs_branch').text('Docs Branch: ' + test.doc_branch);
    hidden_elem.find('.tm_branch').text('OnlyOffice Branch: ' + test.tm_branch);
    hidden_elem.find('.spec_browser').text('Spec Browser: ' + test.spec_browser);
    hidden_elem.find('.spec_language').text('Spec Language: ' + test.spec_language);
};

window.showBookedClient = function(userIcon, userName) {
    userIcon.find('span').text(userName);
    userIcon.css('visibility', 'visible');
};

window.showUnbookButton = function(button) {
    changeBookButtonOnUnbook(button);
    button.show();
    button.css('visibility', 'visible');
    eventToUnbookServer(button, false);
};

window.hideUnbookButton = function(button) {
    button.hide();
};

window.hideBookedClient = function(userIcon) {
    userIcon.find('span').text('');
    userIcon.css('visibility', 'hidden');
};

window.showBookButton = function(button) {
    changeUnbookButtonOnBook(button);
    button.show();
    eventToBookServer(button);
};

window.changeDestroyOnCreate = function(button) {
    if (button.hasClass('destroy')) {
        button.removeClass('destroy');
        button.addClass('create');
        button.find('span').text('create');
    }
};

window.clearServersQueue = function() {
    clearElementInside($('#server-queue'));
};

window.clearTestsQueue = function() {
    clearElementInside($('#test-queue'));
};

window.copyServerIpToClipboardEvent = function(serverName) {
    var copyTextareaBtn = $("#" + serverName + ' .server-ip span');

    copyTextareaBtn.on('click', function () {
        selectObjectForCopy(copyTextareaBtn);
        document.execCommand('copy');
        copyTextareaBtn.fadeOut('normal', function() {
            copyTextareaBtn.delay(200).fadeIn();
        });
    });
};

window.selectObjectForCopy = function(jqueryObject) {
    var range = document.createRange();
    range.selectNode(jqueryObject.get(0));
    window.getSelection().removeAllRanges();
    window.getSelection().addRange(range);
};

window.testProgressLine = function(test) {
    if (test.metadata == null) {
        return 'Progress is not available';
    }
    var line = 'Progress ' + test.metadata.processing + '%';
    if (typeof test.metadata.passed_count !== 'undefined') {
        line += ', Passed: ' + test.metadata.passed_count;
    }
    if (typeof test.metadata.pending_count !== 'undefined') {
        line += ', Pending: ' + test.metadata.pending_count;
    }
    if (typeof test.metadata.failed_count !== 'undefined') {
        line += ', Failed: ' + test.metadata.failed_count;
    }
    return line;
};
