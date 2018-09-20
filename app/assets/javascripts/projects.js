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

function eventOnChangeBranch() {
    $('#docs-branches').change(function () {
        renderFileTree();
    });
}