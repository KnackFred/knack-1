jQuery(function(){
    $('#color_RGB').attr('readonly', 'readonly').css('background', '#' + $('#color_RGB').val());
    
    $('.btn-back').click(function(){
       document.location.assign('/administrative/colors') ;
    });

    $('#color_RGB').ColorPicker({
        onSubmit: function(hsb, hex, rgb) {
            $('#color_RGB').val(hex).css('background', '#' + hex);
        },
        onBeforeShow: function () {
            $(this).ColorPickerSetColor(this.value);
        }
    }).bind('keyup', function(){
        $(this).ColorPickerSetColor(this.value);
    });
});
