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
//= require twitter/bootstrap
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

function FileTest(name, stroke_numbers) {
    this.name = name;
    this.stroke_numbers = stroke_numbers;
}

function FileList(name, file_tests) {
    this.name = name;
    this.file_tests = file_tests;
}

function Client(login, file_lists) {
    this.login = login;
    this.file_lists = file_lists;
}

function Runner() {
    const UPDATE_INTERVAL = 1000;
    const STATUS_ONLINE = 0;
    const STATUS_OFFLINE = 1;
    const STATUS_WAIT = 2;
    const SIDE_MAX_TEST_LENGTH = 40;
    var _self = this;

    this.updateInfoFromAllServer = function () {
        setInterval(function () {
            _self.getInfoFromAllServer()
        }, STATUS.UPDATE_INTERVAL);
    };

    this.getSelectedServers = function () {
        var server_names = [];
        $(".server input:checked").each(function () {
            var selected_id = $(this).attr('id');
            server_names.push(selected_id);
        });
        return server_names;
    };

    this.getSelectedTests = function () {
        var test_names = [];
        $(".tab-pane.active .file input:checked").each(function () {
            var selected_id = $(this).attr('id');
            test_names.push(selected_id);
        });
        return test_names;
    };

    this.getRegionFromActiveTab = function () {
        return $('li.active .region').val().split(' ')[1]
    };

    this.getServerFromActiveTab = function () {
        return $('li.active .region').val().split(' ')[0]
    };

    this.getRegionFromSidebar = function () {
        return $('#sidebar .region').val().split(' ')[1]
    };

    this.getServerFromSidebar = function () {
        return $('#sidebar .region').val().split(' ')[0]
    };

    this.getBranch = function () {
        return $('li.active .branch').val();
    };

    this.startTests = function () {
        $.ajax({
            url: 'runner/start',
            type: 'POST',
            data: {
                'selectedServers': this.getSelectedServers(),
                'selectedTests': this.getSelectedTests(),
                'server': this.getServerFromActiveTab(),
                'region': this.getRegionFromActiveTab(),
                'branch': this.getBranch(),
                'project': this.getCurrentProject()
            },
            beforeSend: function () {
                _self.disableStartButtons()
            },
            complete: function () {
                _self.enableStartButtons()
            },
            success: function (data) {
                console.log(data);
                _self.clearServerLogs(_self.getSelectedServers());
                uncheckAllTests();
                uncheckAllServers();
                showAndHideList();
                hideStartButtonFromTabPane();
                alert('successful started')
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.showCurrentRspecResult = function (server_name) {
        $.ajax({
            url: 'servers/show_current_results',
            type: 'POST',
            data: {
                'server': server_name
            },
            success: function (data) {
                showPopupRspecResults();
                $('.rspec-popup-window').html(data);
                eventsForRspecPopup();
            }
        })
    };

    this.eventToShowCurrentRspecResult = function () {
        $('.server .progress-bar').click(function () {
            var server = $(this).parent().parent().parent().parent();
            var server_name = server.find('input').attr('id');
            _self.showCurrentRspecResult(server_name)
        })
    };

    this.disableStartButtons = function () {
        $('.start-icon').attr('disable', 'disabled')
    };

    this.enableStartButtons = function () {
        $('.start-icon').removeAttr('disable')
    };

    this.clearServerLogs = function (servers) {
        for (var i = 0; i < servers.length; i++) {
            _self.clearLogForServer(servers[i]);
        }
    };

    this.clearLogForServer = function (server_name) {
        var server = $('.server #' + server_name).parent();
        if (currentTestOnServer(server) == 'nothing') {
            setLogToServer(server, '')
        }
    };

    this.startTestList = function () {
        $.ajax({
            url: 'runner/start_list',
            type: 'POST',
            data: {
                'selectedServers': this.getSelectedServers(),
                'testList': this.getTestList(),
                'server': this.getServerFromSidebar(),
                'region': this.getRegionFromSidebar(),
                'branch': this.getBranch(),
                'project': this.getCurrentProject()
            },
            beforeSend: function () {
                _self.disableStartButtons()
            },
            complete: function () {
                _self.enableStartButtons()
            },
            success: function (data) {
                console.log(data);
                _self.clearServerLogs(_self.getSelectedServers());
                uncheckAllTests();
                uncheckAllServers();
                showAndHideList();
                hideStartButtonFromTabPane();
                alert('successful started');
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.getSaveRunProperty = function () {
        return $('#save-run').prop('checked')
    };

    this.getInfoFromAllServer = function () {
        $.ajax({
            url: 'runner/get_info',
            type: 'POST',
            data: {
                'servers': _self.getAllServers()
            },
            success: function (data) {
//                console.log(data);
                _self.setDataOnServersView(data);
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.getAllServers = function () {
        var servers = [];
        $('.server input').each(function () {
            servers.push($(this).attr('id'));
        });
        return servers
    };

    this.setDataOnServersView = function (data) {
        for (var i = 0; i < data.length; i++) {
            var selector = '.server input#' + data[i]['name'];
            var server = $(selector).parent();
            server.find('.queue-count').html(data[i]['queue_count']);
            server.find('.running').html(data[i]['current_test']);
            server.find('.run-client').html("<i class='icon-server'></i>" + data[i]['run_client']);
            _self.setQueueToServerView(server.find('.queue'), data[i]['queue']);
            _self.setLogToServerView(server, data[i]['log']);
            _self.setStatusToServerView(server, data[i]['status']);
            _self.setProcessingToServer(server, data[i]['current_test']);
            _self.showStopCurrent(server.find('.stop-current'), data[i]['current_test']);
            _self.showRunOptions(server.find('.run-at'), data[i]['current_test'], data[i]['options']);
            _self.showProcessing(server.find('.progress-bar'), data[i]['current_test'], data[i]['processing']);
        }
    };

    this.showProcessing = function (proc_elem, current_test, proc_value) {
        if (current_test != 'nothing') {
            proc_elem.fadeIn();
            var progress_bar = proc_elem.find('.ui-progress');
            var progress_value = proc_elem.find('.value');
            if (proc_value == '0') {
                progress_bar.css('display', 'none');
                progress_value.text('0%')
            } else {
                progress_bar.css('width', proc_value + '%');
                progress_bar.css('display', 'block');
                progress_value.text(proc_value + '%')
            }
        } else {
            proc_elem.css('display', 'none')
        }
    };

    this.showRunOptions = function (options_view, test, options) {
        if (test == 'nothing') {
            options_view.slideUp();
        } else {
            options_view.slideDown();
            options_view.find('.run-at-value').html(createRunLocationByOptions(options));
        }
    };

    this.showStopCurrent = function (icon, test) {
        if (test == 'nothing') {
            icon.css('display', 'none')
        } else {
            icon.css('display', 'inline-block')
        }
    };

    this.setProcessingToServer = function (server, test) {
        if (test == 'nothing') {
            server.find('.loader').css('display', 'none')
        } else {
            server.find('.loader').css('display', 'inline-block')
        }
    };

    this.setStatusToServerView = function (server, status) {
        if (status == true) {
            server.css('background', 'rgb(161, 187, 26)')
        }
        else {
            server.css('background', 'rgb(153,23,23)')
        }
    };

    this.setLogToServerView = function (server_el, log) {
        // if ((currentLogOnServer(server_el) == '') && (currentTestOnServer(server_el) == 'nothing')) {
        if (log != '') {
            var log_div = server_el.find('.log');
            log_div.html(log.replace(/\n/g, '<br>'));
        }
        //  }
    };

    this.setQueueToServerView = function (queue_div, queue) {
        queue_div.html('');
        var length = queue.length,
            test_name = null;
        if (length != 0) {
            for (var i = 0; i < length; i++) {
                test_name = queue[i]['test'].split('/').slice(-1)[0];
                var elem = '' + (i + 1) + '. ' + test_name;
                queue_div.append($('<label>' + elem + '</label>'))
            }
        }

    };

    this.rerunThread = function (server) {
        $.ajax({
            url: 'runner/rerun_thread',
            type: 'POST',
            async: false,
            data: {
                'server': server
            },
            success: function () {
                alert('Thread was reinitialize and queue was cleared successfully!')
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.rebootServer = function (server) {
        $.ajax({
            url: 'servers/reboot',
            type: 'POST',
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

    this.eventToRerunThread = function () {
        $('i.stop-thread').click(function () {
            var result = confirm('Are you really want to stop all tests on this server?');
            if (result) {
                var server = $(this).parent().parent().parent().parent().parent();
                var server_name = server.find('input').attr('id');
                _self.rerunThread(server_name);
            }
        })
    };

    this.eventToRebootServer = function () {
        $('i.reboot-server').click(function () {
            var server = $(this).parent().parent().parent().parent().parent();
            var server_name = server.find('input').attr('id');
            _self.rebootServer(server_name);
        })
    };

    this.eventToStopThread = function () {
        $('i.stop-current').click(function () {
            var result = confirm('Are you really want to stop this test?');
            if (result) {
                var server = $(this).parent().parent().parent().parent().parent();
                var server_name = server.find('input').attr('id');
                _self.stopCurrent(server_name);
            }
        })
    };

    this.showServers = function () {
        $.ajax({
            url: 'runner/show_servers',
            context: this,
            async: false,
            type: 'POST',
            success: function (data) {
                $("div#servers").html(data);
                _self.serverOpenerEvent();
//                $('input#amazon').prop('checked', true);//КОСТЫЛЬ ДЛЯ ТОГО,ЧТОБЫ СРАЗУ БЫЛ ВЫДЕЛЕН!
                logSlimScrollEvents();
                _self.updateInfoFromAllServer();
                _self.eventToRerunThread();
                _self.eventToRebootServer();
                _self.eventToStopThread();
                _self.eventToShowCurrentRspecResult();
                openQueueEvent();
                openLogEvent();
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.showTests = function () {
        var project = _self.getCurrentProject();
        $.ajax({
            url: 'runner/show_tests',
            context: this,
            async: false,
            type: 'POST',
            success: function (data) {
                $(".tests-block .tab-content").html(data);
                _self.setEventChangeInput();
                _self.setEventToOpenFolder();
                _self.eventToOpenFileInclude();
                _self.eventToAddFile();
                _self.selectProject(project);
            },
            error: function (e) {
                console.log(e.message);
                failAlert();
            }
        })
    };

    this.setEventChangeInput = function () {
        $(".tab-content input").change(function () {
            checkIncluded($(this));
            checkSelectedInputsAndShowRun();
        });

        $(".server input").change(function () {
            checkIncluded($(this));
            checkSelectedInputsAndShowRun();
            showAndHideList();
        });
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
                var trimmed_data = $($.trim(data));
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
        $('#test_list_menu a').each(function () {
            if ($(this).text() == list_menu.find('a').first().text()) {
                checkAlreadyExist = true
            }
        });
        if (checkAlreadyExist != true) {
            $('#test_list_menu').prepend(list_menu);
            var menu_link = list_menu.children('a').first();
            $(menu_link).click(function () {
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
        list_menu.find('i.delete-test-list').click(function () {
            _self.EventToDeleteTestList($(this).parent());
        });
    };

    this.changeBranch = function () {
        var project = _self.getCurrentProject();
        $.ajax({
            url: 'runner/change_branch',
            context: this,
            async: false,
            type: 'POST',
            data: {
                'project': project,
                'branch': _self.getCurrentBranch()
            },
            success: function (data) {
                var startIcon = $(".active .start-icon");
                startIcon.parent().removeClass('with-start');
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
            _self.changeBranch();
            _self.showTests();
            alert('successful changed'); // Знаю что, тупой костыль, но переделывать времени нет
        })
    };

    this.eventToLoadTestList = function (elem) {
        $("#list-name").text(elem.text());
        $.ajax({
            url: 'runner/load_test_list',
            context: this,
            type: 'POST',
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
                _self.showTests();
                _self.setEventToOpenFile($('.file-folder'));
                _self.setEventToDeleteFolderFromList();
                _self.setEventToDeleteTestFromList();
                _self.checkAllAddedOnSidebar();
                addSortableToElem($('.stroke-list'));
                openSidebar();
                showSaveButton();
                showStartList();
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
        $(".folder-name").click(function () {
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
            type: 'POST',
            success: function (data) {
                $('.popup-overlay').css("display", "block");
                $("#popup .wrap").html(data);
                $('.viewer').click(function (e) {
                    e.stopPropagation();
                });
                _self.setEventToCloseTestsList();
                $("#tests-list").slimScroll({
                    height: '100%',
                    width: '790px'
                });
                _self.checkSelectedTests();
                _self.setEventToAddToList($(".add-test"));
                $('#add-all').click(function () {
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
        $(".folder .file-name").click(function () {
            if (_self.checkAddedOnSidebar($(this))) {
                alert('File already added to sidebar! Delete him or choose another!')
            }
            else {
                var path = $(this).prev().prev().attr('id');
                myRunner.showIncludedTests(path);
            }
        })
    };

    this.checkAddedOnSidebar = function (file_name) {
        var name = file_name.parent().find('input').attr('id');
        var icon = file_name.find('i.add-file').css('display');
        var already_add = false;
        if (icon == 'none') {
            $('#sidebar .file-name').each(function () {
                var current_name = $(this).attr('data-qtip');
                if ($(this).parent().children().size() == 1) {
                    if (current_name == name) {
                        already_add = true;
                        return true;
                    }
                }
            });
        }
        return already_add
    };

    this.checkAllAddedOnSidebar = function () {
        _self.makeAllAddButtonsVisible();
        var added_files = _self.getListSidebarFiles();
        $(".tab-content .file-name").each(function () {
            var cur_file = $(this).parent().find('input').attr('id');
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

    this.checkSelectedTests = function () {
        $('#sidebar .file-name').each(function () {
            if ($(this).attr('data-qtip') == $('#test_file_name').attr('data-qtip')) {
                $(this).next().children().children().each(function () {
                    var text = $(this).attr('data-qtip');
                    var stroke = $(this).attr('data-role');
                    $(".subtest-row .test-name").each(function () {
                        if (($(this).text() == text) && ($(this).attr('data-role') == stroke)) {
                            var icon = $(this).prev('.add-test');
                            _self.setIconToAdded(icon);
                        }
                    });
                })
            }
        })
    };

    this.serverOpenerEvent = function () {
        $('.server-opener').click(function () {
            var server_info = $(this).next();
            var currentDisplay = server_info.css('display');
            if (currentDisplay == 'none') {
                server_info.slideDown();
            }
            else {
                server_info.slideUp();
            }
        })
    };

    this.setIconToAdded = function (elem) {
        elem.addClass('added-test');
        elem.removeClass('add-test');
//        elem.addClass('icon-minus-sign');
        elem.removeClass('glyphicon-plus-sign');
    };

    this.setIconToAdd = function (elem) {
        elem.addClass('add-test');
        elem.removeClass('added-test');
        elem.addClass('glyphicon-plus-sign');
//        elem.removeClass('icon-minus-sign');
    };

    this.setEventToCloseTestsList = function () {
        $(".close-list-button").click(function () {
            $('.popup-overlay').fadeOut();
        });
        $('.popup-overlay').click(function () {
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

        var stroke = "<div class='name' data-qtip=\"" + it_name + "\" data-role='" + stroke_number + "'>" +
            cut_it_name +
            "<i class='glyphicon-remove'></i><span class='sidebar-tooltip'>" + HtmlDecode(it_name) + "</span>" +
            "</div>";

        $('#sidebar-test-list .file-name').each(function () {
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
            var file_name_elem = "<div class='file-name' data-qtip='" + file_path + "'><i class='glyphicon-file'></i>" + file_name + "<i class='glyphicon-chevron-down'></i><i class='glyphicon-remove'></i></div>";
            var folder = $("<div class='file-folder'>" + file_name_elem + file_inside + "</div>");

            $("#sidebar-test-list").append(folder);
            _self.setEventToOpenFile(folder);
            _self.setEventToDeleteFolderFromList();
            addSortableToElem(folder.find('.stroke-list'));
        }
        _self.setEventToDeleteTestFromList();
        _self.setIconToAdded(icon_add);
        showSaveButton();
        icon_add.off("click");
        showStartList();
        lockInactiveTab();
        lockActiveBranchSelect();
    };

    this.addFileToSidebar = function (icon) {
        var file_name = icon.parent();
        var text = file_name.text();
        var path = file_name.parent().find('input').attr('id');
        var file_name_elem = "<div class='file-name' data-qtip='" + path + "'><i class='glyphicon-file'></i>" + text + ".rb<i class='glyphicon-remove'></i></div>";
        var folder = $("<div class='file-folder'>" + file_name_elem + "</div>");
        $("#sidebar-test-list").append(folder);
        _self.setEventToDeleteFolderFromList();
        icon.css('display', 'none');
        showSaveButton();
        openSidebar();
        showStartList();
        lockInactiveTab();
        lockActiveBranchSelect();
    };

    this.eventToAddFile = function () {
        var icons = $('.tab-content i.add-file');
        icons.click(function (e) {
            e.stopPropagation();
        });
        icons.click(function () {
            _self.addFileToSidebar($(this));
        })
    };

    this.setEventToAddToList = function (element) {
        $(element).click(function () {
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
        element.find(".glyphicon-chevron-down").click(function () {
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
        $(".name .glyphicon-remove").click(function () {
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
                $('.tab-pane input').each(function () {
                    var current_path = $(this).attr('id');
                    if (current_path == path) {
                        $(this).parent().find('i.add-file').css('display', 'inline-block')
                    }
                });
                folder.remove();
            }
            else {
                stroke_elem.remove();
            }
            hideSaveButton();
            hideStartList();
            unlockInactiveTab();
            unlockActiveBranchSelect();
        });
    };

    this.setEventToDeleteFolderFromList = function () {
        $(".file-name .glyphicon-remove").click(function () {
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
                        var current_path = $(this).parent().parent().find('input').attr('id');
                        if (current_path == path) {
                            $(this).css('display', 'inline-block');
                        }
                    }
                })
            }
            $(this).parent().parent().remove();
            hideSaveButton();
            hideStartList();
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
        hideSaveButton();
        hideStartList();
        unlockInactiveTab();
        unlockActiveBranchSelect();
        _self.makeAllAddButtonsVisible();
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

    $("#open-sidebar").click(function () {
        var sidebar = $("#sidebar");
        var visibility = sidebar.css("display");
        if (visibility == 'none') {
            openSidebar();
        }
        else {
            closeSidebar();
        }
    });

    $("#copyright").click(function () {
        changeBgZooey()
    });

    $("#cat").click(function () {
        changeBgCat()
    });

    $("#edit-list-name").click(function () {
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

    $('.nav-tabs .start-icon').click(function () {
        if ($(this).attr('disable') != 'disabled') {
            myRunner.startTests();
        }
    });

    $('#sidebar .start-icon').click(function () {
        if ($(this).attr('disable') != 'disabled') {
            myRunner.startTestList();
        }
    });

    $('#save-new').click(function () {
        if (verifyListName($("#list-name").text())) {
            if ($("#sidebar-test-list").children().size() != 0) {
                myRunner.saveTestList();
            }
            else {
                alert('Nothing to save! Add tests from tests sections.');
            }
        }
    });

    $('#test_list_menu a').click(function () {
        if ($(this).attr('href')) {
            myRunner.eventToLoadTestList($(this));
        }
        else {
            openSidebar();
            myRunner.createNewList();
        }
    });

    $('.nav-tabs a').click(function () {
        var tab = $(this).parent();
        if (!tab.hasClass('active')) {
            checkInactiveTabAndShowRun();
        }
    });

    myRunner.setEventChangeInput();
    myRunner.setEventToDeleteTestList($('#test_list_menu li'));

});

function logSlimScrollEvents() {
    $('.server .log').slimScroll({
        height: '110px',
        width: '330px',
        color: '#a1bb1a'
    });
    logUpEvent();
    logDownEvent();
}

function openQueueEvent() {
    $('.queue-count').click(function () {
        var queue = $(this).parent().parent().find('.queue');
        if (queue.html() != '') {
            if (queue.css('display') == 'none') {
                queue.slideDown()
            }
            else {
                queue.slideUp()
            }
        }
    })
}

function openLogEvent() {
    $('.show-log').click(function () {
        var log = $(this).parent().parent().find('.log-window');
        if (log.css('display') == 'none') {
            log.slideDown();
        }
        else {
            log.slideUp();
        }
    })
}

function checkIncluded(input) {
    if (input.is(':checked') == true) {
        input.parent().find("input").prop('checked', true);
    }
    else {
        input.parent().find("input").prop("checked", false);
    }
}

function uncheckAllServers() {
    $('#servers input').prop('checked', false)
}

function uncheckAllTests() {
    $('.tests-block input').prop('checked', false)
}

function openSidebar() {
    var sidebar = $("#sidebar");
    var ico = $("#open-ico");
    sidebar.css('display', 'block');
    ico.addClass('glyphicon-chevron-left');
    ico.removeClass('glyphicon-chevron-right');
    $("#main").css("margin-left", "365px");
    $("#popup .wrap").css("margin-left", "365px");
    setToggleSidebarCoordinates(getNeededToggleCoordinates());
}

function closeSidebar() {
    var sidebar = $("#sidebar");
    var ico = $("#open-ico");
    sidebar.css('display', 'none');
    ico.addClass('glyphicon-chevron-right');
    ico.removeClass('glyphicon-chevron-left');
    $("#main").css("margin-left", "0");
    $("#popup .wrap").css("margin-left", "0");
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
        listNameDiv.html('');
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

function checkSelectedInputsAndShowRun() {
    var startIcon = $(".active .start-icon");
    var activeTab = $(".nav.nav-tabs .active a").attr('href');
    var servers_input = $(".server input:checked").length;
    var docsInputs = '';
    if (activeTab == '#docs') {
        docsInputs = $("#docs input:checked").length;
        if (docsInputs > 0 && servers_input > 0) {
            startIcon.parent().addClass('with-start')
        }
        else {
            startIcon.parent().removeClass('with-start')
        }
    }
    else {
        docsInputs = $("#teamlab input:checked").length;
        if (docsInputs > 0 && servers_input > 0) {
            startIcon.parent().addClass('with-start')
        }
        else {
            startIcon.parent().removeClass('with-start')
        }
    }
}

function checkInactiveTabAndShowRun() {
    var startIcon = $(":not(.active) .start-icon");
    var inactiveTab = $(".nav.nav-tabs :not(.active) a").attr('href');
    var servers_input = $(".server input:checked").length;
    var docsInputs = '';
    if (inactiveTab == '#docs') {
        docsInputs = $("#docs input:checked").length;
        if (docsInputs > 0 && servers_input > 0) {
            startIcon.parent().addClass('with-start')
        }
        else {
            startIcon.parent().removeClass('with-start')
        }
    }
    else {
        docsInputs = $("#teamlab input:checked").length;
        if (docsInputs > 0 && servers_input > 0) {
            startIcon.parent().addClass('with-start')
        }
        else {
            startIcon.parent().removeClass('with-start')
        }
    }
}

function hideStartButtonFromTabPane() {
    $(".nav-tabs .start-icon").parent().removeClass('with-start')
}

function verifyListName(listName) {
    if (listName.length > MAX_LENGTH || listName.length < MIN_LENGTH) {
        alert('Name of list is too long or short!(more then ' + MAX_LENGTH + ' or less then ' + MIN_LENGTH + ' symbols)');
        return false;
    }
    var result = true
    $('#test_list_menu a').each(function () {
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
        type: 'POST',
        data: {
            'showed': current_showed,
            'server': server
        },
        success: function (data) {
            var trimmed_data = $($.trim(data));
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

function showMoreHistoryForClient() {
    var current_showed = $('tbody tr').length;
    var name = $('#client').text();
    $.ajax({
        url: '/client_history/show_more',
        context: this,
        type: 'POST',
        data: {
            'showed': current_showed,
            'name': name
        },
        success: function (data) {
            var trimmed_data = $($.trim(data));
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

function logUpEvent() {
    $('.log-up').click(function () {
        $(this).parent().parent().find('.log').trigger('scrollContent', [-0.02]);
    });
}

function logUpEventToElem(elem) {
    elem.click(function () {
        $(this).parent().parent().find('.log').trigger('scrollContent', [-0.02]);
    });
}

function logDownEvent() {
    $('.log-down').click(function () {
        $(this).parent().parent().find('.log').trigger('scrollContent', [0.02]);
    })
}

function logDownEventToElem(elem) {
    elem.click(function () {
        $(this).parent().parent().find('.log').trigger('scrollContent', [0.02]);
    })
}

function openLogInHistoryEvent() {
    $('.history-log').click(function () {
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
    elem.click(function () {
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

function showSaveButton() {
    if (checkEmptyList() == false) {
        $('#save-new').css('display', 'block')
    }
}

function showStartList() {
    if ((checkEmptyList() == false) && (checkSelectedServer())) {
        $('.start-list').css('display', 'block')
    }
}

function showAndHideList() {
    showStartList();
    hideStartList();
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

function hideStartList() {
    if ((checkEmptyList()) || (checkSelectedServer() == false)) {
        $('.start-list').css('display', 'none')
    }
}

function hideSaveButton() {
    if (checkEmptyList()) {
        $('#save-new').css('display', 'none')
    }
}

function checkEmptyList() {
    return $('#sidebar-test-list').children().size() == 0
}

function checkSelectedServer() {
    return $('.server input:checked').size() != 0
}


function createRunLocationByOptions(options) {
    if ((options['portal_type'] == null) && (options['portal_region'] != null)) {
        return options['portal_region']
    } else if ((options['portal_type'] != null) && (options['portal_region'] == null)) {
        return options['portal_type']
    } else if ((options['portal_type'] != null) && (options['portal_region'] != null)) {
        return options['portal_type']
    }
    else {
        return "don't know location(all null)";
    }
}

function eventToDeleteHistoryLine(elem) {
    elem.click(function () {
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

function eventToSetAnalysedToHistory(elem) {
    elem.click(function () {
        var clicked = $(this);
        $.ajax({
            url: '/history/set_analysed',
            async: false,
            type: 'POST',
            data: {
                'id': clicked.attr('data-id')
            },
            success: function () {
                var el = clicked.parent();
                el.html('');
                el.append($("<i class='glyphicon-ok'></i>"))
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

function currentLogOnServer(server_el) {
    return server_el.find('.log').text()
}

function setLogToServer(server_el, logl) {
    server_el.find('.log').html(logl)
}

function eventToOpenRspecResults(elem) {
    elem.click(function () {
        var clicked = $(this);
        $.ajax({
            url: '/history/show_html_results',
            async: false,
            type: 'POST',
            data: {
                'history_id': clicked.attr('data-id')
            },
            success: function (data) {
                showPopupRspecResults();
                $('.rspec-popup-window').html(data)
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
    eventToCloseRspecPopup();
    eventToOpenDescribe();
    evenToOpenFailDetails();
    setScrollOnMainDescribe();
    setFailedToFailedDescribes();
}

function eventToOpenDescribe() {
    $('.describe-head').click(function () {
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
    $('.example.failed .example-head').click(function () {
        var failDetails = $(this).next('.fail-details');
        var cur_display = failDetails.css('display');
        if (cur_display == 'none') {
            failDetails.slideDown()
        } else {
            failDetails.slideUp()
        }
    })
}

function showPopupRspecResults() {
    $('.rspec-overlay').fadeIn()
}

function closePopupRspecResults() {
    $('.rspec-overlay').fadeOut()
}

function eventToCloseRspecPopup() {
    $('.close-result').click(function () {
        closePopupRspecResults()
    });
    $('div.rspec-overlay').click(function () {
        closePopupRspecResults()
    });
    $('.rspec-popup-window').click(function (e) {
        e.stopPropagation();
    });
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
    elem.click(function(){
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

function enableClearHistoryButton() {
    $('#clear-history').prop('disabled', false);
}

function eventToClearHistoryOnServer(elem) {
    elem.click(function(){
        var server_name = $('#server').text();
        clearHistoryOnServer(server_name)
    })
}

function eventToClearHistoryOnClient(elem) {
    elem.click(function(){
        var name = $('#client').text();
        clearHistoryOnClient(name)
    })
}

//
//$(document).ready(function() {
//
//    myRunner.showservers()
//})


//myRunner.startGovno();
