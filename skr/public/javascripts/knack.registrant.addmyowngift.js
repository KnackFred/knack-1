jQuery(function(){

    /* Event stock image */
    $('#link-stock-image').click(function(){
        toggleStock();
    });

    $('#btn-back-stock').click(function(){
        toggleStock();
    });

    $('.stock_image').click(function(){
        var src = $(this).attr('src');
        var url = $(this).data('stock-url');
        $('#registry_item_product_attributes_stock_image').val(url);
        $('#registry_item_product_attributes_main_product_image').val("");

        $('#stock-preview').attr('src', src+'?t='+ new Date());
        $('#stock-preview').removeClass('tag-none');
        toggleStock()
    });

    $('#registry_item_product_attributes_main_product_image').change(function(){
        $('#registry_item_product_attributes_stock_image').val("");
        $('#stock-preview').attr('src', "");
        $('#stock-preview').addClass('tag-none');
    });

    // Validate quantity
    $('#registry_item_Quantity').keyfilter(/[\d]/);

    // Validate prices
    $('#registry_item_product_attributes_MasterPrice').decimalMask({
        separator: ".",
        decSize: 2,
        intSize: 8
    });

    // event calculation
    $('#registry_item_product_attributes_MasterPrice').keyup(function(){
        initialize_calculate();
    });
    $('#registry_item_Quantity').keyup(function(){
        initialize_calculate();
    });

    //#REGION calculate tax

    initialize_calculate();

    //#ENDREGION
});

function initialize_calculate()
{
    var price = $('#registry_item_product_attributes_MasterPrice').val();
    var quantity = $('#registry_item_Quantity').val();

    if(price == '')
        price = 0;
    else
        price = parseFloat(price);

    if(quantity == '')
        quantity = 0;
    else
        quantity = parseInt(quantity);

    var total_cost = (price*quantity).toFixed(2);

    $("label[for='product_total_cost']").text('$'+total_cost);
}

function success_added(){
    window.parent.closeModalWindow(1);
}

function toggleStock() {
    $('.div-addgift').toggleClass('tag-none');
    $('.stock-images').toggleClass('tag-none');
}