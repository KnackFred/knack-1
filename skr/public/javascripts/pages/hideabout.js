jQuery(function(){
    jQuery('#submit').click(function(){
       if ( jQuery("#head").is (":hidden") ) {
			jQuery("#head").slideDown("normal");
		} else {
			jQuery("#head").slideUp("normal");
		}
    });
})