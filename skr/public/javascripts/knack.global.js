var nowait = false;
jQuery(function() {

    $('form').submit(function() {
        setWait();
    });

    $.ajaxSetup({cache: false});
    jQuery('#cat-wrapper').ajaxStart(
            function() {
                if(!nowait)
                {
                    setWait();
                }
            }
        );
    jQuery('#cat-wrapper').ajaxComplete(
        function() {
            resetWait();
            nowait = false;
        }
    );

    jQuery('#menu_holder').hide();

    var hover = false;

    jQuery('#img-find').hover(function(){
        hover = true;
        jQuery('#menu_holder').show();
    }, function(){
        //jQuery('#menu_holder').hide();
    });

    jQuery('#it-find').focus(function(){
       if (jQuery(this).val() == 'Find a registry')
       {
        jQuery(this).val('').removeClass('findaregistry');
       }
    });

    jQuery('#it-find').blur(function(){
       if (jQuery(this).val() == '')
       {
        jQuery(this).val('Find a registry').addClass('findaregistry');
       }
    });


    jQuery('#menu_holder').hover(function(){
        jQuery('#menu_holder').show();
        hover = true;
    }, function(){
        
        jQuery.timer('2000', function(timer){
            if(!hover){
            jQuery('#menu_holder').hide(400);
            timer.stop();
            }
        });
        hover = false;
    });

    jQuery('#btn-find-top').click(function(event){
       event.preventDefault();
       jQuery('#frm-top-find').submit();
    });

    jQuery('.disabled-link').click(function(event)
    {
       event.preventDefault();
    });
    
});

$(document).ajaxSend(function(event, request, settings) {
  if (typeof(AUTH_TOKEN) == "undefined") return;
  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

function setWait()
{
    jQuery('#cat-wrapper').removeClass('tag-none');
    jQuery('#cat-wrapper').css({'opacity': '0.5'});
}

function resetWait(){
	jQuery('#cat-wrapper').addClass('tag-none');
    jQuery('#cat-wrapper').css({'opacity': '0'});
}

jQuery(window).load(function(){
    resetWait();
});

function get_token(){
	return $('input[name="authenticity_token"]').val();
}

var knack_min_amount_to_contribute = 10;

function view_popup(){
	$('#simplemodal-overlay').show();
	$('#simplemodal-container').show();
}

function show_error_popup(number_error){
	jQuery('.block-iframe').modal(
	{
    overlayClose:true,
    minHeight:100,
    minWidth: 200,
    close: true
	});
	jQuery('#errorPopup').attr('src','/buy/errorpage/'+number_error);
}