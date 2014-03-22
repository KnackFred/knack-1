var giftWin = null;
var instructionsWin = null;

function closeBuyExtWindows () {
    if (giftWin != null) {
        giftWin.close();
    }
    if (instructionsWin != null) {
        instructionsWin.close();
    }
}
$(function(){
    $('.contribute-ext').click(function(event){
        event.preventDefault();

        $('.block-add-ext').modal(
            {
                overlayClose:true,
                close: true
            });
        $('.block-add-ext .do-contribute-ext').attr('itemid', jQuery(this).attr('itemid'));
        $('.block-add-ext .do-contribute-ext').attr('data-url', $(this).attr("data-url"));
        $('.ext-item-src-name').text($(this).attr("data-src-name"));

    });

    $('.do-contribute-ext').click(function(event){

        event.preventDefault();
        var height = screen.availHeight;
        if (navigator.appVersion.indexOf('Chrome')>0) {
            height = height - 60;
        }

        instructionsWin = window.open("/buy/buy_ext/" + $(this).attr('itemid'), "Instructions", ('width=' + (270) + ',height=' + (height) + ',top=0,left=0'));
        giftWin = window.open($(this).attr('data-url'), "GiftPage", ('width=' + (screen.availWidth-290) + ',height=' + (height) + ',top=0,left=290'));
        if (giftWin != null) {
            giftWin.focus();
        }
        if (instructionsWin != null) {
            instructionsWin.focus();
        }
        $.modal.close();
    });
});