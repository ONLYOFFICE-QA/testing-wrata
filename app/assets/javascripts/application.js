// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//= require bootstrap
//= require jquery
//= require jquery_ujs
//= require_tree
//
//

$.ajaxSetup({
    headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
});

const STATUS = {
    UPDATE_INTERVAL: 10000,
    ONLINE: 0,
    OFFLINE: 1,
    WAIT: 2
};

const MAX_LENGTH = 26;
const MIN_LENGTH = 3;

function failAlert() {
    alert('Fail! Something goes wrong!')
}

function infoPopup(info_html) {
    var popup = open("", "Info Popup", "width=800,height=400");
    popup.document.body.innerHTML = info_html;
}

function Client(login, file_lists) {
    this.login = login;
    this.file_lists = file_lists;
}

function trim_data(data) {
    return $($.trim(data));
}

function Runner() {
    const UPDATE_INTERVAL = 1000;
    const STATUS_ONLINE = 0;
    const STATUS_OFFLINE = 1;
    const STATUS_WAIT = 2;
    const SIDE_MAX_TEST_LENGTH = 40;
    var _self = this;
    var testListUpdating = false;

    this.eventToGetUpdatedDataFromServer = function () {
        setInterval(function () {
            if (!testListUpdating) {
                _self.getUpdatedDataFromServer()
            }
        }, STATUS.UPDATE_INTERVAL);
    };

    this.getBranch = function () {
        return $('li.active .branch').val();
    };

    this.showCurrentRspecResult = function (server_name) {
        $.ajax({
            url: 'servers/show_current_results',
            type: 'GET',
            data: {
                'server': server_name
            },
            success: function (data) {
                showPopup();
                $('.popup-window').html(data);
                eventsForRspecPopup();
            }
        })
    };

    this.eventToShowCurrentRspecResult = function (elem) {
        elem.on('click', function () {
            var server_name = $(this).attr('data-server');
            _self.showCurrentRspecResult(server_name)
        })
    };

    this.getUpdatedDataFromServer = function () {
        $.ajax({
            url: 'runner/updated_data',
            type: 'GET',
            async: false,
            data: {
                'servers': _self.getAllServers()
            },
            success: function (data) {
                _self.setDataOnServersView(data['servers_data']);
                _self.clearServersQueue();
                _self.clearTestsQueue();
                _self.setDataOnQueuePanel(data['queue_data']);
                _self.toggleClearTestButton();
            },
            error: function (e) {
                console.log(e.message);
//                failAlert();
            }
        })
    };

    this.getAllServers = function() {
        var servers = [];
        $('.server').each(function () {
            servers.push($(this).attr('id'));
        });
        return servers
    };

    this.clearServersQueue = function() {
        clearElementInside($('#server-queue'));
    };

    this.clearTestsQueue = function() {
        clearElementInside($('#test-queue'));
    };

    this.setDataOnQueuePanel = function(queue_data) {
        _self.showBookedServers(queue_data['servers']);
        _self.showTestsFromQueue(queue_data['tests']);
    };

    this.showBookedServers = function(servers) {
        for(var i = 0; i < servers.length; i++) {
            _self.appendServerOnQueue(servers[i])
        }
    };

    this.appendServerOnQueue = function(server) {
        var button = $('<div class="unbook-button" data-server="'+ server + '">unbook</div>');
        var node = $('<div class="server-node"><i class="glyphicon glyphicon-hdd"></i>' + server + '</div>');
        node.append(button);
        _self.eventToUnbookServer(button, true);
        $('#server-queue').append(node);
    };

    this.showTestsFromQueue = function(tests) {
        for(var i = 0; i < tests.length; i++) {
            _self.appendTestsOnQueue(tests[i])
        }
    };

    this.appendTestsOnQueue = function(test) {
        var select = '<select class="region form-control"><option>info eu</option><option>info us</option><option>info sg</option><option>com eu</option><option>com us</option><option>com sg</option><option>default</option></select>';
        select = $(select);
        _self.eventToChangeLocationForTest(select);
        select.find(":contains('" + test['location'] + "')").prop('selected', true);
        var props = $('<div class="props"></div>');
        props.append(select);
        var name = $('<div class="name"><i class="glyphicon glyphicon-leaf"></i>' + test['test_name'] + '</div>');
        var testNode = $('<div class="test-node" data-id="' + test['id'] + '" data-path="' + test['test_path'] + '"></div>');
        testNode.append(name);
        testNode.append(props);
        $('#test-queue').append(testNode);
    };

    this.setServerIp = function(server, ip) {
        server.find('.server-ip span').text(ip);
    };

    this.setDataOnServersView = function (data) {
        for (var i = 0; i < data.length; i++) {
            var selector = '#' + data[i]['name'];
            var server = $(selector);
            _self.setStatusToServerView(server, data[i]['status']);
            _self.setServerIp(server, data[i]['server_ip']);
            if (data[i]['status']) {
                _self.changeCreateOnDestroy(server.find('.glyphicon-off'));
                if('test' in data[i]) {
                    _self.showTestProgress(server.find('.ui-progress-bar'), data[i]['test']['progress'], data[i]['test']['time']);
                    _self.setTestNameAndOptions(server.find('.ui-progress-bar .hidden-tool'),
                        data[i]['test']['name'], data[i]['test']['location']);
                    server.find('.glyphicon-stop').show();
                    _self.setLogToServerView(server, data[i]['log']);
                } else {
                    server.find('.ui-progress-bar').hide();
                    server.find('.glyphicon-stop').hide();
                }
                if('booked' in data[i]) {
                    _self.showBookedClient(server.find('.user-icon'), data[i]['booked']['booked_client']);
                    if (data[i]['booked']['booked_by_client']) {
                        _self.showUnbookButton(server.find("div.button"));
                    } else {
                        _self.hideUnbookButton(server.find("div.button"));
                    }
                } else {
                    _self.hideBookedClient(server.find('.user-icon'));
                    _self.showBookButton(server.find("div.button"));
                }
            } else {
                server.find('.ui-progress-bar').hide();
                server.find('.glyphicon-stop').hide();
                _self.hideUnbookButton(server.find("div.button"));
                _self.hideBookedClient(server.find('.user-icon'));
                _self.changeDestroyOnCreate(server.find('.glyphicon-off'));
            }
            if (data[i]['_status']  == 'destroying') {
                server.find('.server-content').show();
                _self.showServerSectionOverlay(data[i]['name'], 'Destroying...')
            } else if (data[i]['_status']  == 'creating') {
                server.find('.server-content').show();
                _self.showServerSectionOverlay(data[i]['name'], 'Creating...')
            } else {
                _self.hideServerSectionOverlay(data[i]['name'])
            }
        }
    };

    this.createServer = function(server) {
        $.ajax({
            url: 'servers/cloud_server_create',
            type: 'POST',
            async: true,
            data: {
                'server': server
            },
            success: function () {
                _self.hideServerSectionOverlay(server);
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
                infoPopup(e.responseText)
            }
        })
    };

    this.destroyServer = function(server) {
        $.ajax({
            url: 'servers/cloud_server_destroy',
            type: 'POST',
            async: true,
            data: {
                'server': server
            },
            success: function () {
                _self.hideServerSectionOverlay(server);
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.showServerSectionOverlay = function(server,message) {
        var selector = 'div#' + server + ' .section-overlay';
        $(selector).find('.overlay-text').text(message);
        $(selector).show();
    };

    this.hideServerSectionOverlay = function(server) {
        var selector = 'div#' + server + ' .section-overlay';
        $(selector).hide()
    };

    this.createAndDestroyServer = function(button) {
      var serverName = button.attr('data-server');
      if (button.hasClass('create')) {
          _self.showServerSectionOverlay(serverName, 'Creating...');
          _self.createServer(serverName);
      } else if (button.hasClass('destroy')) {
          _self.showServerSectionOverlay(serverName, 'Destroying...');
          _self.destroyServer(serverName);
      }
    };

    this.eventForCreateAndDestroyServer = function(button) {
        button.on('click', function () {
            var result = confirm('Are you really want to ' + $(this).find('.hidden-tool').text() + ' this server?');
            if (result)
                _self.createAndDestroyServer($(this))
        })
    };

    this.changeCreateOnDestroy = function(button) {
        if (button.hasClass('create')) {
            button.removeClass('create');
            button.addClass('destroy');
            button.find('span').text('destroy');
        }
    };

    this.changeDestroyOnCreate = function(button) {
        if (button.hasClass('destroy')) {
            button.removeClass('destroy');
            button.addClass('create');
            button.find('span').text('create');
        }
    };

    this.showTestProgress = function(progress_elem, progress, time) {
        var ui_progress = progress_elem.find('.ui-progress');
        ui_progress.css('width', progress + '%');
        progress_elem.find('.value').text(progress + '% ' + time);
        progress_elem.show();
    };

    this.setTestNameAndOptions = function(hidden_elem, name, location) {
        hidden_elem.find('.name').text(name);
        hidden_elem.find('.location').text(location);
    };

    this.hideUnbookButton = function(button) {
        button.hide();
    };

    this.showUnbookButton = function(button) {
        _self.changeBookButtonOnUnbook(button);
        button.show();
        button.css('visibility', 'visible');
        _self.eventToUnbookServer(button, false);
    };

    this.showBookButton = function(button) {
        _self.changeUnbookButtonOnBook(button);
        button.show();
        _self.eventToBookServer(button);
    };

    this.showBookedClient = function(userIcon, userName) {
        userIcon.find('span').text(userName);
        userIcon.show()
    };

    this.hideBookedClient = function(userIcon) {
        userIcon.find('span').text('');
        userIcon.hide()
    };

    this.setStatusToServerView = function (server, status) {
        if (status == true) {
            server.removeClass('off');
        }
        else {
            server.addClass('off');
        }
    };

    this.setLogToServerView = function (server_el, log) {
        // if ((currentLogOnServer(server_el) == '') && (currentTestOnServer(server_el) == 'nothing')) {
//        if (log != '') {
            var log_div = server_el.find('.log');
            log_div.text(log);
//        }
        //  }
    };

    this.rebootServer = function (server) {
        $.ajax({
            url: 'servers/reboot',
            type: 'GET',
            async: false,
            data: {
                'server': server
            },
            success: function () {
                alert('The server was going to reboot.')
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.stopCurrent = function (server) {
        $.ajax({
            url: 'runner/stop_current',
            type: 'POST',
            async: false,
            data: {
                'server': server
            },
            success: function () {
                alert('Current test was stopped successfully!')
            },
            error: function (e) {
                console.log(e.message);
            }
        })
    };

    this.eventToRebootServer = function(elem) {
        elem.on('click', function () {
            var server_name = $(this).attr('data-server');
            _self.rebootServer(server_name);
        })
    };

    this.eventToStopTest = function (elem) {
        elem.on('click', function () {
            var result = confirm('Are you really want to stop this test?');
            if (result) {
                var server_name = $(this).attr('data-server');
                _self.stopCurrent(server_name);
            }
        })
    };

    this.bookServer = function(button, server_name) {
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
                _self.changeBookButtonOnUnbook(button);
                _self.eventToUnbookServer(button, false);
                _self.getUpdatedDataFromServer();
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.changeBookButtonOnUnbook = function(button) {
        var className = button.attr('class');
        if (className.indexOf('unbook') == -1) {
            button.removeClass('book-button');
            button.text('unbook');
            button.addClass('unbook-button');
        }
    };

    this.changeUnbookButtonOnBook = function(button) {
        var className = button.attr('class');
        if (className.indexOf('unbook') != -1) {
            button.removeClass('unbook-button');
            button.text('book');
            button.addClass('book-button');
        }
    };

    this.eventToBookServer = function(elems) {
        offEventsOnElem(elems);
        elems.on('click', function() {
            _self.bookServer($(this), $(this).attr('data-server'))
        })
    };

    this.unbookServer = function(button, server_name, hide_button) {
        $.ajax({
            url: 'queue/unbook_server',
            context: this,
            async: false,
            data: {
                'server': server_name
            },
            type: 'POST',
            success: function () {
                button.unbind();
                _self.changeUnbookButtonOnBook(button);
                if (hide_button)
                    button.hide();
                _self.eventToBookServer(button);
                _self.getUpdatedDataFromServer();
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.eventToUnbookServer = function(elems, hide_button) {
        offEventsOnElem(elems);
        elems.on('click', function() {
            _self.unbookServer($(this), $(this).attr('data-server'), hide_button)
        })
    };

    this.addTestInQueue = function(test_path, branch, location) {
        $.ajax({
            url: 'queue/add_test',
            context: this,
            async: false,
            data: {
                'test_path': test_path,
                'branch': branch,
                'location': location
            },
            type: 'POST',
            success: function () {

            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.addTestsInQueue = function(test_path_array, branch, location) {
        $.ajax({
            url: 'queue/add_tests',
            context: this,
            async: false,
            data: {
                'tests_path': test_path_array,
                'branch': branch,
                'location': location
            },
            type: 'POST',
            success: function () {

            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.eventToAddTestsFromSidebar = function(elem) {
        elem.on('click', function(){
            var tests = _self.getTestPathsFromSidebar();
            var branch = _self.getBranch();
            var location = $('#list-region').val();
            _self.addTestsInQueue(tests, branch, location);
            _self.getUpdatedDataFromServer();
        });
    };

    this.getTestPathsFromSidebar = function() {
        var tests = [];
        $('#sidebar').find('.file-name').each(function(){
                 tests.push($(this).attr('data-qtip'))
        });
        return tests;
    };

    this.eventToAddTestInQueue = function(elem) {
        elem.on('click', function(){
            _self.addTestInQueue($(this).attr('data-test'), _self.getBranch(), $('li.active .region').val());
            _self.getUpdatedDataFromServer();
            imitateHover($('.test-node :first'))
        });
    };

    this.addFolderInQueue = function(folder_elem) {
        var tests = [];
        folder_elem.find('.add-button-file').each(function(){
            tests.push($(this).attr('data-test'));
        });
        if (tests.length != 0) {
            var branch = _self.getBranch();
            var location = $('li.active .region').val();
            _self.addTestsInQueue(tests, branch, location);
        }

    };

    this.eventToAddFolderInQueue = function(folder_elem) {
        folder_elem.on('click', function(){
            _self.addFolderInQueue($(this).parent());
            _self.getUpdatedDataFromServer();
        });
    };

    this.showServers = function () {
        $.ajax({
            url: 'runner/show_servers',
            context: this,
            async: false,
            type: 'GET',
            success: function (data) {
                var trimmed_data = trim_data(data);
                $("div#servers").html(trimmed_data);
                _self.eventToOpenServer(trimmed_data.find('.server-header'));
                _self.eventToOpenLogBySelector('.log-opener span');
                _self.eventToSlimScrollLog(trimmed_data.find('.log'));
                _self.eventToBookServer(trimmed_data.find('.book-button'));
                _self.eventToUnbookServer(trimmed_data.find('.unbook-button'), false);
                _self.eventToStopTest(trimmed_data.find('.glyphicon-stop'));
                _self.eventForCreateAndDestroyServer(trimmed_data.find('.glyphicon-off'));
                _self.eventToGetUpdatedDataFromServer();
                _self.eventToRebootServer(trimmed_data.find('.glyphicon-repeat'));
                _self.eventToShowCurrentRspecResult(trimmed_data.find('.ui-progress-bar'));
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.showTestsView = function () {
        var project = _self.getCurrentProject();
        $.ajax({
            url: 'runner/show_tests',
            context: this,
            async: true,
            type: 'GET',
            success: function (data) {
                var trimmed_data = trim_data(data);
                $(".tests-block .tab-content").html(trimmed_data);
                _self.setEventToOpenFolder();
                _self.eventToOpenFileInclude();
                _self.eventToAddFile();
                _self.selectProject(project);
                _self.eventToAddTestInQueue(trimmed_data.find('.add-button-file'));
                _self.eventToAddFolderInQueue(trimmed_data.find('.add-button-folder'));
                hideSectionOverlay();
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.eventForPullProjectsAndFillTests = function(elem) {
        elem.on('click', function() {
            _self.pullProjectsAndFillTests();
        })
    };

    this.pullProjectsAndFillTests = function() {
        showSectionOverlay();
        $.ajax({
            url: 'runner/pull_projects',
            context: this,
            async: true,
            type: 'GET',
            success: function() {
                _self.showBranchesList();
                _self.showTestsView();
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.showBranchesList = function() {
        $.ajax({
            url: 'runner/branches',
            context: this,
            async: false,
            type: 'GET',
            success: function (data) {
                _self.setDocBranches(data['doc_branches']);
                _self.setTeamlabBranches(data['tm_branches']);
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.pullProjectsAndGetAllView = function(){
        _self.pullProjectsAndFillTests();
    };

    this.setDocBranches = function(branches) {
        var select = $('#docs-branches');
        clearElementInside(select);
        for(var i = 0; i < branches.length; i++) {
            select.append($("<option>" + branches[i] + "</option>"))
        }
    };

    this.setTeamlabBranches = function(branches) {
        var select = $('#teamlab-branches');
        clearElementInside(select);
        for(var i = 0; i < branches.length; i++) {
            select.append($("<option>" + branches[i] + "</option>"))
        }
    };

    this.saveTestList = function () {
        $.ajax({
            url: 'runner/save_list',
            context: this,
            type: 'POST',
            data: {
                'test_list': this.getTestList(),
                'branch': this.getCurrentBranch(),
                'project': this.getCurrentProject()
            },
            beforeSend: function () {
                showOverlay('Saving...');
            },
            complete: function () {
                hideOverlay()
            },
            success: function (data) {
                if (data == "") {
                    alert('Sign up for saving!');
                    return;
                }
                var trimmed_data = trim_data(data);
                _self.appendListDropdownMenu(trimmed_data);
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.getCurrentBranch = function () {
        return $('.active select.branch option:selected').val();
    };

    this.getCurrentProject = function () {
        return $('.tab-pane.active').attr('id');
    };

    this.appendListDropdownMenu = function (list_menu) {
        var checkAlreadyExist = false;
        $('#test_list_menu').find('a').each(function () {
            if ($(this).text() == list_menu.find('a').first().text()) {
                checkAlreadyExist = true
            }
        });
        if (checkAlreadyExist != true) {
            $('#test_list_menu').prepend(list_menu);
            var menu_link = list_menu.children('a').first();
            $(menu_link).on('click', function () {
                _self.eventToLoadTestList($(this));
            });
            list_menu.find('i.delete-test-list').off('click');
            _self.setEventToDeleteTestList(list_menu);
        }

    };

    this.EventToDeleteTestList = function (list_menu) {
        $.ajax({
            url: list_menu.find('.delete-test-list').attr('delete-data'),
            context: this,
            async: false,
            type: 'DELETE',
            success: function () {
                list_menu.remove()
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.setEventToDeleteTestList = function (list_menu) {
        list_menu.find('i.delete-test-list').on('click', function () {
            _self.EventToDeleteTestList($(this).parent());
        });
    };

    this.changeBranch = function () {
        var project = _self.getCurrentProject();
        $.ajax({
            url: 'runner/change_branch',
            context: this,
            async: true,
            type: 'GET',
            data: {
                'project': project,
                'branch': _self.getCurrentBranch()
            },
            success: function () {
                var startIcon = $(".active .start-icon");
                startIcon.parent().removeClass('with-start');
                _self.showTestsView();
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.setEventChangeBranch = function () {
        $('li select.branch').change(function () {
            var project = _self.getCurrentProject();
            showSectionOverlay();
            _self.changeBranch();
            alert('successful changed'); // Знаю что, тупой костыль, но переделывать времени нет
        })
    };

    this.eventToChangeLocationForTest = function(elem) {
        elem.change(function(){
            var test_id = elem.parent().parent().attr('data-id');
            var new_location = elem.val();
            _self.changeLocationForTest(test_id, new_location)
        })
    };

    this.changeLocationForTest = function(test_id, new_location) {
        $.ajax({
            url: 'queue/change_test_location',
            data: { test_id: test_id, new_location: new_location },
            context: this,
            type: 'POST',
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.eventToLoadTestList = function (elem) {
        $("#list-name").text(elem.text());
        showSectionOverlay();
        $.ajax({
            url: 'runner/load_test_list',
            context: this,
            type: 'GET',
            async: true,
//            async: false,
//            beforeSend: (),
            beforeSend: function () {
                showOverlay('Loading...');
            },
            complete: function () {
                hideOverlay()
            },
            data: {
                'listName': elem.text()
            },
            success: function (data) {
                $("#sidebar-test-list").html(data['html']);
                _self.selectProject(data['project']);
                _self.selectBranch(data['branch']);
                _self.changeBranch();
//                _self.showTestsView();
                _self.setEventToOpenFile($('.file-folder'));
                _self.setEventToDeleteFolderFromList();
                _self.setEventToDeleteTestFromList();
                _self.checkAllAddedOnSidebar();
                addSortableToElem($('.stroke-list'));
                openSidebar();
                showStartPanel();
                unlockAllTab();
                unlockAllBranchSelect();
                lockInactiveTab();
                lockActiveBranchSelect();

            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.selectBranch = function (branch) {
        $("li.active select.branch option").filter(function () {
            return $(this).html() == branch;
        }).prop('selected', true);
//        $("li.active select.branch :contains('" + branch + "')").prop('selected', true);      jg
    };

    this.selectProject = function (project) {
        var docsTab = $('div#docs');
        var tmTab = $('div#teamlab');
        var currentActive = $('.nav-tabs li.active');
        $('.nav.nav-tabs a').each(function () {
            if ((project == 'docs') && ($(this).attr('href') == '#docs')) {
                currentActive.removeClass('active');
                $(this).parent().addClass('active');
                docsTab.addClass('active');
                tmTab.removeClass('active');
            }
            if ((project == 'teamlab') && ($(this).attr('href') == '#teamlab')) {
                currentActive.removeClass('active');
                $(this).parent().addClass('active');
                tmTab.addClass('active');
                docsTab.removeClass('active');
            }
        })

    };

    this.setEventToOpenFolder = function () {
        $(".folder-name").on('click', function () {
            var currentDisplay = $(this).next(".folder-inside").css("display");
            var icon = $(this).children("i");
            if (currentDisplay == "none") {
                $(this).next(".folder-inside").css("display", "block");
                icon.addClass("glyphicon-folder-open");
                icon.removeClass("glyphicon-folder-close");
            }
            else {
                $(this).next(".folder-inside").css("display", "none");
                icon.addClass("glyphicon-folder-close");
                icon.removeClass("glyphicon-folder-open");
            }
        });
    };

    this.showIncludedTests = function (path) {
        $.ajax({
            url: 'runner/show_subtests',
            data: { filePath: path },
            context: this,
            type: 'GET',
            success: function (data) {
                $('.popup-overlay').css("display", "block");
                $("#popup").find(".wrap").html(data);
                stopPropagation($('.viewer'));
                _self.setEventToCloseTestsList();
                $("#tests-list").slimScroll({
                    height: '100%',
                    width: '780px'
                });
                _self.setEventToAddToList($(".add-test"));
                $('#add-all').on('click', function () {
                    _self.addAllTests();
                })
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.eventToOpenFileInclude = function () {
        $(".folder .glyphicon-file").on('click', function () {
            if (_self.checkAddedOnSidebar($(this).parent().parent().find('.add-button-file').attr('data-test'))) {
                alert('File already added to sidebar! Delete him or choose another!')
            }
            else {
                var path = $(this).parent().parent().find('.add-button-file').attr('data-test');
                myRunner.showIncludedTests(path);
            }
        })
    };

    this.checkAddedOnSidebar = function (file_path) {
        var already_add = false;
        if ($('#sidebar-test-list').find('*[data-qtip="' + file_path + '"]').size() != 0) {
            already_add = true;
        }
        return already_add
    };

    this.checkAllAddedOnSidebar = function () {
        _self.makeAllAddButtonsVisible();
        var added_files = _self.getListSidebarFiles();
        $(".tab-content .file-name").each(function () {
            var cur_file = $(this).parent().find('.add-button-file').attr('data-test');
            if (jQuery.inArray(cur_file, added_files) != -1) {
                $(this).find('i.add-file').css('display', 'none')
            }
        });
    };

    this.makeAllAddButtonsVisible = function () {
        $('.tab-content i.add-file').each(function () {
            $(this).css('display', 'inline-block')
        })
    };

    this.getListSidebarFiles = function () {
        var files = [];
        $("#sidebar .file-name").each(function () {
            files.push($(this).attr('data-qtip'));
        });
        return files
    };

    this.eventToOpenServer = function(header) {
        header.on('click', function (e) {
            if (!$(e.target).is("label")) return;
            var server_content = $(this).next();
            server_content.slideToggle();
        });
        stopPropagation(header.find('div.button'))
    };

    this.setIconToAdded = function (elem) {
        elem.addClass('added-test');
        elem.removeClass('add-test');
//        elem.addClass('icon-minus-sign');
        elem.removeClass('glyphicon glyphicon-plus-sign');
    };

    this.setIconToAdd = function (elem) {
        elem.addClass('add-test');
        elem.removeClass('added-test');
        elem.addClass('glyphicon glyphicon-plus-sign');
//        elem.removeClass('icon-minus-sign');
    };

    this.setEventToCloseTestsList = function () {
        $(".close-list-button").on('click', function () {
            $('.popup-overlay').fadeOut();
        });
        $('.popup-overlay').on('click', function () {
            $(this).fadeOut();
        })
    };

    this.addAllTests = function () {
        $('.subtest-row i.add-test').each(function () {
            _self.addTestToList($(this));
        });
        openSidebar();
    };

    this.addTestToList = function (icon_add) {
        var file_name = $("#test_file_name").text();
        var file_path = $("#test_file_name").attr('data-qtip');
        var it_name = icon_add.next(".test-name").text();
        var file_added = false;
        var cut_it_name = HtmlEncode(it_name);
        var textSize = it_name.length;
        var stroke_number = icon_add.next(".test-name").attr('data-role');

        if (textSize > SIDE_MAX_TEST_LENGTH) {
            cut_it_name = it_name.substr(0, SIDE_MAX_TEST_LENGTH) + '...';
        }

        var stroke = "<div class='name shower' data-qtip=\"" + it_name + "\" data-role='" + stroke_number + "'>" +
            "<div class='text-name'>" + cut_it_name + "</div>" +
            "<i class='glyphicon glyphicon-remove'></i><span class='hidden-tool'>" + HtmlDecode(it_name) + "</span>" +
            "</div>";

        $('#sidebar-test-list').find('.file-name').each(function () {
            if ($(this).attr('data-qtip') == file_path) {
                file_added = true;
                $(this).next().children('.stroke-list').
                    css('display', 'block').
                    append(stroke);
            }
        });
        if (file_added == false) {
            var stroke_list = "<div class='stroke-list'>" + stroke + "</div>";
            var file_inside = "<div class='file-inside'>" + stroke_list + "</div>";
            var file_name_elem = "<div class='file-name shower' data-qtip='" + file_path + "'><i class='glyphicon glyphicon-file'></i><div class='file-name-text'>" + file_name + "</div><i class='glyphicon glyphicon-remove'></i><span class='hidden-tool'>" + file_name + "</span></div>";
            var folder = $("<div class='file-folder'>" + file_name_elem + file_inside + "</div>");

            $("#sidebar-test-list").append(folder);
            _self.setEventToOpenFile(folder);
            _self.setEventToDeleteFolderFromList();
            $('*[data-test="' + file_path + '"]').parent().find('i.add-file').hide();
            addSortableToElem(folder.find('.stroke-list'));
        }
        _self.setEventToDeleteTestFromList();
        _self.setIconToAdded(icon_add);
        showStartPanel();
        icon_add.off("click");
        lockInactiveTab();
        lockActiveBranchSelect();
    };

    this.addFileToSidebar = function (icon) {
        var file_name = icon.parent();
        var text = file_name.text();
        var path = file_name.parent().find('.add-button-file').attr('data-test');
        var file_name_elem = "<div class='file-name shower' data-qtip='" + path + "'><i class='glyphicon glyphicon-file'></i><div class='file-name-text'>" + text + "</div><i class='glyphicon glyphicon-remove'></i><span class='hidden-tool'>" + text + "</span></div>";
        var folder = $("<div class='file-folder'>" + file_name_elem + "</div>");
        $("#sidebar-test-list").append(folder);
        _self.setEventToDeleteFolderFromList();
        icon.css('display', 'none');
        showStartPanel();
        openSidebar();
        lockInactiveTab();
        lockActiveBranchSelect();
    };

    this.eventToAddFile = function () {
        var icons = $('.tab-content i.add-file');
        offEventsOnElem(icons);
        icons.on('click', function () {
            _self.addFileToSidebar($(this));
        })
    };

    this.setEventToAddToList = function (element) {
        $(element).on('click', function () {
            _self.addTestToList($(this));
            openSidebar();
            var path = $('#test_file_name').attr('data-qtip');
            $('.tab-pane.active input').each(function () {
                var current_path = $(this).attr('id');
                if (current_path == path) {
                    $(this).parent().find('i.add-file').css('display', 'none')
                }
            });
        })
    };

    this.setEventToOpenFile = function (element) {
        element.find(".glyphicon glyphicon-chevron-down").on('click', function () {
            // var elem = $(this).next(); //$('#idtest').is(':visible')
            var inside = element.find(".file-inside");
            var currentDisplay = inside.css("display");
            if (currentDisplay == "none") {
                inside.slideDown();
            }
            else {
                inside.slideUp();
            }
        })
    };

    this.setEventToDeleteTestFromList = function () {
        var text = "";
        var stroke = "";
        $(".name .glyphicon-remove").on('click', function () {
            var stroke_elem = $(this).parent();
            text = stroke_elem.attr('data-qtip');
            stroke = stroke_elem.attr('data-role');
            $(".subtest-row .test-name").each(function () {
                if (($(this).text() == text) && ($(this).attr('data-role') == stroke)) {
                    var icon = $(this).prev('.added-test');
                    _self.setIconToAdd(icon);
                    _self.setEventToAddToList(icon);
                }
            });
            var stroke_size = stroke_elem.parent().children().length;
            if (stroke_size == 1) {
                var folder = stroke_elem.parent().parent().parent();
                var path = folder.find('.file-name').attr('data-qtip');
                $('.tab-pane .add-button-file').each(function () {
                    var current_path = $(this).attr('data-test');
                    if (current_path == path) {
                        $(this).parent().find('i.add-file').css('display', 'inline-block')
                    }
                });
                folder.remove();
            }
            else {
                stroke_elem.remove();
            }
            hideStartPanel();
            unlockInactiveTab();
            unlockActiveBranchSelect();
        });
    };

    this.eventToOpenLogBySelector = function (opener_selector) {
        $(opener_selector).on('click', function () {
            var opener_index = $(opener_selector).index($(this));
            $('.log-window').eq(opener_index).slideToggle();
        })
    };

    this.setEventToDeleteFolderFromList = function () {
        $(".file-name .glyphicon-remove").on('click', function () {
            if ($('#popup').is(':visible')) {
                $(this).parent().next().children().children().each(function () {
                    var text = $(this).attr('data-qtip');
                    var stroke = $(this).attr('data-role');
                    $(".subtest-row .test-name").each(function () {
                        if (($(this).text() == text) && ($(this).attr('data-role') == stroke)) {
                            var icon = $(this).prev('.added-test');
                            _self.setIconToAdd(icon);
                            _self.setEventToAddToList(icon);
                        }
                    });
                });
            }
            else {
                var path = $(this).parent().attr('data-qtip');
                $('.tab-content i.add-file').each(function () {
                    var display = $(this).css('display');
                    if (display == 'none') {
                        var current_path = $(this).parent().parent().find('.add-button-file').attr('data-test');
                        if (current_path == path) {
                            $(this).css('display', 'inline-block');
                        }
                    }
                })
            }
            $(this).parent().parent().remove();
            hideStartPanel();
            unlockInactiveTab();
            unlockActiveBranchSelect();
        })
    };

    this.getSidebarFileTest = function (file_folder) {
        var file_name = file_folder.find('.file-name').attr('data-qtip');
        var file_test = {};
        file_test['file_name'] = file_name;
        if (file_folder.children().size() > 1) {
            var strokes = [];
            file_folder.find('.name').each(function () {
                var stroke = {};
                stroke['name'] = $(this).attr('data-qtip');
                stroke['number'] = $(this).attr('data-role');
                strokes.push(stroke);
            });
            file_test['strokes'] = strokes;
        }
        return file_test;
    };

    this.getTestFiles = function (server_tests_list) {
        var file_tests = [];
        server_tests_list.each(function () {
            var file_test = _self.getSidebarFileTest($(this));
            file_tests.push(file_test);
        });
        return file_tests;
    };

    this.getTestList = function () {
        var name = $('#list-name').text();
        var file_selectors = $('.file-folder');
        var file_tests = _self.getTestFiles(file_selectors);
        var file_list = {};                        //
        file_list['name'] = name;             //LIKE
        file_list['file_tests'] = file_tests;      //HASH
        return file_list;                          //
    };

    this.createNewList = function () {
        $("#sidebar-test-list").html("");
        $("#list-name").text("New Test List");
        hideStartPanel();
        unlockInactiveTab();
        unlockActiveBranchSelect();
        _self.makeAllAddButtonsVisible();
    };

    this.eventToSlimScrollLog = function (log) {
        log.slimScroll({
            height:'80px'
        });
    };

    this.eventToSortTestQueue = function (){
        var removeIntent = false;
        $('#test-queue').sortable({
            over: function () {
                removeIntent = false;
            },
            out: function () {
                removeIntent = true;
            },
            start: function () {
                testListUpdating = true
            },
            stop: function () {
                testListUpdating = false
            },
            beforeStop: function (event, ui) {
                if(removeIntent == true){
                    ui.item.remove();
                    _self.deleteTestFromQueue(ui.item.attr('data-id'));
                }
            },
            update: function(event, ui) {
                if (removeIntent != true) {
                    var first = ui.item.attr('data-id');
                    var second = ui.item.prev().attr('data-id');
                    var in_start = false;
                    if (second == undefined) {
                        in_start = true
                    }
                    _self.swapTestsInQueue(first, second, in_start);
                }
            }
        });
    };

    this.deleteTestFromQueue = function(test_id) {
        $.ajax({
            url: 'queue/delete_test',
            data: { test_id: test_id },
            async: false,
            type: 'POST',
            success: function() {
                _self.toggleClearTestButton();
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        });
    };

    this.swapTestsInQueue = function(test_id1, test_id2, in_start) {
        $.ajax({
            url: 'queue/swap_tests',
            data: { test_id1: test_id1, test_id2: test_id2, in_start: in_start },
            async: false,
            type: 'POST',
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        });
    };

    this.clearTestQueue = function() {
        $.ajax({
            url: 'queue/clear_tests',
            async: false,
            type: 'POST',
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        });
    };

    this.eventToClearTestQueue = function(elem) {
        elem.on('click', function(){
            _self.clearTestQueue();
            _self.getUpdatedDataFromServer();
        })
    };

    this.checkQueueEmpty = function() {
        var empty = true;
        if($('.test-node :visible').size() != 0) {
           empty = false;
        }
        return empty;
    };


    this.toggleClearTestButton = function() {
        if (this.checkQueueEmpty()) {
            $('#clear-tests').hide()
        } else {
            $('#clear-tests').show()
        }
    }
}

var myRunner = new Runner();

var constants = {
    fixedBottom: 20
};

$(function () {
    setSideBarHeight(getSideBarHeight());
    closeSidebar();
    setToggleSidebarCoordinates(getNeededToggleCoordinates());

    $("#open-sidebar").on('click', function () {
        var sidebar = $("#sidebar");
        var visibility = sidebar.css("display");
        if (visibility == 'none') {
            openSidebar();
        }
        else {
            closeSidebar();
        }
    });

    $("#copyright").on('click', function () {
        changeBgZooey()
    });

    $("#cat").on('click', function () {
        changeBgCat()
    });

    $("#edit-list-name").on('click', function () {
        changeDivToInput();
        $(this).css('visibility', 'hidden');
        eventsEditInput()
    });

    $("#sidebar-test-list").slimScroll({
        height: '100%',
        width: '100%'
    });

    $(window).resize(function () {
        setSideBarHeight(getSideBarHeight());
    });

    $('#save-new').on('click', function () {
        if (verifyListName($("#list-name").text())) {
            if ($("#sidebar-test-list").children().size() != 0) {
                myRunner.saveTestList();
            }
            else {
                alert('Nothing to save! Add tests from tests sections.');
            }
        }
    });

    $('#test_list_menu').find('a').on('click', function () {
        if ($(this).attr('href')) {
            myRunner.eventToLoadTestList($(this));
        }
        else {
            openSidebar();
            myRunner.createNewList();
        }
    });

    eventToClosePopup();

    myRunner.setEventToDeleteTestList($('#test_list_menu').find('li'));

});

function openSidebar() {
    var sidebar = $("#sidebar");
    var ico = $("#open-ico");
    sidebar.css('display', 'block');
    ico.addClass('glyphicon-chevron-left');
    ico.removeClass('glyphicon-chevron-right');
    $("#main").css("margin-left", "230px");
    $("#popup").find(".wrap").css("margin-left", "230px");
    setToggleSidebarCoordinates(getNeededToggleCoordinates());
}

function closeSidebar() {
    var sidebar = $("#sidebar");
    var ico = $("#open-ico");
    sidebar.css('display', 'none');
    ico.addClass('glyphicon-chevron-right');
    ico.removeClass('glyphicon-chevron-left');
    $("#main").css("margin-left", "0");
    $("#popup").find(".wrap").css("margin-left", "0");
    setToggleSidebarCoordinates(getNeededToggleCoordinates());
}

function getSideBarHeight() {
    var topNavHeight = $("#topnavbar").height();
    var windowHeight = $(window).height();
    return windowHeight - topNavHeight - constants['fixedBottom']
}
function setSideBarHeight(height) {
    $("#sidebar").height(height);
}

function getNeededToggleCoordinates() {
    var coordinates = {
        left: 0,
        top: 0
    };
    var sidebarWidth = 0;
    if ($("#sidebar").css('display') != 'none') {
        sidebarWidth = $("#sidebar").outerWidth();
    }
    coordinates['left'] = sidebarWidth - 1;
    return coordinates
}

function setToggleSidebarCoordinates(coordinates) {
    var elem = $("#open-sidebar");
    elem.css('left', coordinates['left']);
}

function changeBgZooey() {
    var body = $('body');
    var bg = body.css('background-image');
    if (bg == 'none') {
        body.css("background-image", "url(/assets/zooey.jpg)");
    }
    else {
        body.css('background-image', 'none');
    }
}

function changeBgCat() {
    var body = $('body');
    var bg = body.css('background-image');
    if (bg == 'none') {
        body.css("background-image", "url(/assets/cat-box.jpg)");
    }
    else {
        body.css('background-image', 'none');
    }
}

function changeDivToInput() {
    var listNameDiv = $("#list-name");
    var textFromDiv = listNameDiv.text();
    listNameDiv.text('');
    var input = $('<input class="list-name">');
    input.val(textFromDiv);
    listNameDiv.append(input);
    input.focus();
    input.select();
}

function changeInputToDiv() {
    var textFromInput = $("input.list-name").val();
    if (verifyListName(textFromInput)) {
        var listNameDiv = $("#list-name");
        clearElementInside(listNameDiv);
        listNameDiv.text(textFromInput);
        $("#edit-list-name").css('visibility', 'visible')
    }
}

function eventsEditInput() {
    var input = $("input.list-name");
    input.blur(function () {
        changeInputToDiv();
    });

    input.keypress(function (e) {
        if (e.which == 13) {
            $(this).blur();
        }
    })
}

function verifyListName(listName) {
    if (listName.length > MAX_LENGTH || listName.length < MIN_LENGTH) {
        alert('Name of list is too long or short!(more then ' + MAX_LENGTH + ' or less then ' + MIN_LENGTH + ' symbols)');
        return false;
    }
    var result = true;
    $('#test_list_menu').find('a').each(function () {
        if ($(this).text() == listName) {
            result = confirm('Current list name already exist. Test list will be overwrite!');
        }
    });
    return result;
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
        error: function (e) {
            console.log(e.message);
            failAlert();
        }
    })
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
        error: function (e) {
            console.log(e.message);
            failAlert();
        }
    })
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

function historyEvents() {
    logUpEvent();
    logDownEvent();
    openLogInHistoryEvent();
}

function HtmlEncode(val) {
    return $("<div/>").text(val).html();
}

function HtmlDecode(val) {
    return $("<div/>").html(val).text();
}

function showStartPanel() {
    if (checkEmptyList() == false) {
        $('.start-panel').show();
    }
}

function lockInactiveTab() {
    if (checkEmptyList() == false) {
        var tab = $('.nav-tabs li:not(.active) a');
        tab.attr("data-toggle", "");
        tab.css('background-color', '#eee');
    }
}

function lockActiveBranchSelect() {
    if (checkEmptyList() == false) {
        $('.nav-tabs li.active select.branch').attr('disabled', 'disabled');
    }
}

function unlockActiveBranchSelect() {
    if (checkEmptyList() == true) {
        $('.nav-tabs li.active select.branch').removeAttr('disabled');
    }
}

function unlockAllTab() {
    var tab = $('.nav-tabs li a');
    tab.attr("data-toggle", "tab");
    tab.css('background-color', '');
}

function unlockAllBranchSelect() {
    $('.nav-tabs select.branch').removeAttr('disabled');
}

function unlockInactiveTab() {
    if (checkEmptyList() == true) {
        var tab = $('.nav-tabs li:not(.active) a');
        tab.attr("data-toggle", "tab");
        tab.css('background-color', '');
    }
}

function hideStartPanel() {
    if (checkEmptyList()) {
        $('.start-panel').hide();
    }
}

function checkEmptyList() {
    return $('#sidebar-test-list').children().size() == 0
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
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        });

    })
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
                alert('Test was added in your queue.')
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        });

    })
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
                el.append($("<i class='glyphicon glyphicon-ok icon-green'></i>"))
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        });

    })
}

function addSortableToElem(elem) {
    elem.sortable({ })
}

function showOverlay(text) {
    $('.overlay .overlay-text').text(text);
    $('.overlay').show();
    return false;
}

function hideOverlay() {
    $('.overlay').fadeOut();
    return false;
}

function currentTestOnServer(server_el) {
    return server_el.find('.running').text()
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
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    })
}

function eventsForRspecPopup() {
    eventToOpenDescribe();
    evenToOpenFailDetails();
    setScrollOnMainDescribe();
    setFailedToFailedDescribes();
}

function eventToOpenDescribe() {
    $('.describe-head').on('click', function () {
        var describeChild = $(this).next('.describe-child');
        var cur_display = describeChild.css('display');
        if (cur_display == 'none') {
            describeChild.slideDown()
        } else {
            describeChild.slideUp()
        }
    });
}

function evenToOpenFailDetails() {
    $('.example.failed .example-head').on('click', function () {
        var failDetails = $(this).next('.fail-details');
        var cur_display = failDetails.css('display');
        if (cur_display == 'none') {
            failDetails.slideDown()
        } else {
            failDetails.slideUp()
        }
    })
}

function showPopup() {
    $('.popup-overlay').fadeIn()
}

function closePopup() {
    $('.popup-overlay').fadeOut()
}

function eventToClosePopup() {
    $('.close-result').on('click', function () {
        closePopup()
    });
    $('div.popup-overlay').on('click', function () {
        closePopup()
    });
    stopPropagation($('.popup-window'));
}

function setScrollOnMainDescribe() {
    $('.main-describe').slimScroll({ width: 'auto', height: '100%', size: '3px'})
}

function setFailedToFailedDescribes() {
    $('.describe').each(function () {
        if ($(this).find('.failed').length != 0) {
            $(this).addClass('failed')
        }
    })
}

function eventToOpenMoreOptions(elem) {
    elem.on('click', function(){
        var more_options = $(this).next('.more-options');
        var cur_display = more_options.css('display');
        if (cur_display == 'none') {
            more_options.slideDown()
        } else {
            more_options.slideUp()
        }
    })
}

function eventToShowFullStartOption(elem) {
    elem.hover(
        function() {
            var to_show = $(this).find('.full-command');
            to_show.fadeIn('fast')
        }, function() {
            var to_show = $(this).find('.full-command');
            to_show.fadeOut('fast')
    })
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
        error: function (e) {
            console.log(e.message);
            failAlert();
        },
        complete: function() {
            location.reload();
        }
    })
}

function clearHistoryOnClient(client) {
    $.ajax({
        url: '/clients/clear_history',
        async: false,
        type: 'POST',
        data: {
            'client': client
        },
        beforeSend: function () {
            disableClearHistoryButton();
            showOverlay('Deleting...');
        },
        error: function (e) {
            console.log(e.message);
            failAlert();
        },
        complete: function() {
            location.reload();
        }
    })
}

function disableClearHistoryButton() {
    $('#clear-history').prop('disabled', true);
}

function eventToClearHistoryOnServer(elem) {
    elem.on('click', function(){
        var server_name = $('#server').text();
        clearHistoryOnServer(server_name)
    })
}

function eventToClearHistoryOnClient(elem) {
    elem.on('click', function(){
        var name = $('#client').text();
        clearHistoryOnClient(name)
    })
}

function offEventsOnElem(elem) {
    elem.off();
}

function clearElementInside(elem) {
    elem.html('');
}

function stopPropagation(elem) {
    elem.click(function(e){ e.stopPropagation()})
}

function logUpEvent() {
    $('.log-up').on('click', function () {
        $(this).parent().parent().find('.log').trigger('scrollContent', [-0.02]);
    });
}

function logUpEventToElem(elem) {
    elem.on('click', function () {
        $(this).parent().parent().find('.log').trigger('scrollContent', [-0.02]);
    });
}

function logDownEvent() {
    $('.log-down').on('click', function () {
        $(this).parent().parent().find('.log').trigger('scrollContent', [0.02]);
    })
}

function logDownEventToElem(elem) {
    elem.on('click', function () {
        $(this).parent().parent().find('.log').trigger('scrollContent', [0.02]);
    })
}

function showSectionOverlay() {
    $(".block:last() .section-overlay").show();
}

function hideSectionOverlay() {
    $(".block:last() .section-overlay").hide();
}

function imitateHover(elem) {
    $(elem).mouseenter().mouseleave();
}
//
//$(document).ready(function() {
//
//    myRunner.showservers()
//})


//myRunner.startGovno();
