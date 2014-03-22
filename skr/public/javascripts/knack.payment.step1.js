jQuery(function(){
   jQuery('#order_is_use_bill_address').click(function(){
      // var value = jQuery(this).attr('checked') == true ? 1 : 0;
      // jQuery('#isuse').val(value);
      jQuery('#use').val('1');
      jQuery('#frm-order').submit();
   });

   jQuery('.btn-continue').click(function(){
			$('input[disabled="disabled"]').attr('disabled', '');
			$('#order_ShippingState_ID > option').attr('disabled', '');
      jQuery('#frm-order').submit();
   });
    $('#international-link').click(function(e){
        e.preventDefault();
        $('#international-instructions').slideToggle();
    });

});