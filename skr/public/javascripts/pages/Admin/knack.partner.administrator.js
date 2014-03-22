jQuery(function(){
    if (jQuery("#partner_administrator_change_password").is(':checked'))
            jQuery(".passwordBlock").css("display","block");
        else{
            jQuery(".passwordBlock").css("display","none");
        }


    jQuery("#partner_administrator_change_password").click(function(){
        if (jQuery("#partner_administrator_change_password").is(':checked'))
            jQuery(".passwordBlock").css("display","block");
        else{
            jQuery(".passwordBlock").css("display","none");
        }
    });

    $(".delete").click( function(e){
        var r = confirm("Are you sure you want to delete this administrator");
        if (r != true) {
            e.preventDefault();
        }
    });
});