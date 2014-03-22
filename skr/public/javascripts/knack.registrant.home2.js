function center_heroboard() {
    margin = ($(window).height() - $("#heroboard_container").height() - 110 - 70) / 2;
    if (margin > 200) { margin = 200 }
    if (margin > 0) {
        $("#heroboard_container").css("margin-top", margin)
        $("#heroboard_container").css("margin-bottom", margin + 70)
    }
}

jQuery(function(){
    //menu-active
    jQuery('#dm-home').css('background', 'none repeat scroll 0 0 #f7f6f1');

    jQuery('#footer').css('margin', '56px auto 0');

    if($.browser.msie&&($.browser.version==6||$.browser.version==7)){
        jQuery('#div-btn-brw').css('margin-top', '10px');
    }

    jQuery('#find-registry').hover(function(){
        jQuery('#div-btn-find').css('background', 'url("/images/design/home/btn-find.gif") no-repeat 0 -19px');
    },function(){
        jQuery('#div-btn-find').css('background', 'url("/images/design/home/btn-find.gif") no-repeat 0 0px');
    });

    jQuery('#create-registry').hover(function(){
        jQuery('#div-btn-sign').css('background', 'url("/images/design/home/btn-signup.gif") no-repeat 0 -19px');
    },function(){
        jQuery('#div-btn-sign').css('background', 'url("/images/design/home/btn-signup.gif") no-repeat 0 0px');
    });

    jQuery('#sample-registry').hover(function(){
        jQuery('#div-btn-sample').css('background', 'url("/images/design/home/btn-sample.gif") no-repeat 0 -19px');
    },function(){
        jQuery('#div-btn-sample').css('background', 'url("/images/design/home/btn-sample.gif") no-repeat 0 0px');
    });


    jQuery('#browse').hover(function(){
        jQuery('#div-btn-brw').css('background', 'url("/images/design/home/btn-browse.gif") no-repeat 0 -19px');
    },function(){
        jQuery('#div-btn-brw').css('background', 'url("/images/design/home/btn-browse.gif") no-repeat 0 0px');
    });

    jQuery('#a-find').click(function(event){
        event.preventDefault();
        jQuery('#frm-home-find').submit();
    });

    $(window).resize(function(){center_heroboard()});
});

function playVideo() {
    $("#video").append($(video));
}

jQuery(window).load(function(){
    jQuery('#cat-wrapper').addClass('tag-none');
    jQuery('#cat-wrapper').css({'opacity': '0'});
    jQuery('.imgslade').removeClass('tag-none');

    $("#heroboard_image").click(function (event){
        _gaq.push(['_trackEvent', 'Homepage-Video', 'Play']);
        event.preventDefault();
        $("#heroboard_image").fadeOut(800);
        $("#heroboard_text").fadeOut(800);
        $("#video").fadeIn(2000, playVideo());
        $("#learn_more").fadeOut(500).animate({
            bottom: '-30px',
            left: '320px'
        }, 0).fadeIn(500);

    })
});




