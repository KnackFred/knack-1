
jQuery(function(){

    jQuery('.addfromregistry').bind('click', function(event){

        var id = jQuery(this).data('id');
        var _gaq = _gaq || [];
        _gaq.push(['_trackEvent', 'Registry', 'Initiate Add From Registry', id.toString()]);

        pop_up('/registrant/add_from_registry/' + id, 485, 480, "Add To My Registry");

        event.preventDefault();
    });

    jQuery("#quantity").keyup(function(){
        var valQuantity = jQuery("#quantity")[0].value;
        if(!/^\d{1,}$/.test(valQuantity)) {

        } else {
            if (valQuantity>=0){
                var price = jQuery(jQuery("#quantity")[0]).attr("price")
                jQuery("#priceTD").html("$"+valQuantity*price);
            }
        }
    });
});


