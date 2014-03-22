    $(function() {
      $("#datepickerTo").datepicker({
        beforeShow: function(input) {
          $(input).css("background-color","#ff9");
        },
        onClose: function(dateText, inst) {
          $(this).css("background-color","");
        }
      });
      $("#datepickerFrom").datepicker({
        beforeShow: function(input) {
          $(input).css("background-color","#ff9");
        },
        onClose: function(dateText, inst) {
          $(this).css("background-color","");
        }
      });
    });

