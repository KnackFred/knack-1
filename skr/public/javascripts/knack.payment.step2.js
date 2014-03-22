jQuery(function(){
   jQuery('.btn-continue').click(function(){
     jQuery('#frm-payment').submit();
   });

   jQuery('.use_cash').change(function(){
       jQuery('#change_credit').val(1);
       jQuery('#frm-payment').submit();
   });

    $("#help").tooltip({
        effect: 'slide',
        position: 'bottom center'
    });
});