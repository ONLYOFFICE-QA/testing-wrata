/**
 * Created by lobashov-2 on 21.05.17.
 */

function eventOnChangeProject() {
    $('.nav.nav-tabs li').on('click', function () {
        renderFileTree();
    });
}