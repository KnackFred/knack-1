var warnMessage = "Did you buy a gift? \n\nIf you did, please stay on this page and confirm your order so we can remove the gift from the registry.";

window.onbeforeunload = function () {
    if (warnMessage != null) return warnMessage;
}

giftWin = null;

$(function(){

    $('input:submit').click(function(e) {
        warnMessage = null;
    });

    $('#cancel').click(function(e) {
        warnMessage = null;
        if (giftWin != null) {
            giftWin.close();
        }
        window.opener.closeBuyExtWindows();
    });

    $('#dont-see-link').click(function(e) {
        e.preventDefault();
        $('#dont-see').slideToggle();
    });

    $('#dont-see-page-link').click(function(e) {
        e.preventDefault();
        giftWin = window.open($(this).attr('href'), "GiftPage", ('width=' + (screen.availWidth-290) + ',height=' + (screen.availHeight) + ',top=0,left=290'));
    });

});


