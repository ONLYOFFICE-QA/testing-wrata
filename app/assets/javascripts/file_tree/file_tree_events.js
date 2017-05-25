/**
 * Created by lobashov-2 on 18.05.17.
 */

function setEventToOpenFolder() {
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
}

function eventToAddTestInQueue(elem) {
    elem.on('click', function(){
        addTestInQueue($(this).attr('full-path'), getCurrentBranch(), $('li.active .region').val());
        getUpdatedDataFromServer();
        imitateHover($('.test-node :first'));
    });
}

function addFolderInQueue(folder_elem) {
    var tests = [];
    folder_elem.find('.add-button-file').each(function(){
        tests.push($(this).attr('full-path'));
    });
    if (tests.length !== 0) {
        var branch = getCurrentBranch();
        var location = $('li.active .region').val();
        addTestsInQueue(tests, branch, location);
    }

}

function eventToAddFolderInQueue(folder_elem) {
    folder_elem.on('click', function(){
        addFolderInQueue($(this).parent());
        getUpdatedDataFromServer();
    });
}