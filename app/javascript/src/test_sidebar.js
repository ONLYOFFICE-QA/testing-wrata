/**
 * Created by lobashov-2 on 21.05.17.
 */

window.getSidebarFileTest = function(file_folder) {
    var file_name = file_folder.find('.file-name').attr('data-qtip');
    var file_test = {};
    file_test.file_name = file_name;
    return file_test;
};

window.getTestFiles = function(server_tests_list) {
    var file_tests = [];
    server_tests_list.each(function () {
        var file_test = getSidebarFileTest($(this));
        file_tests.push(file_test);
    });
    return file_tests;
};

window.addFileToSidebar = function(icon) {
    var file_name = icon.parent();
    var text = file_name.text();
    var path = file_name.parent().find('.add-button-file').attr('full-path');
    var file_name_elem = "<div class='file-name shower' data-qtip='" + path + "'><i class='fa fa-file'></i><div class='file-name-text'>" + text + "</div><i class='fa fa-times'></i><span class='hidden-tool'>" + text + "</span></div>";
    var folder = $("<div class='file-folder'>" + file_name_elem + "</div>");
    $("#sidebar-test-list").append(folder);
    setEventToDeleteFolderFromList();
    icon.css('display', 'none');
    showStartPanel();
    openSidebar();
    lockInactiveTab();
    lockActiveBranchSelect();
};

window.eventToAddFile = function() {
    var icons = $('.tab-content i.add-file');
    offEventsOnElem(icons);
    icons.on('click', function () {
        addFileToSidebar($(this));
    });
};