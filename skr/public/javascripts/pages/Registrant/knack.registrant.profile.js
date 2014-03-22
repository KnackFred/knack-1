/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function(){

    jQuery('#dm-receive').css('background', 'none repeat scroll 0 0 #f6d4d4');

    $("#registrant_EventDate").datepicker({
        beforeShow: function(input) {
            $(input).css("background-color","#ff9");
        },
        onClose: function(dateText, inst) {
            $(this).css("background-color","");
        }
    });

    $("#registrant_EventDate").keydown(function(e){
        if (e.keyCode == 8)
            $('#registrant_EventDate').val('');
        else
            e.preventDefault();
        return;
    });

    $("#help").tooltip({
        effect: 'slide',
        position: 'top center'
    });

    if (jQuery("#registrant_change_password").is(':checked'))
            jQuery(".passwordBlock").css("display","block");
        else{
            jQuery(".passwordBlock").css("display","none");
        }
    

    jQuery("#registrant_change_password").click(function(){
        if (jQuery("#registrant_change_password").is(':checked'))
            jQuery(".passwordBlock").css("display","block");
        else{
            jQuery(".passwordBlock").css("display","none");
        }
    });

    jQuery("#registrant_Description").keypress(function(event){
        var key = event.which;
        //all keys including return.
        if(key >= 33 || key == 13) {
            var maxLength = 200;
            var length = this.value.length;
            if(length >= maxLength) {
                event.preventDefault();
            }
        }
    });

    make_pop_up($('#change-picture'), 260, 100, "Set New Profile Picture");
});



function reloadProfileImage(url) {
    $('.MainImage').attr('src',url+'?t='+ new Date());

}

function closeModalWindowWCall(call, success, data) {
    $.modal.close();
    switch (call) {
        case "upload_image":
            setTimeout( function() {
                if(success)
                    pop_up(data, 420, 360);
                else
                    alert(data)
            }, 20);
            break;
        case "crop_image":
            if (success)
                reloadProfileImage(data);
            else
                alert(data);
            break;
        default:
            alert ("Error: Unknown Call");
    }
}