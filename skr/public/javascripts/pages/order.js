var text = "After you save the order, you will not be able to make changes.";
jQuery(function(){
   $("#order_DeliveryDate").datepicker({
        beforeShow: function(input) {
          $(input).css("background-color","#ff9");
        },
        onClose: function(dateText, inst) {
          $(this).css("background-color","");
        }
      });
   $('.status > select').change(function(){
      if ($(this).val() == 3)
        alert(text);
   });

   $('.canceled > select').change(function(){
      if ($(this).val() == 2)
        alert(text);
   });
});