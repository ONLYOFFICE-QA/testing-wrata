// function copyKeysToClipboard() {
window.copyKeysToClipboard = function() {
    var dataToCopy = $('#api-keys');
    selectObjectForCopy(dataToCopy);
    document.execCommand('copy');
    dataToCopy.fadeOut('normal', function () {
        dataToCopy.delay(200).fadeIn();
    });
};
