/**
 * Created by lobashov-2 on 21.05.17.
 */


function getTestList() {
    var name = $('#list-name').text();
    var file_selectors = $('.file-folder');
    var file_tests = getTestFiles(file_selectors);
    var file_list = {};                        //
    file_list.name = name;             //LIKE
    file_list.file_tests = file_tests;      //HASH
    return file_list;                          //
}

function createNewList() {
    $("#sidebar-test-list").html("");
    $("#list-name").text("New Test List");
    hideStartPanel();
    unlockInactiveTab();
    unlockActiveBranchSelect();
    makeAllAddButtonsVisible();
}

function makeAllAddButtonsVisible() {
    $('.tab-content i.add-file').each(function () {
        $(this).css('display', 'inline-block');
    });
}

function setEventToOpenFile(element) {
    element.find(".fa fa-chevron-down").on('click', function () {
        // var elem = $(this).next(); //$('#idtest').is(':visible')
        var inside = element.find(".file-inside");
        var currentDisplay = inside.css("display");
        if (currentDisplay == "none") {
            inside.slideDown();
        }
        else {
            inside.slideUp();
        }
    });
}

function setEventToDeleteFolderFromList() {
    $(".file-name .fa-times").on('click', function () {
        if ($('#popup').is(':hidden')) {
            var path = $(this).parent().attr('data-qtip');
            $('.tab-content i.add-file').each(function () {
                var display = $(this).css('display');
                if (display == 'none') {
                    var current_path = $(this).parent().parent().find('.add-button-file').attr('full-path');
                    if (current_path == path) {
                        $(this).css('display', 'inline-block');
                    }
                }
            });
        }
        $(this).parent().parent().remove();
        hideStartPanel();
        unlockInactiveTab();
        unlockActiveBranchSelect();
    });
}


function setEventToDeleteTestFromList() {
    $(".name .fa-times").on('click', function () {
        hideStartPanel();
        unlockInactiveTab();
        unlockActiveBranchSelect();
    });
}
