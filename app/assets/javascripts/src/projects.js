/**
 * Created by lobashov-2 on 21.05.17.
 */

window.eventOnChangeProject = function() {
    $('#projects_0').change(function () {
        setTimeout(function() {
            fetchBranchesAndShowFiles();
        }, 100);
    });
};

window.selectProject = function(project) {
    $("#projects_0").filter(function () {
        return $(this).html() == project;
    }).prop('selected', true);
};

window.eventOnChangeBranch = function() {
    $('#docs-branches').change(function () {
        renderFileTree();
    });
};