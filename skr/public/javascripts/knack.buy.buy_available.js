jQuery(function(){
    jQuery("#quantity").keypress(function(e){
        var charCode = (e.which) ? e.which : e.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
        }
    });
   
    jQuery('#proceed-buy').click(function(event){
        event.preventDefault();
        jQuery('#procbuy').val('true');
        jQuery('#buy').submit();
    });

    $('#quantity').change(function(event) {
        subtotal = $('#quantity').val() * $('#registry_item_Price').val();
        $('.subtotal').text("$"+subtotal.toFixed(2));
    });
});