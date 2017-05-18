/**
 * Created by lobashov-2 on 18.05.17.
 */

function setEventToOpenFolder() {
    $(".folder-name").on('click', function () {
        var currentDisplay = $(this).next(".folder-inside").css("display");
        var icon = $(this).children("i");
        if (currentDisplay == "none") {
            $(this).next(".folder-inside").css("display", "block");
            icon.addClass("glyphicon-folder-open");
            icon.removeClass("glyphicon-folder-close");
        }
        else {
            $(this).next(".folder-inside").css("display", "none");
            icon.addClass("glyphicon-folder-close");
            icon.removeClass("glyphicon-folder-open");
        }
    });
}