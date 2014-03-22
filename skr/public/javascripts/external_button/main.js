var im1=document.getElementById("pic0");
var i=0;
var n=0;
//var doc=window.content.document;
var doc=window.document;
var _kn_add = -1;
var myLogo = knackLocation + "logo.png";
var noImg = knackLocation + "noimage.png";
var flag = false;
var knack_reg = /\$+\d+\.\d+/g;
var knack_uid;
var knack_ustate;
var knack_ucity;
var knack_uzip;

var knack_sstate = '';
var knack_scity = '';
var knack_szip = '';

var kn_registry_id = getCookie('registry_id');
var domain = "https://knackregistry.com";
//var domain = "http://localhost:3000";
var kn_registry_name = null;
var isGetRegName = false;

knackDragInit();
function knackDragInit(){
	if(Drag){
		Drag.init(document.getElementById("knack-header"),document.getElementById("knackWindow"));
	} else{
		setTimeout("knackDragInit",1000);
	}
	
}

function knackLoginDragInit(){
	if(Drag){
		Drag.init(document.getElementById("knack-header-login"),document.getElementById("knackLoginWindow"));
	} else{
		setTimeout("knackDragInit",1000);
	}

}

function knackRegisterDragInit(){
	if(Drag){
		Drag.init(document.getElementById("knack-header-register"),document.getElementById("knackRegisterWindow"));
	} else{
		setTimeout("knackDragInit",1000);
	}

}
domReady(onWindowLoad());
//onWindowLoad();

function onWindowLoad(){
	
	if(kn_product_name.length>50){
		document.getElementById("HName").innerHTML=kn_product_name.substr(0,50);
	}else{
		document.getElementById("HName").innerHTML=kn_product_name;
	}
		
		
        if(kn_product_image != ""){

                im1.src=kn_product_image;
                imageZoom(im1);
        }

        if(kn_registry_id != null)
        {
            knackGetNameRegystry(kn_registry_id);
        }

        document.getElementById("HPrice").innerHTML = kn_product_price;
        document.getElementById('HComment').innerHTML = kn_product_description;
        document.getElementById('HPartner').value = kn_partner_id;
        document.getElementById('HProduct').value = kn_product_id;
        //document.getElementById('HRegistry').value = '';
        document.getElementById('knackWindow').style.visibility = "visible";
}

function knackOpenRegistration()
{
    createKnackRegisterWindow();
    knackRegisterDragInit();
}

function imageZoom(im){
	if((im.width>im.height)&&(im.width>140)){
				im1.setAttribute('max-width','140');
				im1.setAttribute('max-height','');
	}
	else if((im.width<im.height)&&(im.height>170)){
				im1.setAttribute('max-height','170');
				im1.setAttribute('max-width','');
	}
	
}

function knackLogin()
{
    document.getElementById('knack-wait-wrapper').style.visibility = "visible";
    var documentBody = document.getElementsByTagName("body")[0];
    var newScript = document.createElement('script');
    var email = document.getElementById('knackEmail').value;
    var password = document.getElementById('knackPass').value;
    newScript.id = "knackLogin";
    newScript.type = 'text/javascript';
    newScript.src = domain + "/registrant/extlogin?e="+ email +"&p="+ password +"&j=1";

    documentBody.appendChild(newScript);
}

function knackGetLoginRequest(n){
	var _kn_arr = n.split('_');

	if(parseInt(_kn_arr[0])==200){
                setCookie("registry_id", _kn_arr[1], addDays(new Date(),7), '/');
                knackGetNameRegystry(_kn_arr[1]);
                exitKnackLogin();
                kn_registry_id = _kn_arr[1];
		document.getElementById('knack-wait-wrapper').style.visibility = "hidden";
	} else{
            alert('Login failed.');
	}
}

function knackRegister()
{
    document.getElementById('knack-wait-wrapper').style.visibility = "visible";
    var documentBody = document.getElementsByTagName("body")[0];
    var newScript = document.createElement('script');
    var firstName = document.getElementById('knackFirstName').value;
    var lastName = document.getElementById('knackLastName').value;
    var email = document.getElementById('knackRegEmail').value;
    var password = document.getElementById('knackRegPass').value;
    var conf_password = document.getElementById('knackConfPass').value;
    var city = document.getElementById('knackCity').value;
    var state = document.getElementById('knackState').value;
    var zip = document.getElementById('knackZIP').value;
    var agree = document.getElementById('knackAgree').value;
    newScript.id = "knackRegister";
    newScript.type = 'text/javascript';
    newScript.src = domain + "/registrant/extregister?fn="+ firstName +"&ln="+ lastName +"&e="+ email +"&p="+ password +"&pc="+ conf_password +"&c="+ city +"&s="+ state +"&z="+ zip +"&a="+ agree +"&j=1";

    documentBody.appendChild(newScript);
}

