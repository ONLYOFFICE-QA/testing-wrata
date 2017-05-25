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
        if ($('#popup').is(':visible')) {
            $(this).parent().next().children().children().each(function () {
                var text = $(this).attr('data-qtip');
                var stroke = $(this).attr('data-role');
                $(".subtest-row .test-name").each(function () {
                    if (($(this).text() == text) && ($(this).attr('data-role') == stroke)) {
                        var icon = $(this).prev('.added-test');
                        setIconToAdd(icon);
                        setEventToAddToList(icon);
                    }
                });
            });
        }
        else {
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
    var text = "";
    var stroke = "";
    $(".name .glyphicon-remove").on('click', function () {
        var stroke_elem = $(this).parent();
        text = stroke_elem.attr('data-qtip');
        stroke = stroke_elem.attr('data-role');
        $(".subtest-row .test-name").each(function () {
            if (($(this).text() == text) && ($(this).attr('data-role') == stroke)) {
                var icon = $(this).prev('.added-test');
                setIconToAdd(icon);
                setEventToAddToList(icon);
            }
        });
        var stroke_size = stroke_elem.parent().children().length;
        if (stroke_size == 1) {
            var folder = stroke_elem.parent().parent().parent();
            var path = folder.find('.file-name').attr('data-qtip');
            $('.tab-pane .add-button-file').each(function () {
                var current_path = $(this).attr('full-path');
                if (current_path == path) {
                    $(this).parent().find('i.add-file').css('display', 'inline-block');
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
    const SIDE_MAX_TEST_LENGTH = 40;
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
    if (file_added === false) {
        var stroke_list = "<div class='stroke-list'>" + stroke + "</div>";
        var file_inside = "<div class='file-inside'>" + stroke_list + "</div>";
        var file_name_elem = "<div class='file-name shower' data-qtip='" + file_path + "'><i class='glyphicon glyphicon-file'></i><div class='file-name-text'>" + file_name + "</div><i class='glyphicon glyphicon-remove'></i><span class='hidden-tool'>" + file_name + "</span></div>";
        var folder = $("<div class='file-folder'>" + file_name_elem + file_inside + "</div>");

        $("#sidebar-test-list").append(folder);
        setEventToOpenFile(folder);
        setEventToDeleteFolderFromList();
        $('*[full-path="' + file_path + '"]').parent().find('i.add-file').hide();
        addSortableToElem(folder.find('.stroke-list'));
    }
    setEventToDeleteTestFromList();
    setIconToAdded(icon_add);
    showStartPanel();
    icon_add.off("click");
    lockInactiveTab();
    lockActiveBranchSelect();
}