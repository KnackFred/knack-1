jQuery(function(){
	jQuery('#frm-buy').validate({
       	submitHandler: function(form) {
			setWait();
			form.submit();
        },
		invalidHandler: function(){
			resetWait();
		},
       	rules: {
           	'buy_registry_item[FirstName]': "required",
           	'buy_registry_item[LastName]': "required"
       	},
       	messages: {
           	'buy_registry_item[FirstName]': "*",
           	'buy_registry_item[LastName]': "*"
       }
    });

    jQuery('#proceed-buy').click(function(event){
        event.preventDefault();
        jQuery('#frm-buy').submit();
    });
});