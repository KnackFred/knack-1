(function ($) {
   jQuery.fn.applyDesign = function(setting){
        var text = setting == '' ? 'Upload': setting;
        var id = jQuery(this).attr('id');

        jQuery(this).css({opacity: 0, zIndex : 100000, 'cursor' : 'pointer', 'position' : 'relative',
        top : 0, left: 0});

        var wrap_input = '<div id="wrap-input-'+id+'" style="z-index:1000;">'+
            '</div>';
        jQuery(this).wrap(wrap_input);

        var wrap_text = '<div id="wrap-text-'+id+'" >'+
            text+
            '</div>';
        var obj_wrap = jQuery(wrap_text);
        obj_wrap.css({marginTop: -25, 'cursor' : 'pointer', 'z-index': 1, 'position' : 'relative',
        top : 0, left: 0});

        jQuery('#wrap-input-'+id).wrap('<div></div>');
        jQuery('#wrap-input-'+id).after(obj_wrap);
   };
}(jQuery));