var const_rate_w = 64;
var const_rate_h = 85;
var rate_w = 64;
var rate_h = 85;
var min_w = 128;
var min_h = 128;
var min = 128;
var max = 370;
var width_i = 0;
var height_i = 0;

function Coords()
{
    this.x = 0;
    this.y = 0;
    this.x2 = 0;
    this.y2 = 0;
    this.width = 0;
    this.height = 0;
}

function showCoords(c)
  {
      // variables can be accessed here as
      Coords.x = c.x;
      Coords.y = c.y;
      Coords.x2 = c.x2;
      Coords.y2 = c.y2;
      Coords.width = c.w;
      Coords.height = c.h;
  }

function sizeCropV(width, height)
{
    if(width >= min)
    {
        min_w = min
        var hh = parseInt(min_w * (rate_h / rate_w));
        if(hh > height)
        {
            min_h = height;
            min_w = parseInt(min_h * (rate_w / rate_h));
        }
        else
            min_h = parseInt(min_w * (rate_h / rate_w));
        return;
    }

    if(width < min && height < min)
        {
            min_h = height;
            min_w = width;
            rate_w = 0;
            rate_h = 0;
            return;
        }

    if(width > height)
    {
        min_h = height;
        var w = parseInt(min_h * (rate_w / rate_h));
        if(w > width)
        {
            min_w = width;
            min_h = parseInt(min_w * (rate_h / rate_w));
        }
        else
            min_w = parseInt(min_h * (rate_w / rate_h));
    }
    else
    {
        min_w = width;
        var h = parseInt(min_w * (rate_h / rate_w));
        if(h > height)
        {
            min_h = height;
            min_w = parseInt(min_h * (rate_w / rate_h));
        }
        else
            min_h = parseInt(min_w * (rate_h / rate_w));
    }
}

function sizeCropH(width, height)
{
    if(height >= min)
    {
        min_h = min
        var ww = parseInt(min_h * (rate_h / rate_w));
        if(ww > width)
        {
            min_w = width;
            min_h = parseInt(min_w * (rate_w / rate_h));
        }
        else
            min_w = parseInt(min_h * (rate_h / rate_w));
        return;
    }

    if(width < min && height < min)
        {
            min_h = height;
            min_w = width;
            rate_w = 0;
            rate_h = 0;
            return;
        }

    if(width > height)
    {
        min_h = height;
        var w = parseInt(min_h * (rate_h / rate_w));
        if(w > width)
        {
            min_w = width;
            min_h = parseInt(min_w * (rate_w / rate_h));
        }
        else
            min_w = parseInt(min_h * (rate_h / rate_w));
    }
    else
    {
        min_w = width;
        var h = parseInt(min_w * (rate_w / rate_h));
        if(h > height)
        {
            min_h = height;
            min_w = parseInt(min_h * (rate_h / rate_w));
        }
        else
            min_h = parseInt(min_w * (rate_w / rate_h));
    }
}

function resize(tag, maxWidth, maxHeight, ratio) {
    $(tag).each(function() {
        //var maxWidth = 100; // Max width for the image
        //var maxHeight = 100;    // Max height for the image
        //var ratio = 0;  // Used for aspect ratio
        var width = $(this).width();    // Current image width
        var height = $(this).height();  // Current image height

        // Check if the current width is larger than the max
        if(width > maxWidth){
            ratio = maxWidth / width;   // get ratio for scaling image
            $(this).css("width", maxWidth); // Set new width
            $(this).css("height", height * ratio);  // Scale height based on ratio
            height = height * ratio;    // Reset height to match scaled image
            width = width * ratio;    // Reset width to match scaled image
        }

        // Check if current height is larger than max
        if(height > maxHeight){
            ratio = maxHeight / height; // get ratio for scaling image
            $(this).css("height", maxHeight);   // Set new height
            $(this).css("width", width * ratio);    // Scale width based on ratio
            width = width * ratio;    // Reset width to match scaled image
        }
    });
}

jQuery(function(){
   jQuery(".image-position").change(function(){
        var id = jQuery(this).val();
        if(id == "1")
        {
            sizeCropV(width_i, height_i);
            jQuery('#up-image').Jcrop({
                    onSelect:    showCoords,
                    onChange:    showCoords,
                    bgColor:     'black',
                    bgOpacity:   .4,
                    minSize: [min_w,min_h],
                    //maxSize: [max, max],
                    setSelect:   [ 0, 0, 50, 50 ],
                    aspectRatio: rate_w / rate_h
                });
        }
        else
        {
            sizeCropH(width_i, height_i);
            jQuery('#up-image').Jcrop({
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
    });
});