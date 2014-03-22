$(function(){

    $('#edit-source-link').click(function(e) {
        e.preventDefault();
        $('#source').slideUp("fast", function(){
            $('#edit-source').slideDown();
            $('#registry_item_product_attributes_Description').animate({height: '40px'});
        });
    });

    $('#registry_item_Quantity').keyfilter(/[0-9]/i);
    $('#registry_item_Price').keyfilter(/[0-9\.]/i);

    $('.edit_registry_item').validate({
		invalidHandler: function(){
			resetWait();
		},
        rules: {
            'registry_item[Quantity]': {
                required: true,
                min: 1
            },
            'registry_item[Price]': {
                required: true,
                min: 0.1
            },
            'registry_item[product_attributes][Name]': {
                required: true,
                maxlength: 50
            },
            'registry_item[product_attributes][source_name]': {
                required: "#registry_item_product_attributes_external:checked",
                maxlength: 50
            },
            'registry_item[product_attributes][source_url]': {
                required: "#registry_item_product_attributes_external:checked",
                maxlength: 1024
            },
            'registry_item[product_attributes][ext_color]': {
                maxlength: 50
            },
            'registry_item[product_attributes][ext_size]': {
                maxlength: 50
            },
            'registry_item[product_attributes][ext_other]': {
                maxlength: 100
            },
            'registry_item[product_attributes][Description]': {
                maxlength: 900
            }
        }
    });

    $('select').addClass('required');

    $.extend(jQuery.validator.messages, {
        required: "*",
        min: "*",
        maxlength: "*"
    });
});