function knackGetRegisterRequest(n){
	var _kn_arr = n.split('_');

	if(parseInt(_kn_arr[0])==200){
                setCookie("registry_id", _kn_arr[1], addDays(new Date(),7), '/');
                knackGetNameRegystry(_kn_arr[1]);
                exitKnackRegister();
                exitKnackLogin();
                kn_registry_id = _kn_arr[1];
		document.getElementById('knack-wait-wrapper').style.visibility = "hidden";
	} else{
            _kn_arr = n.split(',');
            for(i=0;i<_kn_arr.length;i+=2)
                {
                    switch (_kn_arr[i]) {
                case '1':
                     document.getElementById('knackFirstName').style.backgroundColor = '#FFAAAA';
                    break;
                case '2':
                    document.getElementById('knackLastName').style.backgroundColor = '#FFAAAA';
                    break;
                case '3':
                    document.getElementById('knackRegEmail').style.backgroundColor = '#FFAAAA';
                    break;
                case '4':
                    document.getElementById('knackRegPass').style.backgroundColor = '#FFAAAA';
                    break;
                case '5':
                    document.getElementById('knackConfPass').style.backgroundColor = '#FFAAAA';
                    break;
                case '6':
                    document.getElementById('knackCity').style.backgroundColor = '#FFAAAA';
                    break;
                case '7':
                    document.getElementById('knackState').style.backgroundColor = '#FFAAAA';
                    break;
                case '8':
                    document.getElementById('knackZIP').style.backgroundColor = '#FFAAAA';
                    break;
                case '9':
                    document.getElementById('knackAgree').style.backgroundColor = '#FFAAAA';
                    break;
                default:
                    break;
            }

                }
	}
}

function knackGetNameRegystry(id)
{
    document.getElementById('knack-wait-wrapper').style.visibility = "visible";
    var documentBody = document.getElementsByTagName("body")[0];
    var newScript = document.createElement('script');
    newScript.id = "knackRegistryName";
    newScript.type = 'text/javascript';
    newScript.src = domain + "/registrant/extregname?g="+id+"&j=1&t="+ (new Date()).getTime();

    documentBody.appendChild(newScript);
}

function knackGetNameRegistryRequest(n){
	var _kn_arr = n.split('_');
	if(parseInt(_kn_arr[0])==200){
		document.getElementById('knack-wait-wrapper').style.visibility = "hidden";
                kn_registry_name = _kn_arr[1];
                var registry_block = document.getElementById('knack-registry-block');
                registry_block.innerHTML = 'Hello ' + _kn_arr[1] + '!';
	} else{
            alert('Login failed.');
	}

        isGetRegName = true;
}

function knackAddToRegistry(){
           
            if(kn_registry_id == null)
            {
                createKnackLoginWindow();
                knackLoginDragInit();
            }
            else
            {
                knackSkipBgcolor();
                knackSendGift();
		//window.alert(_kn_add);
            }
}

 
function exitKnack(){
	document.getElementById('knack_add_result').style.visibility = "hidden";
	document.getElementById('knack-wait-wrapper').style.visibility = "hidden";
	knackHideTaxForm();
	document.getElementById('knackWindow').style.visibility = "hidden";
	window.location.reload();
}

function exitKnackLogin(){
	document.getElementById('knack-wait-wrapper').style.visibility = "hidden";
        document.body.removeChild(document.getElementById('knackLoginWindow'));
}

function exitKnackRegister(){
	document.getElementById('knack-wait-wrapper').style.visibility = "hidden";
        document.body.removeChild(document.getElementById('knackRegisterWindow'));
}
 

