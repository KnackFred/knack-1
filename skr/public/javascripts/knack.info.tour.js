/**
 * Created by .
 * User: john
 * Date: 8/30/11
 * Time: 4:57 PM
 */

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


    jQuery('#browse').hover(function(){
        jQuery('#div-btn-brw').css('background', 'url("/images/design/home/btn-browse.gif") no-repeat 0 -19px');
    },function(){
        jQuery('#div-btn-brw').css('background', 'url("/images/design/home/btn-browse.gif") no-repeat 0 0px');
    });


    jQuery('#a-find').click(function(event){
        event.preventDefault();
        jQuery('#frm-home-find').submit();
    });


    $("#small_business").fancybox({
        'autoScale'	    	: false,
        'autoDimensions'    : false,
        'transitionIn'	    : 'fade',
        'width'	    	    : 932,
        'height'	    	: 613,
        'padding'	    	: 0,
        'margin'	    	: 0,
        'overlayOpacity'    : 0,
        'transitionOut'	    : 'fade',
        'type'		    	: 'iframe',
        'scrolling'	    	: 'no'
    });


    $("#add_gifts_from_anywhere").fancybox({
        'autoScale'	    	: false,
        'autoDimensions'    : false,
        'transitionIn'	    : 'fade',
        'width'	    	    : 932,
        'height'	    	: 613,
        'padding'	    	: 0,
        'margin'	    	: 0,
        'overlayOpacity'    : 0,
        'transitionOut'	    : 'fade',
        'type'		    	: 'iframe',
        'scrolling'	    	: 'no'
    });


    $("#fund_your_honeymoon").fancybox({
        'autoScale'	    	: false,
        'autoDimensions'    : false,
        'transitionIn'	    : 'fade',
        'width'	    	    : 932,
        'height'	    	: 613,
        'padding'	    	: 0,
        'margin'	    	: 0,
        'overlayOpacity'    : 0,
        'transitionOut'	    : 'fade',
        'type'		    	: 'iframe',
        'scrolling'	    	: 'no'
    });


    $("#share_wishlist_popup").fancybox({
        'autoScale'	    	: false,
        'autoDimensions'    : false,
        'transitionIn'	    : 'fade',
        'width'	    	    : 932,
        'height'	    	: 613,
        'padding'	    	: 0,
        'margin'	    	: 0,
        'overlayOpacity'    : 0,
        'transitionOut'	    : 'fade',
        'type'		    	: 'iframe',
        'scrolling'	    	: 'no'
    });

    $("#collect_your_gifts").fancybox({
        'autoScale'	    	: false,
        'autoDimensions'    : false,
        'transitionIn'	    : 'fade',
        'width'	    	    : 932,
        'height'	    	: 613,
        'padding'	    	: 0,
        'margin'	    	: 0,
        'overlayOpacity'    : 0,
        'transitionOut'	    : 'fade',
        'type'		    	: 'iframe',
        'scrolling'	    	: 'no'
    });



});

//slide show

jQuery(window).load(function(){
    jQuery('#cat-wrapper').addClass('tag-none');
    jQuery('#cat-wrapper').css({'opacity': '0'});
    jQuery('.imgslade').removeClass('tag-none');
    jQuery('#s1').cycle({
        fx: 'fade',
        speed: 1000,
        timeout: 10000
    });


    $('li#support_small_start').delay(500).fadeOut(500);
    $('li#add_gifts_start').delay(1000).fadeOut(500);
    $('li#fund_your_start').delay(1500).fadeOut(500);
    $('li#share_wishlist_start').delay(2000).fadeOut(500);
    $('li#collect_your_start"').delay(2500).fadeOut(500);
    $('#lines_slideshow').delay(500).fadeIn(2500).animate({ width: '890px'},1000);


    $('li#support_small, li#add_gifts", li#share_wishlist, li#shop_our, li#fund_your, li#collect_your').css({ opacity: 0 })

    $("li#support_small, li#add_gifts, li#share_wishlist, li#shop_our, li#fund_your, li#collect_your").hover(function(){
        $(this).stop().animate({opacity: 1.0});
    },function(){
        $(this).stop().animate({opacity: 0});
    });


});

$(document).ready(function(){
   $('#slideshow_left_column').hide().delay(0).fadeIn(1000);
   $('#slideshow_left_column').hide().delay(0).fadeIn(1000);



   $("#small_business").hover(
     function () {
       $('#scribble_small_business').hide().delay(0).fadeIn(0);
     },
     function () {
       $('#scribble_small_business').delay(0).fadeOut(0);
     }
   );

   $("#from_anywhere").hover(
     function () {
       $('#scribble_from_anywhere').hide().delay(0).fadeIn(0);
     },
     function () {
       $('#scribble_from_anywhere').delay(0).fadeOut(0);
     }
   );

   $("#your_honeymoon").hover(
     function () {
       $('#scribble_your_honeymoon').hide().delay(0).fadeIn(0);
     },
     function () {
       $('#scribble_your_honeymoon').delay(0).fadeOut(0);
     }
   );

   $("#wishlist").hover(
     function () {
       $('#scribble_share_wishlist').hide().delay(0).fadeIn(0);
     },
     function () {
       $('#scribble_share_wishlist').delay(0).fadeOut(0);
     }
   );


   $("#your_gifts").hover(
     function () {
       $('#scribble_your_gifts').hide().delay(0).fadeIn(0);
     },
     function () {
       $('#scribble_your_gifts').delay(0).fadeOut(0);
     }
   );


});


