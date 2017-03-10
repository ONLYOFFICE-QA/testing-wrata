/**
 * Created by lobashov-2 on 10.03.17.
 */

function getUpdatedDataFromServer() {
    $.ajax({
        url: 'runner/updated_data',
        type: 'GET',
        async: false,
        data: {
            'servers': _self.getAllServers()
        },
        success: function (data) {
            _self.setDataOnServersView(data.servers_data);
            _self.clearServersQueue();
            _self.clearTestsQueue();
            _self.setDataOnQueuePanel(data.queue_data);
            _self.toggleClearTestButton();
            _self.toggleShuffleTestButton();
            _self.toggleRemoveDuplicatesQueue();
            toggleUnbookAllServersButton();
            _self.toggleStopAllBookedServers();
        },
        error: function (e) {
            console.log(e.message);
        }
    });
}