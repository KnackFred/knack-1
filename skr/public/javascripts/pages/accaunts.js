jQuery(function(){
  jQuery("#filter_date_from").datepicker({
        beforeShow: function(input) {
          jQuery(input).css("background-color","#ff9");
        },
        onClose: function(dateText, inst) {
          jQuery(this).css("background-color","");
        }
      });

  jQuery("#filter_date_to").datepicker({
        beforeShow: function(input) {
          jQuery(input).css("background-color","#ff9");
        },
        onClose: function(dateText, inst) {
          jQuery(this).css("background-color","");
        }
      });

  
})