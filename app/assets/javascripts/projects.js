/**
 * Created by lobashov-2 on 21.05.17.
 */

function eventOnChangeProject() {
    $('#projects_0').change(function () {
        setTimeout(function() {
            fetchBranchesAndShowFiles();
        }, 100);
    });
}

function selectProject(project) {
    $("#projects_0").filter(function () {
        return $(this).html() == project;
    }).prop('selected', true);
}

function eventOnChangeBranch() {
    $('#docs-branches').change(function () {
        renderFileTree();
    });
}