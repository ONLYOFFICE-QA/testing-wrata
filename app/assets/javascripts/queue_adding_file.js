
function setIconToAdded(elem) {
    elem.addClass('added-test');
    elem.removeClass('add-test');
    elem.removeClass('glyphicon glyphicon-plus-sign');
}

function setIconToAdd(elem) {
    elem.addClass('add-test');
    elem.removeClass('added-test');
    elem.addClass('glyphicon glyphicon-plus-sign');
}
