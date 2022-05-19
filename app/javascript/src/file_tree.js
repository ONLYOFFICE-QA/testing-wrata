/**
 * Created by lobashov-2 on 18.05.17.
 */

window.htmlFileTree = function(treeNode) {
    var resultHtml = '';
    var name = treeNode.name;
    if ('children' in treeNode) {
        var children = treeNode.children;
        resultHtml += '<div class="folder">';
        resultHtml += '<div class="add-button-folder active" data-test="' + name + '" style="">add</div>';
        resultHtml += '<div class="folder-name"><i class="fa fa-folder"></i>' + name + "</div>";
        resultHtml += '<div class="folder-inside" style="display: none">';
        children.forEach(element => (resultHtml += htmlFileTree(element)));
        resultHtml += '</div>';
        resultHtml += '</div>';
    } else if (treeNode.constructor === Array) {
        treeNode.forEach(element => (resultHtml += htmlFileTree(element)));
    }
    else {
        resultHtml += '<div class="file">';
        resultHtml += '<div class="add-button-file active" data-test="' + name + '" style="">add</div>';
        resultHtml += '<div class="file-name">';
        resultHtml += '<i class="fa fa-file"></i>' + name;
        resultHtml += '<i class="add-file fa fa-plus-circle"></i>';
        resultHtml += '</div>';
        resultHtml += '</div>';
    }
    return resultHtml;
};

window.renderFileTree = function(project, ref) {
    if (project === undefined) {
        project = activeProject();
    }
    if (ref === undefined) {
        ref = getDocBranch();
    }
    $.ajax({
        url: 'runner/file_tree',
        type: 'GET',
        data: {
            'project': project,
            'refs': ref
        },
        beforeSend: function () {
            showFileTreeOverlay();
        },
        complete: function () {
            hideFileTreeOverlay();
        },
        success: function (data) {
            var dataJson = JSON.parse(data);
            var html_data = htmlFileTree(dataJson.children);
            var fileTab = $(".tests-block .tab-content .tab-pane");
            fileTab.html(html_data);
            setEventToOpenFolder();
            eventToAddFile();
            selectProject(project);
            eventToAddTestInQueue(fileTab.find('.add-button-file'));
            eventToAddFolderInQueue(fileTab.find('.add-button-folder'));
            addFullPaths(fileTab);
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
};

window.activeProject = function() {
    return $('#projects_0 option:selected').val();
};

window.showFileTreeOverlay = function() {
    $(".section-overlay.file-tree-overlay").show();
};

window.hideFileTreeOverlay = function() {
    $(".section-overlay.file-tree-overlay").hide();
};

window.fetchBranchesAndShowFiles = function() {
    fetchBranches(activeProject(), $('#docs-branches'));
};

window.fetchBranches = function(project, control) {
    $.ajax({
        url: 'runner/branches',
        context: this,
        async: true,
        type: 'GET',
        data: {
            project: project
        },
        beforeSend: function () {
            showFileTreeOverlay();
        },
        success: function (data) {
            setGitReferences(control, data.branches, data.tags);
            renderFileTree(project, getDocBranch());
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
};


window.setGitReferences = function(control, branches, tags) {
    clearElementInside(control);
    control.append($("<option disabled>Branches</option>"));
    branches.forEach(element => (control.append($("<option>" + element + "</option>"))));
    control.append($("<option disabled>Tags</option>"));
    tags.forEach(element => (control.append($("<option>" + element + "</option>"))));
};