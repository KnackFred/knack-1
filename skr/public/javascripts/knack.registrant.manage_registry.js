jQuery(function(){

    // Primary Nav Shading
    jQuery('#dm-receive').css('background', 'none repeat scroll 0 0 #f6d4d4');

    // Contributors
    jQuery('.contributors').click(function(event){
        event.preventDefault();
        jQuery('.block-pop').modal({
            overlayClose:true,
            minHeight:100,
            minWidth: 200,
            close: true
        });
        var id = jQuery(this).attr('dataid');
        jQuery('#ifr-popup').attr('src','/buy/contributors/'+id);
    });

    /**********************************************
     * POP UP FOR ACTIONS
     *********************************************/
    jQuery('.edit-prod').bind('click', function(event){
        var id = jQuery(this).attr('dataid');

        jQuery('.block-popb').modal(
            {
                overlayClose:true,
                minHeight:100,
                minWidth: 200,
                close: true,
                onclose: closeModalWindow
            });
        jQuery('#ifr-popupBuy').attr('src','/registrant/edit_registry_item/'+id);

        event.preventDefault();
    });

    //buy
    jQuery('.buy-prod').click(function(event){
        var id = jQuery(this).attr('dataid');

        jQuery('.block-popb').modal(
            {
                overlayClose:true,
                minHeight:100,
                minWidth: 200,
                close: true
            });
        jQuery('#ifr-popupBuy').attr('src','/buy/buy_available/'+id);

        event.preventDefault();
    });

    // delete
    $('.delete-prod').click(function(event){
        event.preventDefault();
        var id = jQuery(this).attr('dataid');
        hideEl = $(this).parents('.actions');
        				
        confirmAction(hideEl, "Are you sure you want to delete this gift?", "Yes", "No", deleteGift, id)
    });

    // order
    $('.order-prod').click(function(event){
        event.preventDefault();
        var id = jQuery(this).attr('dataid');
        // var actionsScope = $(this).parents('.actions');

        // orderProduct(id, function() { orderProductComplete(id, actionsScope);})
				jQuery('.block-popb').modal(
		        {
		            overlayClose:true,
		            minHeight:100,
		            minWidth: 200,
		            close: true
		        });
				$('#simplemodal-container').hide();
				$('#simplemodal-overlay').hide();
				jQuery('#ifr-popupBuy').attr('src','/buy/buy_order/'+id);
    });

    // Exchange
    $('.exchange-prod').click(function(event){
        event.preventDefault();
        var id = jQuery(this).attr('dataid');
        // var actionsScope = $(this).parents('.actions');
        // 
        //         exchangeProduct(id, function() { exchangeProductComplete(id, actionsScope);})
        jQuery('.block-popb').modal(
        {
            overlayClose:true,
            minHeight:100,
            minWidth: 200,
            close: true
        });
				$('#simplemodal-container').hide();
				$('#simplemodal-overlay').hide();
				jQuery('#ifr-popupBuy').attr('src','/buy/exchange/'+id);
    });

});

function closeModalWindow(a, id)
{
    $.modal.close();
    jQuery('iframe').attr('src','');
		var actionsScope = $("a[dataid='"+id+"']").parents('.actions');
		switch(a){
			case 1:
				buyProductComplete(id, actionsScope);
				break;
			case 2:
				orderProductComplete(id, actionsScope);
				break;
			case 3:
				exchangeProductComplete(id, actionsScope);
				break;	
			case 4:
				window.location.assign('/manage_registry');
				break;
            case 5:
                location.reload(true);
                break;
		}
}

function deleteGift (id)  {
    jQuery('.block-popb').modal(
        {
            overlayClose:true,
            minHeight:100,
            minWidth: 200,
            close: true
        });
		$('#simplemodal-container').hide();
		$('#simplemodal-overlay').hide();
		jQuery('#ifr-popupBuy').attr('src','/delete_registry_item/'+id);
}

function orderProduct (id, successCallback) {
    var jqxhr = $.get('/registrant/add_to_cart/'+id+"/?is_exchange=false")
    .success(function(msg) {alertIfRequired (msg, successCallback)})
    .error(function(msg) {alert(msg);})
}

function buyProductComplete (id, actionsScope) {
    confirmAction(actionsScope, "Gift added to cart <br>  View the cart now?", "Yes", "No", function () { window.location.href = "/cart";}, id);
    $('.exchange-prod', actionsScope).remove();
    $('.buy-prod', actionsScope).remove();
	$('.edit-prod', actionsScope).remove();
	$('.delete-prod', actionsScope).remove();
    actionsScope.append('<div class="view-cart"><a href="/cart">In Cart</a></div>')
}

function orderProductComplete (id, actionsScope) {
    confirmAction(actionsScope, "Gift added to cart <br>  View the cart now?", "Yes", "No", function () { window.location.href = "/cart";}, id);
    $('.exchange-prod', actionsScope).remove();
    $('.order-prod', actionsScope).remove();
    actionsScope.append('<div class="view-cart"><a href="/cart">In Cart</a></div>')
}

function exchangeProduct (id, successCallback) {
    var jqxhr = $.get('/registrant/add_to_cart/'+id+"/?is_exchange=true")
    .success(function(msg) {alertIfRequired (msg, successCallback);})
    .error(function(msg) {alert(msg);})
}

function exchangeProductComplete (id, actionsScope) {
    confirmAction(actionsScope, "Gift added to cart for Exchange <br>  View the cart now?", "Yes", "No", function () { window.location.href= "/cart";}, id);
    $('.buy-prod', actionsScope).remove();
    $('.exchange-prod', actionsScope).remove();
    $('.order-prod', actionsScope).remove();
    actionsScope.append('<div class="view-cart"><a href="/cart">In Cart</a></div>')
}

function confirmAction(hideEl, msg, confirmLabel, cancelLabel, confirmCallback, id) {
    hideEl.hide()
    $('<div class="confirm">'+ msg +'<br> <br> <span class="actions"><a class="confirm_yes" href="#">'+confirmLabel+'</a> <span>|</span> <a class="confirm_cancel" href="#">'+cancelLabel+'</a></span> </div>')
        .find('a.confirm_yes').click(function() {confirmCallback(id); hideEl.show();  $(this).parents('div.confirm:first').remove(); return false; }).end()
        .find('a.confirm_cancel').click(function() { hideEl.show(); $(this).parents('div.confirm:first').remove(); return false; }).end()
            .insertAfter(hideEl).fadeIn();
}

function alertIfRequired(msg, action) {
    var flash = $('.flash-alert', $(msg)).text ()
    if (flash != "") {
        alert(flash);
    }
    else {
        action();
    }
}
