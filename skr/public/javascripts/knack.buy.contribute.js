jQuery(function(){

    var minContribute = jQuery('#buy_registry_item_min_contribution').val();
    var maxContribute = jQuery('#buy_registry_item_max_contribution').val();
    var minQuantity = jQuery('#buy_registry_item_min_quantity').val();
    var maxQuantity = jQuery('#buy_registry_item_max_quantity').val();
    var price = jQuery('#buy_registry_item_price').val();

    /// Validations
    $('#buy_registry_item_contribute').keyfilter(/[(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?]/);
    $('#buy_registry_item_quantity').keyfilter(/[(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?]/);

    $('#new_buy_registry_item').validate({
       	submitHandler: function(form) {
			setWait();
			form.submit();
        },
		invalidHandler: function(){
			resetWait();
		},
       	rules: {
           	'buy_registry_item[from]': "required",
           	'buy_registry_item[quantity]': {
                   required: true,
                   min: minQuantity,
                   max: maxQuantity
               },
           	'buy_registry_item[contribute]': {
               	required: true,
               	min: minContribute,
               	max: maxContribute
            	}
       	},
       	messages: {
           	'buy_registry_item[from]': " *",
           	'buy_registry_item[quantity]': " *",
           	'buy_registry_item[contribute]': " *"
       }
    });

    $('#proceed-contr').click(function(event){
        event.preventDefault();
        $('#new_buy_registry_item').submit();
    });

    $('#buy_registry_item_quantity').change(function(event) {
        if ($('#buy_registry_item_quantity').hasClass('error')) {
            $('.subtotal').text("Invalid");
        } else {
            subtotal = $('#buy_registry_item_quantity').val() * price;
            $('.subtotal').text("$"+subtotal.toFixed(2));
        }
    });
});