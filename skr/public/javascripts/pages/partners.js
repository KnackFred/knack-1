jQuery(function(){
    jQuery('.active-link').click(function(event){
        event.preventDefault();
        var id = jQuery(this).attr('dataid');
        var link = jQuery(this);
        $.ajax({
            type: 'POST',
            async: false,
            url: "/administrative/toggle_partner_deleted",
            data: {id: id},
            success: function(param){
                link.text(param);
            }
        });
    });

    jQuery('.activated-link').click(function(event){
        event.preventDefault();
        var id = jQuery(this).attr('dataid');
        var link = jQuery(this);
        $.ajax({
            type: 'POST',
            async: false,
            url: "/administrative/toggle_partner_activated",
            data: {id: id},
            success: function(param){
                link.text(param);
            }
        });
    });


});
