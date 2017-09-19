/**
 * Created by lobashov-2 on 21.05.17.
 */

function getCurrentBranch() {
    return $('#project-tab-header li.active option:selected').val();
}

function getDocBranch() {
    return $('#docs-branches').val();
}

function getTmBranch() {
    return $('#teamlab-branches').val();
}

function getSelectedPortalUrl() {
    return $('#portal-list option:selected').val();
}

function getCurrentProject() {
    return $('#project-tab-header li.active a').attr('href');
}

function selectProject(project) {
    var docsTab = $('div#docs');
    var tmTab = $('div#teamlab');
    var currentActive = $('.nav-tabs li.active');
    $('.nav.nav-tabs a').each(function () {
        if ((project == 'docs') && ($(this).attr('href') == '#docs')) {
            currentActive.removeClass('active');
            $(this).parent().addClass('active');
            docsTab.addClass('active');
            tmTab.removeClass('active');
        }
        if ((project == 'teamlab') && ($(this).attr('href') == '#teamlab')) {
            currentActive.removeClass('active');
            $(this).parent().addClass('active');
            tmTab.addClass('active');
            docsTab.removeClass('active');
        }
    });
}