jQuery(function(){
   jQuery('#product-table tbody tr').hover(function(){
        jQuery(this).addClass('select-edit');
    }, function(){
        jQuery(this).removeClass('select-edit');
    });

    jQuery('#product-table tbody tr').click(function(){
        var at = jQuery('#at').val();
        var store_id = jQuery(this.cells[0]).text();
        jQuery('.div-c').after('<form id="frm-products" action="/administrative/productlist" method="post">'+
            '<input type="hidden" name="filter[store_id]" value="' + store_id + '"/>'+
            '<input type="hidden" name="sort[store_id]" value=""/>'+
            '<input type="hidden" name="authenticity_token" value="' + at + '"/>'+
            '</form>');
        jQuery('#frm-products').submit();
    });
});