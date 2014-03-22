jQuery(function(){
   jQuery('#dm-receive').css('background', 'none repeat scroll 0 0 #f6d4d4');

   //set value select of count per page
   jQuery('#per_page option[value="'+ jQuery('#per_page_value').val()+'"]').attr('selected', 'selected');

   //set value select of sort
   jQuery('#'+ jQuery('#sort_field').val() + ' option[value="' + jQuery('#sort_direction').val() + '"]').attr('selected', 'selected');

	//event change count per pager
   jQuery('#per_page').change(function(){
        jQuery('#per_page_value').val(jQuery('#per_page option:selected').val());
        jQuery('#filters').submit();
   });

   //event change page
   $('.pagination > a').click(function(e){
			e.preventDefault();
      var href = $(this).attr('href');
	   	var page = $.getUrlVar(href, 'page');
      $('#page').val(page);
      jQuery('#filters').submit();
   });

   //event sorting
    jQuery('#sort select').change(function(){
        var name = $(this).attr('name');
        var value = $(this).val();
        $('#sort_field').val(name);
        $('#sort_direction').val(value);
        jQuery('#filters').submit();
    });

});