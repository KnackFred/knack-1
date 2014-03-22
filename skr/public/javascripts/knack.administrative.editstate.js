jQuery(function(){

//    jQuery('#cancel').click(function(){
//        document.location.assign('/administrative/productlist');
//    });

    jQuery('#cancel').click(function(){
        jQuery('#iscancel').val(true);
        jQuery('#form-state').submit();
    });
});
