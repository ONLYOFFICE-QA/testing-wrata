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