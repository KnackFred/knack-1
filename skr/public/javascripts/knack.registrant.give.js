jQuery(function(){

    //menu-active
   jQuery('#dm-give').css('background', 'none repeat scroll 0 0 #d9e5f0');

   if(jQuery('#typefind').val() == '1')
   {
       jQuery('#div_adv').removeClass('tag-none');
       jQuery('#div_simple').addClass('tag-none');
   }

});