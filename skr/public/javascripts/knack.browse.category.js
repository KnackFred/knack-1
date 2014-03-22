jQuery(function(){

    if (jQuery('#textfind').val() != 'Type gift name')
    {
        jQuery('#textfind').removeClass('findaregistry');
    }

    jQuery('#textfind').focus(function(){
       if (jQuery(this).val() == 'Type gift name')
       {
        jQuery(this).val('').removeClass('findaregistry');
       }
    });

    jQuery('#textfind').blur(function(){
       if (jQuery(this).val() == '')
       {
        jQuery(this).val('Type gift name').addClass('findaregistry');
       }
    });

	$("#textfind").keyup(function(event){
	  if(event.keyCode == 13){
		event.preventDefault();
	    $("#go").click();
	  }
	});

    $("#textfind").autocomplete(
        {
            serviceUrl: '/browse/search', 
            minChars: 1, 
            delimiter: /(,|;)\s*/, 
            maxHeight: 200,
            width: 300, 
            zIndex: 9999, 
            params: {cid : jQuery('#cat_id').val()},
            deferRequestBy: 600,
            onSelect: function(value, data) {
                setWait();
                document.location.assign(data);
            }
        });

    //menu-active
    jQuery('#dm-browse').css('background', 'none repeat scroll 0 0 #d9e5cc');

    if (jQuery('#values').val() != '' && jQuery('#values').val() != null)
    {
    var values = jQuery('#values').val().split(',');

    var start = 0;
    var finish = values.length-1;
    var step = 1;
    var indexL = parseInt(jQuery('#valleft').val());
    var indexR = parseInt(jQuery('#valright').val());

    jQuery('#min-price').text(Number(values[start]).toFixed(2));
    jQuery('#max-price').text(Number(values[finish]).toFixed(2));
    jQuery('#leftvalue').text('$' + Number(values[indexL]).toFixed(2));
    jQuery('#rightvalue').text('$' + Number(values[indexR]).toFixed(2));
    $("#amount-text").val('$' + values[start] + '-' + values[finish]);

    if (start == finish)
        $( "#slider-range-min" ).slider( "option", "disabled", true );
    else
        {
   //slider
   $("#slider-range-min").slider({
			range: true,
			min: start,
			max: finish,
      values: [indexL, indexR],
      step: step,
			slide: function(event, ui) {
          var values = jQuery('#values').val().split(',');

         	var indexL = ui.values[0];
	        var indexR = ui.values[1];

	        if(indexL == indexR)
	            {
	                if(indexL == 0)
	                    {
	                        indexR = 1;
	                    }
	                    else
	                        if(indexR == values.length - 1)
	                            {
	                                indexL = values.length - 2;
	                            }
	            }

	        ui.values[0] = indexL;
	        ui.values[1] = indexR;
	        jQuery('#leftvalue').text('$' + Number(values[indexL]).toFixed(2));
	        jQuery('#rightvalue').text('$' + Number(values[indexR]).toFixed(2));
	        $("#amount-text").val('$' + values[indexL] + '-' + values[indexR]);
	    },
      stop: function(event, ui){
          var values = jQuery('#values').val().split(',');
          
          var indexL = ui.values[0];
          var indexR = ui.values[1];
          if(indexL == indexR)
              {
                   if(indexL == 0)
                       {
                           indexR = 1;
                       }
                       else
                           if(indexR == values.length - 1)
                               {
                                   indexL = values.length - 2;
                               }
              }
          ui.values[0] = indexL;
          ui.values[1] = indexR;
          $('#valleft').val(indexL);
          $('#valright').val(indexR);
          $('#useslider').val(1);
          $('#page').val('');
          $('#frm-category').submit();
       }
		});
        }
    }
    else
        {
            $('#valleft').val('');
            $('#valright').val('');
        }

   //event change count per pager
   jQuery('#per_page').change(function(){
        jQuery('#per_page_value').val(jQuery('#per_page option:selected').val());
        jQuery('#frm-category').submit();
   });

   //event change page
   $('.pagination > a').click(function(e){
       e.preventDefault();
       var href = $(this).attr('href');
       //        href = href.split('?')[1];
       //        var page = href.split('=')[1];
	   var page = $.getUrlVar(href, 'page');
       $('#page').val(page);
       jQuery('#frm-category').submit();
   });

   jQuery('.category-link').click(function(event){
      event.preventDefault();
      var href = jQuery(this).attr('href');

      $('#page').val('');

      jQuery('#frm-category').attr('action', href);
      jQuery('#use_cat_link').val(1);

      jQuery('#param').val('');
      jQuery('#valparam').val('');

      jQuery('#frm-category').submit();
   });

   //set value select of count per page
   jQuery('#per_page option[value="'+ jQuery('#per_page_value').val()+'"]').attr('selected', 'selected');

    jQuery('#proceed-buy').click(function(event){
        event.preventDefault();
        jQuery('#procbuy').val('true');
        jQuery('#buy').submit();
    });

    //find
    jQuery('#go').click(function(){
        jQuery('#findtext').val(jQuery('#textfind').val());
        jQuery('#findid').val(jQuery('#categories option:selected').val());
        jQuery('#page').val('');
        jQuery('#per_page_value').val('');
        jQuery('#valleft').val('');
        jQuery('#valright').val('');
        jQuery('#param').val('');
        jQuery('#val_param').val('');
        jQuery('#frm-category').attr('action', '/catalog');
        jQuery('#frm-category').submit();
    });

});

function getCorrectValue(values, value)
{
    for(i = 1; i < values.length - 1; i++)
        {
            if((parseFloat(value) >= parseFloat(values[i-1])) && (parseFloat(value) <= parseFloat(values[i])))
                {
                    if(i == values.length - 1)
                        {
                            return values.length - 1;
                        }
                    else
                        {
                            var a = parseFloat(values[i]);
                            var b = parseFloat(values[i+1]);
                            var x = parseFloat(value);

                            var range = b - a;
                            var val = x - a;
                            if((val/range) >= 0.5)
                                return i+1;
                            else
                                return i;
                        }
                }
        }
     return -1;
}