function knackSkipBgcolor(){
	document.getElementById('HName').style.background = '#fff';
	document.getElementById('HPrice').style.background = '#fff';
	document.getElementById('HQuantity').style.background = '#fff';
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

function setCookie (name, value, expires, path, domain, secure) {
      document.cookie = name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}

function getCookie(name) {
	var cookie = " " + document.cookie;
	var search = " " + name + "=";
	var setStr = null;
	var offset = 0;
	var end = 0;
	if (cookie.length > 0) {
		offset = cookie.indexOf(search);
		if (offset != -1) {
			offset += search.length;
			end = cookie.indexOf(";", offset)
			if (end == -1) {
				end = cookie.length;
			}
			setStr = unescape(cookie.substring(offset, end));
		}
	}
	return(setStr);
}

function addDays(date, n) {
	// может отличаться на час, если произошло событие перевода времени
	var d = new Date();
	d.setTime(date.getTime() + n * 24 * 60 * 60 * 1000);
	return d;
}


function knackSendGift(){


    var knack_gift = document.getElementById('HName').innerHTML;

    var knack_comment;
    if(document.getElementById('HComment').innerHTML.length>500){
            knack_comment = document.getElementById('HComment').innerHTML.substr(0,500);
    }else{
            knack_comment = document.getElementById('HComment').innerHTML;
    }

    var knack_gift_price = document.getElementById('HPrice').innerHTML;
    var knack_quantity = document.getElementById('HQuantity').value;
    var knack_partner = document.getElementById('HPartner').value;
    var knack_product = document.getElementById('HProduct').value;



    if((knack_gift.length>0)&&(knack_gift_price.length>0)&&(knack_gift_price!=0)&&(knack_quantity.length>0)&&(kn_registry_id!=null)&&(knack_partner.length>0)){
            document.getElementById('knack-wait-wrapper').style.visibility = "visible";
            var documentBody = document.getElementsByTagName("body")[0];
        var newScript = document.createElement('script');
            newScript.id = "addToReg";
            newScript.type = 'text/javascript';
            newScript.src = domain + "/registrant/extaddgiftp?t="+escape(knack_gift)+"&p="+escape(knack_gift_price)+"&q="+escape(knack_quantity)+'&i='+encodeURIComponent(im1.src)+'&d='+escape(knack_comment)+"&pid="+escape(knack_partner)+"&r="+escape(kn_registry_id)+"&prid=" + escape(knack_product) + "&j="+1+"&tm="+new Date().getTime();

            documentBody.appendChild(newScript);
     }else{
            if(knack_gift.length==0){
                    document.getElementById('HName').style.background = 'pink';
                    document.getElementById('HName').focus();
                    return;
            }
            if((knack_gift_price.length==0)||(knack_gift_price==0)){
                    document.getElementById('HPrice').style.background = 'pink';
                    document.getElementById('HPrise').focus();
                    return;
            }
            if(knack_quantity.length==0){
                    document.getElementById('HQuantity').style.background = 'pink';
                    document.getElementById('HQuantity').focus();
                    return;
            }

     }
}

function knackGetAddRequest(n){

	if(parseInt(n)==0){

		document.getElementById('knack-add-result').innerHTML = "Item is successfully added, Please check your <a style='text-decoration:underline;cursor:pointer;color: #6599CB;' onclick='gotoRegistry();'>registry</a>.";
	}else{
		document.getElementById('knack-add-result').firstChild.nodeValue = "Unfortunately we can't add your item, please try later.";
	}
	document.getElementById('knack_add_result').style.visibility = "visible";
	document.getElementById('knack-wait-wrapper').style.visibility = "hidden";
}

function gotoRegistry()
{
    window.open(domain+'/registrant/login_guid/'+kn_registry_id);
}


/**************** not use ******************/
function knackSendTax(){

		var knack_gift_price = document.getElementById('HPrice').value;
		knack_sstate = document.getElementById('HSState').value;
		knack_scity = document.getElementById('HSCity').value;
		knack_szip = document.getElementById('HSZip').value;
		if(knack_sstate!=0){
			document.getElementById('HSState').style.background = '#fff';
			document.getElementById('knack-wait-wrapper').style.visibility = "visible";
			var documentBody = document.getElementsByTagName("body")[0];
		    var newScript = document.createElement('script');
			newScript.id = "calculateTax";
			newScript.type = 'text/javascript';
			newScript.src = domain + "/registrant/exttax?r="+knack_uid+"&s="+knack_sstate+"&c="+escape(knack_scity)+"&z="+knack_szip+"&p="+escape(knack_gift_price)+"&j=1&tm="+new Date().getTime();

			documentBody.appendChild(newScript);
	}else{
		document.getElementById('HSState').style.background = 'pink';
		return;
	}
}

function knackGetTaxRequest(n){
	//alert(n);
	var _kn_arr = n.split('_');

	if(parseInt(_kn_arr[0])==200){
		//alert(_kn_arr[1]);
		document.getElementById("knack-tax-value").firstChild.nodeValue="$ "+_kn_arr[1];
		document.getElementById('knack-wait-wrapper').style.visibility = "hidden";
		knackHideTaxForm();
	} else{
	alert('Can\'t calculate tax!');
	}
}


function knackShowTaxForm(){
	knackSkipBgcolor();
	if((document.getElementById('HPrice').value.length>0)&&(document.getElementById('HPrice').value!=0)){
		document.getElementById('knack-tax-form').style.visibility = "visible";
	} else{
		document.getElementById('HPrice').style.background = 'pink';
		document.getElementById('HPrise').focus();
		return;
	}
}

function knackHideTaxForm(){
		document.getElementById("knack-tax-form").style.visibility = "hidden";
}
function knackCalculateTax(){
	knackSendTax();
}

function knackHideResult(){
	document.getElementById('knack_add_result').style.visibility="hidden";
}