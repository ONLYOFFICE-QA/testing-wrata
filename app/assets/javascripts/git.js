/**
 * Created by lobashov-2 on 21.05.17.
 */

function getCurrentBranch() {
    return $('.active select.branch option:selected').val();
}

function getCurrentProject() {
    return $('.tab-pane.active').attr('id');
}