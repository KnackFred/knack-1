jQuery(function(){
	//menu-active
    jQuery('#dm-give').css('background', 'none repeat scroll 0 0 #d9e5f0');

     //set value select of count per page
    jQuery('#per_page option[value="'+ jQuery('#countP').val()+'"]').attr('selected', 'selected');

    //set value select of sort
    jQuery('#'+ jQuery('#sortby').val() + ' option[value="' + jQuery('#sortid').val() + '"]').attr('selected', 'selected');

     jQuery("#filter_datepicker_from").datepicker({
        beforeShow: function(input) {
          jQuery(input).css("background-color","#ff9");
        },
        onClose: function(dateText, inst) {
          jQuery(this).css("background-color","");
        }
      });

  jQuery("#filter_datepicker_to").datepicker({
        beforeShow: function(input) {
          jQuery(input).css("background-color","#ff9");
        },
        onClose: function(dateText, inst) {
          jQuery(this).css("background-color","");
        }
      });

    //event change count per pager
   jQuery('#per_page').change(function(){
        jQuery('#countP').val(jQuery('#per_page option:selected').val());
        jQuery('#filters').submit();
   });

   //event change page
   jQuery('#div-pager a').bind('click', function(event){
       event.preventDefault();
       jQuery('#currentP').val(jQuery(this).attr('pageid'));
       jQuery('#filters').submit();
   });

   //event sorting
   jQuery('#sort select').change(function(){
       var id = jQuery(this).attr('id');
       var selects = jQuery('#sort select');
       for(i=0; i< selects.length; i++)
           {
               if (selects[i].id != id)
                selects[i].options[0].selected = true;
           }
       jQuery('#filters').submit();
   });
});