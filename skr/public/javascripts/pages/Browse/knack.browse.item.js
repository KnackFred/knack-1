function Param(){
    this.key = '';
    this.value = '';
}

currentImage = 0;
countImage = 0;

jQuery(function(){
    countImage = parseInt(jQuery('#count_image').val());

    jQuery("#quantity").keypress(function(e){
        var charCode = (e.which) ? e.which : e.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
        }
    });

    $('.main_image').load(function(){
        resetWait();
    });

    if(countImage <= 0)
    {
        $('.btn-prev').hide();
        $('.btn-next').hide();
        $('.imagesBlock').hide();
    }
    else
    {
        jQuery('.prev').click(function(){
            setWait();
            if(currentImage == 0)
                currentImage = countImage;
            else
                currentImage--;
            replace_main_image(currentImage);
        });

        jQuery('.next').click(function(){
            setWait();
            var count = parseInt(jQuery('#count_image').val());
            if(currentImage == countImage)
                currentImage = 0;
            else
                currentImage++;

            replace_main_image(currentImage);
        });

        jQuery('.preview').click(function(event){
            event.preventDefault();
            setWait();
            currentImage = $(this).index();
            replace_main_image(currentImage);
        });
    }

    window.fbAsyncInit = function() {
        FB.init({appId: '141113682594037', status: true, cookie: true, xfbml: true});
        };(function() {
            var e = document.createElement('script');
            e.type = 'text/javascript';
            e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
            e.async = true;
            document.getElementById('fb-root').appendChild(e);
        }());

    jQuery('#addtoregistry').click(function(){
        var id = jQuery('#productId').val();
        var c = jQuery('#categoryId').val();
        var r = jQuery('#registrantId').val();
        var q = jQuery('#quantity').val();
        var at =    get_token();
        var color = jQuery('.s-color').val();
        var params = jQuery('.item-params');
        var a_params = new Array();

        for(i = 0; i < params.length; i++)
        {
            var t_param = new Param();
            t_param.key = $.trim(jQuery(params[i]).attr('dataid'));
            t_param.value = $.trim(jQuery(params[i]).find('select').val());

            a_params.push(t_param);
        }

        var j_params = JSON.stringify(a_params, replacer);

        $.ajax({
           type: "POST",
           async: false,
           url: "/registrant/add_to_registrant",
           data: ({pid : id, quantity : q, category_id : c, color_id : color, product_params : j_params, authenticity_token : at}),
            success: function(param){
              if(param == 1)
                {
                    jQuery('.block-iframe').modal(
                       {
                           overlayClose:true,
                           minHeight:100,
                           minWidth: 200,
                           close: true
                       });
                    jQuery('#ifr-popup').attr('src','/buy/errorpage/2');
                }
              else
                {
                    confirmAction($('.item-buttons'), "Gift added to registry <br>  View registry now?", "Yes", "No", function () { window.location.href= '/manage_registry';}, 0);
                }
           }
        });
    });

    jQuery('#btn-contribute').click(function(){
        var id = jQuery('#r2pId').val();
        var r = jQuery('#registryId').val();
        jQuery('.block-iframe').modal(
       {
           overlayClose:true,
           minWidth: 500,
           minHeight:490,
           close: true
       });
       jQuery('#ifr-popup').attr('src','/buy/contribute/'+ id + '?r='+r);
    });

    jQuery('#buynow').click(function(){
        var id = jQuery('#productId').val();
        var c = jQuery('#categoryId').val();
        var q = jQuery('#quantity').val();
        var at = get_token();
        var color = jQuery('.s-color').val();
        var params = jQuery('.item-params');
        var a_params = new Array();

        for(i = 0; i < params.length; i++)
        {
            var t_param = new Param();
            t_param.key = $.trim(jQuery(params[i]).attr('dataid'));
            t_param.value = $.trim(jQuery(params[i]).find('select').val());

            a_params.push(t_param);
        }

        var j_params = JSON.stringify(a_params, replacer);

        $.ajax({
           type: "POST",
           async: false,
           url: "/buy/buy_himself",
           data: ({id : id, quantity : q, category_id : c, color_id : color, product_params : j_params, authenticity_token : at}),
            success: function(param){
              if(param != " ")
              {
                  jQuery('.block-iframe').modal(
                      {
                          overlayClose:true,
                          minHeight:100,
                          minWidth: 200,
                          close: true
                      });
                  jQuery('#ifr-popup').attr('src','/buy/errorpage/'+param);
              }
              else
              {
                  confirmAction($('.item-buttons'), "Gift added to cart <br>  View cart now?", "Yes", "No", function () { window.location.href= '/cart';}, 0);
              }
            }
        });
    });

});

function closeModalWindow(a, c)
{
    $.modal.close();
    jQuery('iframe').attr('src','');
    if(a == '1')
        {
            document.location.assign('/cart');
        }
        else
            if(a == '2')
                {
                    document.location.assign('/catalog/'+c);
                }
}

function replace_main_image(number) {
    var node = $(".imagesBlock").children()[number];
    src_url = $(node).data("url");
    jQuery('.main_image').attr('src', src_url);

}

function replacer(key, value) {
    if (typeof value === 'number' && !isFinite(value)) {
        return String(value);
    }
    return value;
}

function confirmAction(hideEl, msg, confirmLabel, cancelLabel, confirmCallback, id) {
    hideEl.hide()
    $('<div class="confirm">'+ msg +'<br> <span class="actions"><a class="confirm_yes" href="#">'+confirmLabel+'</a> <span>|</span> <a class="confirm_cancel" href="#">'+cancelLabel+'</a></span> </div>')
        .find('a.confirm_yes').click(function() {confirmCallback(id); hideEl.show();  $(this).parents('div.confirm:first').remove(); return false; }).end()
        .find('a.confirm_cancel').click(function() { hideEl.show(); $(this).parents('div.confirm:first').remove(); return false; }).end()
        .insertAfter(hideEl).fadeIn();
}
