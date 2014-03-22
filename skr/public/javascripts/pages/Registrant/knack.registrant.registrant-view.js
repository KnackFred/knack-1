$(function(){

    jQuery('#dm-give').css('background', 'none repeat scroll 0 0 #d9e5f0');

    /**********************************************
     * Set Up On First Load
     *********************************************/


    /**********************************************
     * POP UP
     *********************************************/
    jQuery('.contribute').click(function(event){

        event.preventDefault();
        var id = jQuery(this).attr('itemid');

        jQuery('.block-iframe').modal(
            {
                overlayClose:true,
                close: true
            });
        jQuery('#ifr-popup').attr('src','/buy/contribute/'+ id)
    });


    if($.cookie('do_not_show_message') == null) {
      show_message();
    } else {
        $('#do-not-show').prop("checked", true);
    }

    $('#do-not-show').click(function(e) {
        if ($(this).is(':checked')) {
            $.cookie('do_not_show_message', 'true', {expires: 365});
        } else {
            $.cookie('do_not_show_message', null);
        }
    })

});

function show_message() {
    jQuery('.block-welcome').modal({
        overlayClose:true,
        minHeight:126,
        minWidth:200,
        close: true
    });
}
function closeModalWindow(a, id)
{
    jQuery('iframe').attr('src','');
    $.modal.close();
    if(a == '1')
        {
            document.location.assign('/cart');
            return;
        }
    else if(a == '2')
    {
        return;
    }
    jQuery('input[r2pid="'+id+'"]').remove();
}
