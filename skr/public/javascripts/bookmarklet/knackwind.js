var knack_host = "http://localhost:3000/";
//var knack_host = "https://preview.knackregistry.com/";
//var knack_host = "https://knackregistry.com/";
var knackLocation = knack_host + 'javascripts/bookmarklet/';

knackInclude();

function knackInclude(){	
	var x=document.getElementsByTagName('body').item(0);

    var o=document.createElement('script');
    if(typeof(o)!='object') 
		o=document.standardCreateElement('script');
    o.setAttribute('src',knackLocation+'dom-drag.js');
    o.setAttribute('type','text/javascript');
    x.appendChild(o);

    var o=document.createElement('script');
    if(typeof(o)!='object')
        o=document.standardCreateElement('script');
    o.setAttribute('src','https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js');
    o.setAttribute('type','text/javascript');
    x.appendChild(o);


    var myCss=document.createElement('link');
	
	myCss.setAttribute('rel','stylesheet');
    myCss.setAttribute('href',knackLocation+'knackmain.css');
    myCss.setAttribute('type','text/css');
    x.appendChild(myCss);

	
    var myDiv=document.createElement('script');
	if(typeof(myDiv)!='object')
		myDiv=document.createElement('script');
    myDiv.src = knackLocation+"div.js";
    myDiv.type = "text/javascript";
    x.appendChild(myDiv);


    var myMain=document.createElement('script');
	if(typeof(myMain)!='object')
		myMain=document.createElement('script');
    myMain.setAttribute('src',knackLocation+'main.js');
    myMain.setAttribute('type','text/javascript');
    x.appendChild(myMain);

}


