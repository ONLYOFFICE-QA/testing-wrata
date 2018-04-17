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
    });
}

function setEventToDeleteFolderFromList() {
    $(".file-name .glyphicon-remove").on('click', function () {
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
    $(".name .glyphicon-remove").on('click', function () {
        hideStartPanel();
        unlockInactiveTab();
        unlockActiveBranchSelect();
    });
}

function setEventToAddToList(element) {
    $(element).on('click', function () {
        addTestToList($(this));
        openSidebar();
        var path = $('#test_file_name').attr('data-qtip');
        $('.tab-pane.active input').each(function () {
            var current_path = $(this).attr('id');
            if (current_path == path) {
                $(this).parent().find('i.add-file').css('display', 'none');
            }
        });
    });
}

function addTestToList(icon_add) {
    setEventToDeleteTestFromList();
    setIconToAdded(icon_add);
    showStartPanel();
    icon_add.off("click");
    lockInactiveTab();
    lockActiveBranchSelect();
}