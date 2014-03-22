jQuery(function(){

    // Primary Nav Shading
    jQuery('#dm-receive').css('background', 'none repeat scroll 0 0 #f6d4d4');

    /* Corners for ie8 and older */
    var setting = {
        tl: { radius: 15 },
        tr: { radius: 15 },
        bl: { radius: 15 },
        br: { radius: 15 },
        antiAlias: true
    };
    //curvyCorners(setting, ".wrap-text-block");

    jQuery('#video-link').bind('click', function(event){

        $(".block-pop-video").html('<iframe src="https://player.vimeo.com/video/47048370?title=0&amp;byline=0&amp;portrait=0&amp;autoplay=1" width="640" height="360" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>');

        jQuery('.block-pop-video').modal(
            {
                overlayClose:true,
                close: true
            });

        event.preventDefault();
    });

    make_pop_up($('.btn-add-gifts'), 400, 390, "Add My Own Gift");
    make_pop_up($('.btn-external-gifts'), 670, 490, "Add Gifts From Another Site");

    /* Like pop-up*/
    if( $('.like-popup').length ){
        $('.like-popup').modal(
            {
                overlayClose:true,
                MaxHeight:400,
                MaxWidth: 100,
                close: true
            });
    }

});

function closeModalWindowWCall(call, success, data) {
    $.modal.close();
    switch (call) {
        case "addmyowngift":
            setTimeout( function() {
                if(success)
                    pop_up(data, 420, 360, "Crop Image");
                else
                    alert(data)
            }, 20);
            break;
        case "crop_image":
            if (success)
                document.location.assign(data);
            else
                alert(data);
            break;
        default:
            alert ("Error: Unknown Call");
    }
}