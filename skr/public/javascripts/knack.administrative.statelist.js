jQuery(function(){

   //set value select of count per page
   jQuery('#per_page option[value="'+ jQuery('#countP').val()+'"]').attr('selected', 'selected');

   //set value select of sort
   jQuery('#'+ jQuery('#sortby').val() + ' option[value="' + jQuery('#sortid').val() + '"]').attr('selected', 'selected');

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

});
