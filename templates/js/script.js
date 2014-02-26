/**
 * Created by testpc-37 on 2/20/14.
 */

$(function(){
    var removeIntent = false;
    $('#sortme').sortable({
        over: function () {
            removeIntent = false;
        },
        out: function () {
            removeIntent = true;
        },
        beforeStop: function (event, ui) {
            if(removeIntent == true){
	      console.log (ui.item)
                ui.item.remove();
		alert(ui.item.attr('data-id'))
            }
        },
        update: function(event, ui) {
            var first = ui.item.attr('data-id');
            alert(first);
            alert(ui.item.prev().attr('data-id'));
        }
    });
});


// 1 2 3 4 5 6 7

//   2


//          2

// 1 3 4 5 2 6 7