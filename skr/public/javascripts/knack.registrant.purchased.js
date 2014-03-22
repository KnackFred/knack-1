jQuery(function(){
    initialize_show_button();

    jQuery('input[type=radio].product').click(function(){
        var id = jQuery(this).attr('r2pid');
        if(jQuery(this).val() == '3')
            {
                jQuery('.btn-procReq[dataid="'+id+'"]').addClass('tag-none');
            }
            else
                {
                    jQuery('.btn-procReq[dataid="'+id+'"]').removeClass('tag-none');
                }
    });

    jQuery('input[type=radio].cash').click(function(){
        if(jQuery(this).val() == '3')
            {
                jQuery('#btn-cash').addClass('tag-none');
            }
            else
                {
                    jQuery('#btn-cash').removeClass('tag-none');
                }
    });

   //set value select of count per page
   jQuery('#per_page option[value="'+ jQuery('#countP').val()+'"]').attr('selected', 'selected');

   //event change count per pager
   jQuery('#per_page').change(function(){
        jQuery('#countP').val(jQuery('#per_page option:selected').val());

       var radio = jQuery('input[type=radio].product');
       var purchased = jQuery('#purchased').val();

       for(i=0; i<radio.length;i++)
           {
               if(radio[i].checked)
                   {
                       var str = radio[i].id.split('_');
                       var index = purchased.indexOf(str[1]+'i', 0) + str[1].length + 2;
                       purchased = purchased.replaceAt(index, str[2]);
                   }
           }
        jQuery('#purchased').val(purchased);
        jQuery('#pager').submit();
   });

   //event change page
   jQuery('#div-pager a').bind('click', function(event){
       event.preventDefault();

       var radio = jQuery('input[type=radio].product');
       var purchased = jQuery('#purchased').val();

       for(i=0; i<radio.length;i++)
           {
               if(radio[i].checked)
                   {
                       var str = radio[i].id.split('_');
                       var index = purchased.indexOf(str[1]+'i', 0) + str[1].length + 2;
                       purchased = purchased.replaceAt(index, str[2]);
                   }
           }
        jQuery('#purchased').val(purchased);

       jQuery('#currentP').val(jQuery(this).attr('pageid'));
       jQuery('#pager').submit();
   });

   jQuery('#process').click(function(){
       var radio = jQuery('input[type=radio].product');
       var purchased = jQuery('#purchased').val();

       for(i=0; i<radio.length;i++)
           {
               if(radio[i].checked)
                   {
                       var str = radio[i].id.split('_');
                       var index = purchased.indexOf(str[1]+'i', 0) + str[1].length + 2;
                       purchased = purchased.replaceAt(index, str[2]);
                   }
           }
       jQuery('#purchased').val(purchased);
       jQuery('#purc').val(purchased);
       jQuery('#form-purchased').submit();
    });

   jQuery('.btn-procReq').click(function(){
       var id = jQuery.trim(jQuery(this).attr('dataid'));
       var radio = jQuery('input[type=radio].product[r2pid='+id+']');
       var purchased = jQuery('#purchased').val();

       for(i=0; i<radio.length;i++)
           {
               if(radio[i].checked)
                   {
                       var str = radio[i].id.split('_');
                       var index = purchased.indexOf(str[1]+'i', 0) + str[1].length + 2;
                       purchased = purchased.replaceAt(index, str[2]);
                   }
           }
       jQuery('#purchased').val(purchased);
       jQuery('#purc').val(purchased);
       jQuery('#form-purchased').submit();
   });

   jQuery('#form-purchased').ajaxForm(function(param){
      if(param == 1)
        {
            show_error_popup(2);
        }
      else
        {
            document.location.assign('/cart');
        }
   });

   var purchased = jQuery('#purchased').val();
   if(purchased != '')
       {
          //var radio = jQuery('input[type=radio]');
          var pur = purchased.split(',')
          for(i=0; i< pur.length; i+=2)
              {
                  jQuery('#action_'+pur[i].replace('i','')+'_'+pur[i+1]).attr('checked','checked');
              }
       }
//   jQuery('input[type=radio][value=2]').click(function(){
//      a =1;
//   });
});

function initialize_show_button()
{
    //var radio = jQuery('input[type=radio].product');
       var purchased = jQuery('#purchased').val();
       var purch_arr = purchased.split(',');

       for(i=0; i < purch_arr.length; i=i+2)
           {
               if(purch_arr[i+1] == '3')
                   {
                       var id = purch_arr[i].replace('i', '');
                       jQuery('.btn-procReq[dataid="'+id+'"]').addClass('tag-none');
                   }
           }
           
        if(jQuery('input[type=radio].cash[checked="checked"]').val() == '3')
            {
                jQuery('#btn-cash').addClass('tag-none');
            }
            else
                {
                    jQuery('#btn-cash').removeClass('tag-none');
                }
}


String.prototype.replaceAt=function(index, ch) {
      return this.substr(0, index) + ch + this.substr(index+ch.length);
   }
