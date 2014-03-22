jQuery(function(){
	jQuery('.deletefromcart').click(function(event){
   event.preventDefault();
   document.location.assign('/payment/deletefromcart/'+jQuery(this).attr('r2pid'));
  });

  jQuery('.deletebuycart').click(function(event){
   event.preventDefault();
   document.location.assign('/payment/deletefrombuycart/'+jQuery(this).attr('pid'));
  });

  jQuery('.deletecash').click(function(event){
   event.preventDefault();
   document.location.assign('/payment/deletecash/');
  });

  jQuery(".quantity").bind('keypress', function(e) {
		var charCode = (e.which) ? e.which : e.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
      return false;
    }
		else {
      jQuery(this).oneTime(1000, function() {
          var count = jQuery(this).val();
          var id =jQuery(this).attr('dataid');
          jQuery('#quantityValue').val(count);
          jQuery('#quantityId').val(id);
          jQuery('#frm-check').submit();
      });
    }
   });
});

function continue_shopping(){
	var path = $('#back_path').val();
	var at = get_token();
	jQuery('.div-c').after('<form id="frm-back" action="'+path+'" method="post">'+
        '<input type="hidden" name="back_view" value="true"/>'+
		'<input type="hidden" name="authenticity_token" value="' + at + '"/>'+
        '</form>');
    jQuery('#frm-back').submit();
}