var im1=document.getElementById("pic0");
var i=0;
var n=0;
//var doc=window.content.document;
var doc=window.document;
var _kn_add = -1;
var myLogo = knackLocation + "logo.png";
var noImg = knackLocation + "noimage.png";
var flag = false;
var knack_reg = /\$+[0-9,]+\.\d+/g;
var knack_reg2 = /[0-9]+\.\d{2}/g;
var knack_uid;

var normal_height = 335;
var expanded_height = 480;

//alert(_kn_param);
knackGetCustomerData();
function knackGetCustomerData(){
    var paramStr = knackGetParams();

    var paramArr = paramStr.split('_');
    knack_uid = paramArr[0];

}

function knackGetPrice(){
    var price_arr;
    if((price_arr = knack_reg.exec(doc.body.innerHTML))!=null) {

        for (var i = 0; i < price_arr.length; i++) {
            var price1 = parseFloat(price_arr[i].replace(/,/g,'').substr(1));
            if (price1 > 0 ) {
                return price1;
            }
        }

    }

    if((price_arr = knack_reg2.exec(doc.body.innerHTML))!=null) {
        for (var l = 0; l < price_arr.length; l++) {
            var price2 = parseFloat(price_arr[l].replace(/,/g,''));
            if (price2 > 0 ) {
                return price2;
            }
        }
    }

    return '';
}


var img=new Array();
knackGetImages();
function knackGetImages(){

    var largest_size = 0;
    while(i<doc.images.length){
        if ((doc.images[i].src!=myLogo)&&(doc.images[i].src!=noImg)&&((doc.images[i].width>60)||(doc.images[i].height>60))&&((doc.images[i].width/doc.images[i].height>=0.5)&&(doc.images[i].width/doc.images[i].height<=1.5))){
            if (doc.images[i].width * doc.images[i].height > largest_size) {
                largest_size = doc.images[i].width * doc.images[i].height;
                img.unshift(doc.images[i]);
            } else {
                img.push(doc.images[i]);
            }
        }
        i++;
    }

}

function knackDragInit(){
	if(Drag){
		Drag.init(document.getElementById("knack-header"),document.getElementById("knackWindow"));
	} else{
		setTimeout("knackDragInit",1000);
	}
	
}
domReady(onWindowLoad());   

function onWindowLoad(){


    var knack_gift = parse_name(doc.title)

    document.getElementById("HName").value = knack_gift;

    if(img.length>0){

        im1.src=img[0].src;
        imageZoom(im1);
        document.getElementById("image-number").firstChild.nodeValue="1 of "+img.length;

    }
    document.getElementById("HPrice").value = knackGetPrice();
    document.getElementById('knackWindow').style.visibility = "visible";
    knackDragInit();
    knackGetSections();
    knackGetSuggestions();
}

function parse_name (title) {
    if (title.indexOf("Macy's") != -1)
        title = title.split(" - ")[0]
    if (title.indexOf(": Target") != -1)
        title = title.split(" : ")[0]
    if (title.indexOf("- Bed Bath & Beyond") != -1)
        title = title.split(" - ")[0]
    if (title.indexOf("? Wallmart") != -1)
        title = title.split(" ? ")[0]
    if (title.indexOf("- Belk.com") != -1)
        title = title.split(" - ")[0]
    if (title.indexOf("- Bloomingdale") != -1)
        title = title.split(" - ")[0]
    if (title.indexOf("Amazon.com:") != -1)
        title = title.substr(12)
    if (title.indexOf("| Williams-Sonoma") != -1)
        title = title.split(" | ")[0]
    if (title.indexOf(" | Crate and Barrel") != -1)
        title = title.split(" | ")[0]
    if (title.indexOf(" | Pottery Barn") != -1)
        title = title.split(" | ")[0]
    if (title.indexOf("Z Gallerie - ") != -1)
        title = title.substr(13)
    if (title.indexOf(" - Anthropologie.com") != -1)
        title = title.split(" - ")[0]
    if (title.indexOf("The Home Depot") != -1)
        title = title.split(" at The Home Depot")[0]

    return title.substr(0, 50);
}

