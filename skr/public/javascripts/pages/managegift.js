jQuery(function(){
   jQuery('.content-wrapper').css({'opacity': '0.5'});
   jQuery('.purchased').hide();
   jQuery('.unpurchased').hide();
   jQuery('.ordered').hide();
   jQuery('.div-credit').hide();

   jQuery('.circle1').hover(function(){
      jQuery('.purchased').show();
   },function(){
      jQuery('.purchased').hide();
    }
    );

    jQuery('.circle2').hover(function(){
      jQuery('.unpurchased').show();
   },function(){
      jQuery('.unpurchased').hide();
    }
    );

    jQuery('.circle3').hover(function(){
      jQuery('.ordered').show();
   },function(){
      jQuery('.ordered').hide();
    }
    );

    jQuery('.circle4').hover(function(){
      jQuery('.div-credit').show();
   },function(){
      jQuery('.div-credit').hide();
    }
    );
});