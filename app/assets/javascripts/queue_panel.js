/**
 * Created by lobashov-2 on 10.03.17.
 */

function setDataOnQueuePanel(queue_data) {
    showBookedServers(queue_data.servers);
    setBookedServersCount(queue_data.servers.length);
    showTestsFromQueue(queue_data.tests);
    showTestsInQueueCount(queue_data.tests.length);
}
function showBookedServers(servers) {
    var sortedServers = servers.sort();
    for(var i = 0; i < sortedServers.length; i++) {
        appendServerOnQueue(sortedServers[i]);
    }
}
function appendServerOnQueue(server) {
    var node = $('<div class="server-node"><i class="fa fa-hdd"></i></div>');
    var label = $('<label>').text(server);
    label.attr('title', server);
    node.append(label);
    $('#server-queue').append(node);
}
function setBookedServersCount(serversCount) {
    $('#booked-servers-title').text('Servers (' + serversCount + ')');
}
function showTestsFromQueue(tests) {
    for(var i = 0; i < tests.length; i++) {
        appendTestsOnQueue(tests[i]);
    }
}
function appendTestsOnQueue(test) {
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
}
function showTestsInQueueCount(testsCount) {
    $('#test-queue-title').text('Tests (' + testsCount + ')');
}

function checkQueueEmpty() {
    return !document.getElementById('test-queue').hasChildNodes();
}

function toggleClearTestButton() {
    if (checkQueueEmpty()) {
        $('#clear-tests').hide();
    } else {
        $('#clear-tests').show();
    }
}

function toggleShuffleTestButton() {
    if (checkQueueEmpty()) {
        $('#shuffle-tests').hide();
    } else {
        $('#shuffle-tests').show();
    }
}

function toggleRemoveDuplicatesQueue() {
    if (checkQueueEmpty()) {
        $('#remove-duplicates-tests').hide();
    } else {
        $('#remove-duplicates-tests').show();
    }
}

function generateRegionSelect() {
    regionSelector = '';
    getRegionList().forEach(function(entry) {
        regionSelector += '<option>' + entry + '</option>';
    });
    return regionSelector;
}

function getRegionList() {
    var optionValues = [];

    $('#list-region option').each(function() {
        optionValues.push($(this).val());
    });
    return optionValues;
}

function addTestInQueue(test_path, branch, location) {
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
}