function prevImage(){
	if(n>0){
		
		im1.src=img[--n].src;
		imageZoom(img[n]);
		document.getElementById("image-number").firstChild.nodeValue=(n+1)+" of "+img.length;
		flag = false;
		}
}


function nextImage(){
	if((n<img.length)&&(!flag)){
		
		im1.src=img[++n].src;
		if (n==img.length-1)
			flag = true;
		imageZoom(img[n]);
		document.getElementById("image-number").firstChild.nodeValue=(n+1)+" of "+img.length;

		}
}

function imageZoom(im){
	//var prop = im.width/im.height;
	if((im.width>im.height)&&(im.width>140)){
				im1.setAttribute('width','140');
				im1.setAttribute('height','');
	}
	else if((im.width<im.height)&&(im.height>170)){
				im1.setAttribute('height','170');
				im1.setAttribute('width','');
	}
	
}

function knackAddToRegistry(){
		
		knackSkipBgcolor();
		knackSendGift();
		//window.alert(_kn_add);
}

function knackSendGift(){


    var knack_gift = document.getElementById('HName').value;

    var knack_comment = document.getElementById('HComment').value;

    var knack_gift_price = parseFloat(document.getElementById('HPrice').value);
    var knack_quantity = parseInt(document.getElementById('HQuantity').value);

    var knack_color = document.getElementById('HColor').value;
    var knack_size = document.getElementById('HSize').value;
    var knack_other= document.getElementById('HOther').value;

    var knack_store_host=doc.location.hostname;
    var knack_store_arr=knack_store_host.split('.');
    var knack_store_name = knack_store_arr[knack_store_arr.length-2] + '.' + knack_store_arr[knack_store_arr.length-1];

    var knack_section_id = document.getElementById('HSection').value;

    if( knack_gift.length > 0 && knack_gift.length <= 50 &&
        !isNaN(knack_gift_price) && !isNaN(knack_quantity != null) &&
        knack_comment.length <= 900 && knack_color.length <= 50 && knack_size.length <= 50 && knack_other.length <= 50
        )
    {
        document.getElementById('knack-wait-wrapper').style.visibility = "visible";
        var documentBody = document.getElementsByTagName("body")[0];
        var newScript = document.createElement('script');
        newScript.id = "addToReg";
        newScript.type = 'text/javascript';
        newScript.src = knack_host + "registrant/extaddgift?t="+encodeURIComponent(knack_gift)+"&p="+encodeURIComponent(knack_gift_price)+"&q="+encodeURIComponent(knack_quantity)+'&i='+encodeURIComponent(im1.src)+'&d='+encodeURIComponent(knack_comment)+'&n='+knack_store_name+'&s='+encodeURIComponent(doc.location)+"&r="+knack_uid+"&tm="+new Date().getTime()+"&sec="+knack_section_id+'&ec='+encodeURIComponent(knack_color)+'&es='+encodeURIComponent(knack_size)+'&eo='+encodeURIComponent(knack_other);

        documentBody.appendChild(newScript);
    }else{
        if(knack_comment.length > 900){
            document.getElementById('HComment').style.background = 'pink';
            document.getElementById('HComment').focus();
        }
        if(isNaN(knack_quantity)) {
            document.getElementById('HQuantity').style.background = 'pink';
            document.getElementById('HQuantity').focus();
        }
        if(isNaN(knack_gift_price)) {
            document.getElementById('HPrice').style.background = 'pink';
            document.getElementById('HPrise').focus();
        }
        if(knack_gift.length==0 || knack_gift.length > 50){
            document.getElementById('HName').style.background = 'pink';
            document.getElementById('HName').focus();
        }
        if(knack_color.length > 50){
            document.getElementById('HColor').style.background = 'pink';
            document.getElementById('HColor').focus();
        }
        if(knack_size.length > 50){
            document.getElementById('HSize').style.background = 'pink';
            document.getElementById('HSize').focus();
        }
        if(knack_other.length > 100){
            document.getElementById('HOther').style.background = 'pink';
            document.getElementById('HOther').focus();
        }

    }
}

