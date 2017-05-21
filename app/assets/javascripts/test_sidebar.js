/**
 * Created by lobashov-2 on 21.05.17.
 */

function getSidebarFileTest(file_folder) {
    var file_name = file_folder.find('.file-name').attr('data-qtip');
    var file_test = {};
    file_test.file_name = file_name;
    if (file_folder.children().size() > 1) {
        var strokes = [];
        file_folder.find('.name').each(function () {
            var stroke = {};
            stroke.name = $(this).attr('data-qtip');
            stroke.number = $(this).attr('data-role');
            strokes.push(stroke);
        });
        file_test.strokes = strokes;
    }
    return file_test;
}

function getTestFiles(server_tests_list) {
    var file_tests = [];
    server_tests_list.each(function () {
        var file_test = getSidebarFileTest($(this));
        file_tests.push(file_test);
    });
    return file_tests;
}