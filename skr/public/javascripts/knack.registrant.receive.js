jQuery(function(){

    // menu
    jQuery('#dm-receive').css('background', 'none repeat scroll 0 0 #f6d4d4');
     /**********************************************
     * POP UP CATEGORY
     *********************************************/
    jQuery('.edit-prod').bind('click', function(event){
        var id = jQuery(this).attr('dataid');

        jQuery('.block-popb').modal(
       {
           overlayClose:true,
           minHeight:100,
           minWidth: 200,
           close: true
       });
       jQuery('#ifr-popupBuy').attr('src','/buy/edit/'+id);

       event.preventDefault();
    });


    //buy
    jQuery('.buy-prod').click(function(event){
       event.preventDefault();
        var id = jQuery(this).attr('dataid');

        jQuery('.block-popb').modal(
       {
           overlayClose:true,
           minHeight:100,
           minWidth: 200,
           close: true
       });
       jQuery('#ifr-popupBuy').attr('src','/buy/buy_available/'+id);

    });

    jQuery('.contributors').click(function(event){
       event.preventDefault();
       jQuery('.block-pop').modal({
           overlayClose:true,
           minHeight:100,
           minWidth: 200,
           close: true
       });
       var id = jQuery(this).attr('dataid');
       jQuery('#ifr-popup').attr('src','/buy/contributors/'+id);
    });

//    jQuery('input[type=radio]').click(function(){
//       jQuery(this).attr('checked', 'checked');
//    });

});

function closeModalWindow(a, id)
{
    $.modal.close();
    jQuery('iframe').attr('src','');
    if(a == '1')
        {
            document.location.assign('/cart');
            return;
        }
    jQuery('a[dataid="'+id+'"]').remove();
}
