min_w = 160;
min_h = 120;

$(function(){
    $('#crop-image').Jcrop({
        onSelect:    setCoords,
        onChange:    setCoords,
        bgColor:     'black',
        bgOpacity:   .4,
        minSize: [min_w,min_h],
        setSelect:   [ 0, 0, min_w, min_h ],
        aspectRatio: min_w / min_h
    });
    $('#cat-wrapper-image').css('display', 'none');
});

function setCoords(c)
{
    // variables can be accessed here as
    $(".crop_x").val(c.x * ratio_x);
    $(".crop_y").val(c.y * ratio_y);
    $(".crop_w").val(c.w * ratio_x);
    $(".crop_h").val(c.h * ratio_y);
}

