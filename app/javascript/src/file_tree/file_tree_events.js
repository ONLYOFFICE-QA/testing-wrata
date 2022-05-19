/**
 * Created by lobashov-2 on 18.05.17.
 */

window.setEventToOpenFolder = function() {
    $(".folder-name").on('click', function () {
        var currentDisplay = $(this).next(".folder-inside").css("display");
        var icon = $(this).children("i");
        if (currentDisplay == "none") {
            $(this).next(".folder-inside").css("display", "block");
            icon.addClass("fa-folder-open");
            icon.removeClass("fa-folder");
        }
        else {
            $(this).next(".folder-inside").css("display", "none");
            icon.addClass("fa-folder");
            icon.removeClass("fa-folder-open");
        }
    });
};

window.eventToAddTestInQueue = function(elem) {
    elem.on('click', function(){
        addTestInQueue($(this).attr('full-path'), getDocBranch(), getSelectedPortalUrl());
        getUpdatedDataFromServer();
        imitateHover($('.test-node :first'));
    });
};

window.addFolderInQueue = function(folder_elem) {
    var tests = [];
    folder_elem.find('.add-button-file').each(function(){
        tests.push($(this).attr('full-path'));
    });
    if (tests.length !== 0) {
        var branch = getDocBranch();
        var location = getSelectedPortalUrl();
        addTestInQueue(tests, branch, location);
    }

};

window.eventToAddFolderInQueue = function(folder_elem) {
    folder_elem.on('click', function(){
        addFolderInQueue($(this).parent());
        getUpdatedDataFromServer();
    });
};