jQuery(function(){

    jQuery('#quantity').keyfilter(/^\d+$/);

    var options = {
        success:  closeS  // post-submit callback
    };

    jQuery('#buy').validate({
       	submitHandler: function(form) {
        	jQuery(form).ajaxSubmit(options);
        },
		invalidHandler: function(){
			resetWait();
		}
    });

    jQuery('#proceed-buy').click(function(event){
        event.preventDefault();
        jQuery('#procbuy').val('true');
        jQuery('#buy').submit();
    });
});

function closeS(param)
{
    if (param == 1)
        {
            document.location.assign('/buy/errorpage/2');
        }
    else
        {
            if (jQuery('#procbuy').val() == 'true')
                {
                    window.parent.closeModalWindow(1);
                }
             var c = jQuery('#cat_id').val();
             window.parent.closeModalWindow(2,c);
        }
}