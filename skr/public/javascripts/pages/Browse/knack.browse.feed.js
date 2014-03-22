$(function(){
//    This is kind of a hack that removes the ajax wait display.
    jQuery('#cat-wrapper').remove();

    $("#items").infinitescroll({
            loading: {
                finished: undefined,
                finishedMsg: "<em>There are no more items to see.</em>",
                img: "images/wait.gif",
                msg: null,
                selector: null,
                msgText: "<em>Loading the next set of gifts...</em>"
            },
            navSelector : "div.pagination",
            nextSelector : "div.pagination a.next_page",
            itemSelector : "#items li.gift-entry",
            bufferPx: 150
        });
});

function closeModalWindow(a, c)
{
    $.modal.close();
    jQuery('iframe').attr('src','');
}
