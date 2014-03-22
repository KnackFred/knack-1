/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

jQuery(function(){
	jQuery('#dm-home').css('background', 'none repeat scroll 0 0 #f7f6f1');
	
	if (jQuery("#passwordCheck").is(':checked'))
            jQuery(".passwordBlock").css("display","block");
        else{
            jQuery(".passwordBlock").css("display","none");
        }
    

    jQuery("#passwordCheck").click(function(){
        if (jQuery("#passwordCheck").is(':checked'))
            jQuery(".passwordBlock").css("display","block");
        else{
            jQuery(".passwordBlock").css("display","none");
        }
    });
	


    $("#datepickerEvent").datepicker({
        beforeShow: function(input) {
          $(input).css("background-color","#ff9");
        },
        onClose: function(dateText, inst) {
          $(this).css("background-color","");
        }
      });

      jQuery('#use_store').click(function(){
          if (jQuery(this).is (':checked'))
            {
                jQuery('#set_use').val(1);
                jQuery('#wrap-logo').unwrap();
                jQuery('.wrap-profile').wrap('<form id="profile_form" action="/partner/partnerprofile" method="post"></form>');
                jQuery('#profile_form').trigger('submit');
            }
        
      });

    jQuery('#submit-btn').click(function(){
       jQuery('#wrap-logo').unwrap();
       jQuery('.wrap-profile').wrap('<form id="profile_form" action="/partner/partnerprofile" method="post"></form>');
       jQuery('#profile_form').submit();
    });

    make_pop_up($('#change-picture'), 260, 100);
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

