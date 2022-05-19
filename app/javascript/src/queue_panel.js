/**
 * Created by lobashov-2 on 10.03.17.
 */

window.setDataOnQueuePanel = function(queue_data) {
    showBookedServers(queue_data.servers);
    setBookedServersCount(queue_data.servers.length);
    showTestsFromQueue(queue_data.tests);
    showTestsInQueueCount(queue_data.tests.length);
};
window.showBookedServers = function(servers) {
    var sortedServers = servers.sort();
    for(var i = 0; i < sortedServers.length; i++) {
        appendServerOnQueue(sortedServers[i]);
    }
};
window.appendServerOnQueue = function(server) {
    var node = $('<div class="server-node"><i class="fa fa-hdd"></i></div>');
    var label = $('<label>').text(server);
    label.attr('title', server);
    node.append(label);
    $('#server-queue').append(node);
};
window.setBookedServersCount = function(serversCount) {
    $('#booked-servers-title').text('Servers (' + serversCount + ')');
};
window.showTestsFromQueue = function(tests) {
    for(var i = 0; i < tests.length; i++) {
        appendTestsOnQueue(tests[i]);
    }
};
window.appendTestsOnQueue = function(test) {
    if (typeof regionSelector === 'undefined') {
        generateRegionSelect();
    }
    var props = $('<div class="props"></div>');
    props.append($('<label>').text(test.tm_branch).attr('title', 'OnlyOffice branch:' + test.tm_branch));
    props.append($('<label>').text(test.doc_branch).attr('title', 'Docs branch:' + test.doc_branch));
    props.append($('<label>').text(test.location).attr('title', 'Region: ' + test.location));
    props.append($('<label>').text(test.spec_browser).attr('title', 'Spec Browser: ' + test.spec_browser));
    props.append($('<label>').text(test.spec_language).attr('title', 'Spec Language: ' + test.spec_language));
    var name = $('<div class="name"><i class="fa fa-leaf"></i>' + test.test_name + '</div>');
    var testNode = $('<div class="test-node" data-id="' + test.id + '" data-path="' + test.test_path + '" title="' + test.test_path + '"></div>');
    testNode.append(name);
    testNode.append(props);
    $('#test-queue').append(testNode);
};
window.showTestsInQueueCount = function(testsCount) {
    $('#test-queue-title').text('Tests (' + testsCount + ')');
};

window.checkQueueEmpty = function() {
    return !document.getElementById('test-queue').hasChildNodes();
};

window.toggleClearTestButton = function() {
    if (checkQueueEmpty()) {
        $('#clear-tests').hide();
    } else {
        $('#clear-tests').show();
    }
};

window.toggleShuffleTestButton = function() {
    if (checkQueueEmpty()) {
        $('#shuffle-tests').hide();
    } else {
        $('#shuffle-tests').show();
    }
};

window.toggleRemoveDuplicatesQueue = function() {
    if (checkQueueEmpty()) {
        $('#remove-duplicates-tests').hide();
    } else {
        $('#remove-duplicates-tests').show();
    }
};

window.generateRegionSelect = function() {
    regionSelector = '';
    getRegionList().forEach(function(entry) {
        regionSelector += '<option>' + entry + '</option>';
    });
    return regionSelector;
};

window.getRegionList = function() {
    var optionValues = [];

    $('#list-region option').each(function() {
        optionValues.push($(this).val());
    });
    return optionValues;
};

window.addTestInQueue = function(test_path, branch, location) {
    $.ajax({
        url: 'queue/add_test',
        context: this,
        async: false,
        data: {
            'test_path': test_path,
            'branch': branch,
            'location': location,
            'spec_browser': getSpecBrowser(),
            'spec_language': getSpecLanguage(),
            'teamlab_branch': getDocBranch(),
            'doc_branch': getDocBranch()
        },
        type: 'POST',
        success: function () {

        },
        error: function (xhr, type, errorThrown) {
            ajaxErrorUnlessPageRefresh(xhr, type, errorThrown);
        }
    });
};
