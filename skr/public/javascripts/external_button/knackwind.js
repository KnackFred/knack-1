var knackLocation = 'https://knackregistry.com/javascripts/external_button/';
//var knackLocation = 'http://localhost:3000/javascripts/external_button/';

//knackInclude();
var kn_partner_id = null;
var kn_product_id = null;
var kn_product_name = null;
var kn_product_price = null;
var kn_product_img = null;
var kn_product_description = null;

function init() {
    if (arguments.callee.done) return;
    arguments.callee.done = true;

    knackStyleButton();
}

// ff, opera
if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", init, false);
}

// ie
/*@cc_on @*/
/*@if (@_win32)
document.write("<script id=__ie_onload defer src=javascript:void(0)>");
document.write("<\/script>");
var script = document.getElementById("__ie_onload");
script.onreadystatechange = function() {
    if (this.readyState == "complete") {
        init();
    }
};
/*@end @*/

// safari
if (/WebKit/i.test(navigator.userAgent)) {
    var _timer = setInterval(function() {
        if (/loaded|complete/.test(document.readyState)) {
            clearInterval(_timer);
            delete _timer;
            init();
        }
    }, 10);
}

// others
window.onload = init;



function knackStyleButton()
{
    var btns = getElementByClass('btn-style1');
    for(i=0; i<btns.length; i++)
    {
        btns[i].style.backgroundImage = "url('https://knackregistry.com/javascripts/external_button/buttons/button1.png')";
        btns[i].style.width = "220px";
        btns[i].style.height = "32px";
        btns[i].style.border = "0px solid";
    }
}

function getElementsByClassName(classname)  {
    var node = document.getElementsByTagName("body")[0];
    var a = [];
    var re = new RegExp('\\b' + classname + '\\b');
    var els = node.getElementsByTagName("*");
    for(var i=0,j=els.length; i<j; i++)
        if(re.test(els[i].className))a.push(els[i]);
    return a;
}

function getElementByClass(theClass) {
    var a = new Array();
    //Create Array of All HTML Tags
    var node = document.getElementsByTagName("body")[0];
    var allHTMLTags = node.getElementsByTagName('*');
    //Loop through all tags using a for loop
    for (i=0; i<allHTMLTags.length; i++) {
        //Get all tags with the specified class name.
        if (allHTMLTags[i].className == theClass) {
            a.push(allHTMLTags[i]);
        }
    }

    return a;
}

	
function isInteger( s ) {
    return !isNaN( parseInt( s ) );
}

function isFloat( s ) {
    return !isNaN( parseFloat( s ) );
}

function knackInclude(prtn_id, p_id, p_name, p_price, p_img, p_desc){
    var error_message = 'Error parametrs';
    kn_partner_id = prtn_id;
    if(!isInteger(kn_partner_id))
        {
            alert(error_message);
            return;
        }
    kn_product_id = p_id;
    if(!isInteger(kn_product_id))
        {
            alert(error_message);
            return;
        }
    kn_product_name = p_name;
    if(kn_product_name == '' || kn_product_name == null)
        {
            alert(error_message);
            return;
        }
    kn_product_price = p_price;
    if(!isFloat(kn_product_id))
        {
            alert(error_message);
            return;
        }
    kn_product_image = p_img;
    kn_product_description = p_desc;

	var x=document.getElementsByTagName('body').item(0);

    var o=document.createElement('script');
    if(typeof(o)!='object') 
        o=document.standardCreateElement('script');
    o.setAttribute("src", knackLocation+'dom-drag.js?t='+ (new Date()));
    o.setAttribute("type", 'text/javascript');
    x.appendChild(o);


    var myCss=document.createElement("link");
	
    myCss.setAttribute('rel','stylesheet');
    myCss.setAttribute('href', knackLocation+'knackmain.css?t='+ (new Date()));
    myCss.setAttribute('type', 'text/css');
    x.appendChild(myCss);

	
    var myDiv=document.createElement('script');
	if(typeof(myDiv)!='object')
		myDiv=document.createElement('script');
    myDiv.src = knackLocation+"div.js?t="+ (new Date());
    myDiv.type = "text/javascript";
    x.appendChild(myDiv);


    var myMain=document.createElement('script');
	if(typeof(myMain)!='object')
		myMain=document.createElement('script');
    myMain.setAttribute('src',knackLocation+'main.js?t='+ (new Date()));
    myMain.setAttribute('type','text/javascript');
    x.appendChild(myMain);

}