function knackGetAddRequest(n){
	
	if(parseInt(n)==0){
		
		document.getElementById('knack-add-result').firstChild.nodeValue = "Item is successfully added, Please check your registry.";
	}else{
		document.getElementById('knack-add-result').firstChild.nodeValue = "Unfortunately we can't add your item, please try later.";
	}
	document.getElementById('knack_add_result').style.visibility = "visible";
	document.getElementById('knack-wait-wrapper').style.visibility = "hidden";
}

function knackGetSections() {
    var documentBody = document.getElementsByTagName("body")[0];
    var newScript = document.createElement('script');
    newScript.id = "sections";
    newScript.type = 'text/javascript';
    newScript.src = knack_host + "registrant/ext_sections/" + knack_uid;
    documentBody.appendChild(newScript);
}

function knackLoadSections(sections) {
    $(sections).each( function (index, item) {
        if (item.section.title.length != 0) {
            var new_section = $('<option></option>').attr("value", item.section.id).text(item.section.title);
            $("#HSection").append(new_section);
        }
    });
}

function knackGetSuggestions() {
    var knack_gift = document.getElementById('HName').value;

    var documentBody = document.getElementsByTagName("body")[0];
    var newScript = document.createElement('script');
    newScript.id = "suggestions";
    newScript.type = 'text/javascript';
    newScript.src = knack_host + "browse/suggest_products?query=" + knack_gift;

    documentBody.appendChild(newScript);
}

function knackLoadSuggestions(suggestions) {
    $('#KnackSuggestions').html("")

    if ($(suggestions).length == 0) {
        $('#knackWindow').animate( {height: normal_height } );
        $('#knack-footer').hide();
    } else {
        $(suggestions).each( function (index, suggestion) {
            var new_suggestion = $('.KnackProductTemplate').clone().removeClass('KnackProductTemplate');
            template_suggestion(new_suggestion, suggestion.product).appendTo('#KnackSuggestions').show();
        });
        $('#knack-footer').show();
        $('#knackWindow').animate( {height: expanded_height } );

    }
}

function template_suggestion(template, suggestion) {
    template.find('img').attr("src", knack_host+ suggestion.small_thumb_url )
    template.find('a').attr("href", knack_host+'item/0/'+ suggestion.id +'/item')
    template.find('.KnackName').text(suggestion.Name)
    template.find('.KnackPrice').text("$" + parseFloat(suggestion.Price).toFixed(2))
    return template;
}

function exitKnack(){
	document.getElementById('knack_add_result').style.visibility = "hidden";
	document.getElementById('knack-wait-wrapper').style.visibility = "hidden";
	document.getElementById('knackWindow').style.visibility = "hidden";
	window.location.reload();
}
 

function knackSkipBgcolor(){
	document.getElementById('HName').style.background = '#fff';
	document.getElementById('HPrice').style.background = '#fff';
	document.getElementById('HQuantity').style.background = '#fff';
	document.getElementById('HComment').style.background = '#fff';
}

function knackHideResult(){
	document.getElementById('knack_add_result').style.visibility="hidden";
}

function domReady( f ) {
if ( domReady.done ) {
   domReady.done = false;
   return f();
}

if ( domReady.timer ) {
   domReady.ready.push( f );
} else {
   if (window.addEventListener)
    window.addEventListener('load',isDOMReady, false);
   else if (window.attachEvent)
    window.attachEvent('onload',isDOMReady);
   domReady.ready = [ f ];
   domReady.timer = setInterval(isDOMReady, 50);
   }
}

function isDOMReady(){
   if ( domReady.done ) return false;

   if ( document && document.getElementsByTagName && document.getElementById && document.body ) {
       clearInterval( domReady.timer );
       domReady.timer = null;

       for ( var i = 0; i < domReady.ready.length; i++ ){
           domReady.ready[i]();
		}
       domReady.ready = null;
       domReady.done = true;
   }
}

