/**
 * Created by lobashov-2 on 18.05.17.
 */

function htmlFileTree(treeNode) {
    var resultHtml = '';
    var name = treeNode.name;
    if ('children' in treeNode) {
        var children = treeNode.children;
        resultHtml += '<div class="folder">';
        resultHtml += '<div class="add-button-folder active" data-test="' + name + ' style="">add</div>';
        resultHtml += '<div class="folder-name"><i class="glyphicon glyphicon-folder-close"></i>' + name + "</div>";
        resultHtml += '<div class="folder-inside" style="display: none">';
        for (var i = 0, len = children.length; i < len; i++) {
            resultHtml += htmlFileTree(children[i]);
        }
        resultHtml += '</div>';
        resultHtml += '</div>';
    } else {
        resultHtml += '<div class="file">';
        resultHtml += '<div class="add-button-file active" data-test="' + name + '" style="">add</div>';
        resultHtml += '<div class="file-name">';
        resultHtml += '<i class="glyphicon glyphicon-file"></i>' + name;
        resultHtml += '<i class="add-file glyphicon glyphicon-plus-sign"></i>';
        resultHtml += '</div>';
        resultHtml += '</div>';
    }
    return resultHtml;
}

function renderFileTree(project, ref) {
    $.ajax({
        url: 'runner/file_tree',
        type: 'GET',
        data: {
            'project': project,
            'refs': ref
        },
        beforeSend: function () {
            showOverlay('Fetching Github FileTree');
        },
        complete: function () {
            hideOverlay();
        },
        success: function (data) {
            var dataJson = JSON.parse(data);
            var html_data = htmlFileTree(dataJson);
            var fileTab = $(".tests-block .tab-content")
            fileTab.html(html_data);
            setEventToOpenFolder();
            eventToAddFile();
            selectProject(project);
            eventToAddTestInQueue(html_data.find('.add-button-file'));
            eventToAddFolderInQueue(html_data.find('.add-button-folder'));
            addFullPaths(fileTab);
        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
}
