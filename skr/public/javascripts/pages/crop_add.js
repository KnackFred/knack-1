var o_jcrop;
function setCrop()
{
        o_jcrop = jQuery.Jcrop('#big_image',
        {
                onSelect:    showCoords,
                onChange:    showCoords,
                bgColor:     'black',
                bgOpacity:   .4,
                minSize: [min_w,min_h],
                //maxSize: [max, max],
                setSelect:   [ 0, 0, 50, 50 ],
                aspectRatio: rate_h / rate_w
        });
}
jQuery(function(){


    jQuery('#save-image').hide();

    rate_w = const_rate_w;
    rate_h = const_rate_h;
    var param = $('#size').val();
    var size = param.split(',');

    height_i = parseInt(size[1]);
    width_i = parseInt(size[0]);
    sizeCropH(width_i, height_i);
    $('#big_image').load(function(){
        setCrop();
    });

    jQuery('#fupload').change(function(){
        jQuery('#form_upload').submit();
    });

    jQuery('#form_upload').ajaxForm(function(param){
        if(param == 1)
            {
                show_error_popup(1);
            }
        else
            {
                var id = jQuery('#guid').val();

                o_jcrop.destroy();

                jQuery('.jcrop-holder').detach();
                jQuery('#big_image').attr('src','/images/upload/'+ $.trim(id) +'_b.jpg?t='+ new Date());
                var size = param.split(',');
                rate_w = const_rate_w;
                rate_h = const_rate_h;
                height_i = parseInt(size[2]);
                width_i = parseInt(size[1]);
                sizeCropH(width_i, height_i);



                $('#big_image').load(function(){

                    //setCrop();
                });
            }
    });

    jQuery('#crop-image').click(function(){
        var id = jQuery('#guid').val();
        if(Coords.width == 0 || Coords.height == 0)
            {
                alert('Please, select area on image');
                return;
            }
        $.ajax({
            url: "/administrative/crop_image_big",
            type: "POST",
            async: false,
            data: {
                id: id,
                x: Coords.x,
                y: Coords.y,
                w: Coords.width,
                h: Coords.height
            },
            complete: function(param){
                var result = param.responseText;
                if(result == "200")
                {
                    jQuery('#small_image').attr('src','/images/upload/'+ $.trim(id) +'.jpg?t='+ new Date());
                    jQuery('#save-image').show();
                    $.modal.close();
                }
                else
                {
                    alert('Error crop');
                }
            }
        })
    });
});