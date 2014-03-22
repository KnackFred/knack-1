
setPageElementsZindex();
function setPageElementsZindex() {
    var allInputElements = document.getElementsByTagName("input");
    for (var i = 0; i < allInputElements.length; i++) {
        allInputElements[i].style.position = "relative";
        allInputElements[i].style.zIndex = "0";
    }

    var allDivElements = document.getElementsByTagName("div");
    for (var i = 0; i < allDivElements.length; i++) {
        if (allDivElements[i].style.zIndex > 100) {
            allDivElements[i].style.zIndex = 100;
        }
    }
}

if (document.getElementById('knackWindow')){

}
else{
	createKnackWindow();
}

function createKnackWindow(){
	var newD = document.createElement('div');
    newD.setAttribute('id','knackWindow');
    newD.className = 'knack-wraper';
	
	function knackGetClientWidth()
	{
		return document.compatMode=='CSS1Compat' && !window.opera?document.documentElement.clientWidth:document.body.clientWidth;
	}

    var kn_left = knackGetClientWidth()/2 - 275;
    newD.style.position = 'absolute';
    newD.style.height = '370px';
    newD.style.width ='550px';
    newD.style.left= kn_left+'px';
    newD.style.top = '150px';
	
    newD.style.zIndex = '100';
    newD.style.visibility = 'hidden';
    newD.style.background = '#FFFFFF';
    newD.style.border = '1px solid #666';
    
    
    newD.innerHTML = "<div id='knack-header' >\n\
<input type='hidden' id='HPartner'/><input type='hidden' id='HRegistry'/><input type='hidden' id='HProduct'/>       \n\
<div class='div-knack-header'><span id='knack-ht'>Add Item to your Knack Registry Gift List</span></div>\n\
        <a href='javascript:void(0)' onClick='exitKnack();' ><img class='knack-close' src='/images/design/close/btn_close_x.png'/></a>\n\
</div><div  id='knack-content-wraper'><div id='knack-image-side' ><div id='image' style='max-width:140px;max-height:170px;border:solid 0px #ddd;text-align:center;overflow:hidden'>\n\
<img src='"+knackLocation+"noimage.png'  id='pic0'style='max-width:140px;border:solid 0px #ddd'></div><div id='knack-logo'>\n\
<img src='"+knackLocation+"logo.png'></div></div><div id='input-side' style='float:right;width:310px;padding-rigth:60px;border:solid 1px #fff !important;'>\n\
<div id='knack-input-form'><table id='knack-table' style='border:solid 1px #fff !important;padding:0;margin:0;'>\n\
<tr  style='border:solid 1px #fff !important; min-height:0 !important;height:30px !important; vertical-align:bottom !important;padding:0;margin:0;'>\n\
<td colspan='2'style='vertical-align:bottom;padding:0;margin:0;' ><label for='HName' style='margin:0;padding:0;'>Product Name\n\
</label></td></tr><tr style='height:25px;padding:0;margin:0;vertical-align:top;'><td colspan='2' style='border:solid 0px;\n\
padding:0;margin:0;'><div style='width:250px !important;margin:0 !important;' id='HName'></div></td></tr>\n\
<tr style='border:solid 1px #fff !important;height:30px;vertical-align:bottom;padding:0;margin:0;'><td style='vertical-align:\n\
bottom;padding:0;margin:0;'><label for='HPrice'>Price</label></td><td style='vertical-align:bottom;padding:0;margin:0;\n\
padding-left:70px;'><label for='HQuantity'>Quantity</label></td></tr><tr style='height:25px;padding:0;margin:0;\n\
vertical-align:top;'><td style='padding:0;margin:0;vertical-align:top;'><div style='width:100px !important;' id='HPrice'></div></td><td style='padding:0;margin:0;padding-left:70px;vertical-align:top'><input type='text'style='width:40px \n\
!important;' id='HQuantity' value='1'></td></tr><tr style='border:solid 1px #fff !important;height:25px;vertical-align:top;padding:0;margin:0;'>\n\
<td colspan='2' style='vertical-align:bottom;padding:0;margin:0;'><label for='HComment' style='padding:0;margin:0;'>\n\
Comment</label></td></tr><tr style='border:solid 1px #fff \n\
!important;height:90px;vertical-align:bottom;padding:0;margin:0;'><td colspan='2' style='vertical-align:top;padding:0;\n\
margin:0;'><div id='HComment' style='width:250px !important;height:90px !important;'></div></td></tr><tr >\n\
<td colspan='2' style='text-align:right !important; height:30px; vertical-align:bottom;'>\n\
<div class='knack-registry-block' id='knack-registry-block'></div>\n\
<input type='image' src='"+knackLocation+"add.png' onClick='knackAddToRegistry();' style='border:0px !important;padding:0;margin:0;float:right'></td></tr></table></div></div><div id='knack-footer' style='clear:both'></div></div><div id='knack-tax-form' style='width:495px !important;'><div style='float:left;width:180px;text-align:center;padding-top:90px;border:solid 0px'><img src='"+knackLocation+"logo.png'></div><div style='width:310px;float:right;border:solid 0px'><fieldset><legend style='text-align:left'>Your location</legend><table style='width:250px;border:solid 0px; text-align:left;padding:0;margin:0;'><tr style='height:30px !important'><td><label style='float:left' for='HCState'>State</label></td><td style='text-align:right;'><select id='HCState' style='width:155px !important;font-size:10pt !important;border:solid 1px #999;padding:1px !important;margin:0;float:right;' disabled><option value='0' selected>please select</option><option value='1'>Alabama</option><option value='2'>Alaska</option><option value='3'>Arizona</option><option value='4'>Arkansas</option><option value='5'>California</option><option value='6'>Colorado</option><option value='7'>Connecticut</option><option value='8'>Delaware</option><option value='9'>District of Columbia</option><option value='10'>Florida</option><option value='11'>Georgia</option><option value='12'>Hawaii</option><option value='13'>Idaho</option><option value='4'>Illinois</option>	<option value='15'>Indiana</option>	<option value='16'>Iowa</option><option value='17'>Kansas</option><option value='18'>Kentucky</option><option value='19'>Louisiana</option><option value='20'>Maine</option><option value='21'>Matyland</option><option value='22'>Massachusetts</option><option value='23'>Michigan</option><option value='24'>Minnesota</option><option value='25'>Mississippi</option><option value='26'>Missouri</option><option value='27'>Montana</option><option value='28'>Nebraska</option><option value='29'>Nevada</option><option value='30'>New Hampshire</option><option value='31'>New Jersey</option><option value='32'>New Mexico</option><option value='33'>New York</option><option value='34'>North Carolina</option><option value='35'>North Dacota</option><option value='36'>Ohio</option><option value='37'>Oklahoma</option><option value='38'>Oregon</option><option value='39'>Pennsylvania</option><option value='40'>Puerto Rico</option><option value='41'>Rhode Island</option><option value='42'>South Carolina</option><option value='43'>South Dacota</option><option value='44'>Tennessee</option><option value='45'>Texas</option><option value='46'>Utah</option><option value='47'>Vermont</option><option value='48'>Virginia</option><option value='49'>Washington</option><option value='50'>West Virginia</option><option value='51'>Wisconsin</option><option value='52'> Wyoming</option></select></td></tr><tr style='height:30px !important'><td><label style='float:left;' for='HCCity'>City</label></td><td style='text-align:right;'><input id='HCCity' style='float:right;width:151px !important;font-size:10pt !important;' type='text'disabled ></td></tr><tr style='height:30px !important'><td><label style='float:left' for='HCZip'>Zip</label></td><td style='text-align:right;'><input id='HCZip' style='float:right;width:151px !important;font-size:10pt !important;' type='text'disabled ></td></tr></table></fieldset><fieldset><legend style='text-align:left'>Store location</legend><table style='width:250px;border:solid 0px; text-align:left;padding:0;margin:0;'><tr style='height:30px !important'><td><label style='float:left' for='HSState'>State</label></td><td style='text-align:right;'><select id='HSState' style='width:155px !important;font-size:10pt !important;border:solid 1px #999;padding:1px;margin:0;float:right;color:#595858;'><option value='0' selected>please select</option><option value='1'>Alabama</option><option value='2'>Alaska</option><option value='3'>Arizona</option><option value='4'>Arkansas</option><option value='5'>California</option><option value='6'>Colorado</option><option value='7'>Connecticut</option><option value='8'>Delaware</option><option value='9'>District of Columbia</option><option value='10'>Florida</option><option value='11'>Georgia</option><option value='12'>Hawaii</option><option value='13'>Idaho</option><option value='4'>Illinois</option>	<option value='15'>Indiana</option>	<option value='16'>Iowa</option><option value='17'>Kansas</option><option value='18'>Kentucky</option><option value='19'>Louisiana</option><option value='20'>Maine</option><option value='21'>Matyland</option><option value='22'>Massachusetts</option><option value='23'>Michigan</option><option value='24'>Minnesota</option><option value='25'>Mississippi</option><option value='26'>Missouri</option><option value='27'>Montana</option><option value='28'>Nebraska</option><option value='29'>Nevada</option><option value='30'>New Hampshire</option><option value='31'>New Jersey</option><option value='32'>New Mexico</option><option value='33'>New York</option><option value='34'>North Carolina</option><option value='35'>North Dacota</option><option value='36'>Ohio</option><option value='37'>Oklahoma</option><option value='38'>Oregon</option><option value='39'>Pennsylvania</option><option value='40'>Puerto Rico</option><option value='41'>Rhode Island</option><option value='42'>South Carolina</option><option value='43'>South Dacota</option><option value='44'>Tennessee</option><option value='45'>Texas</option><option value='46'>Utah</option><option value='47'>Vermont</option><option value='48'>Virginia</option><option value='49'>Washington</option><option value='50'>West Virginia</option><option value='51'>Wisconsin</option><option value='52'> Wyoming</option></select></td></tr><tr style='height:30px !important'><td><label style='float:left;' for='HSCity'>City</label></td><td style='text-align:right;'><input id='HSCity' style='float:right;width:151px !important;font-size:10pt !important;' type='text'></td></tr><tr style='height:30px !important'><td><label style='float:left' for='HSZip'>Zip</label></td><td style='text-align:right;'><input id='HSZip' style='float:right;width:151px !important;font-size:10pt !important;' type='text' ></td></tr></table></fieldset><input type='image' style='border:0px !important;padding:0;margin:0;float:right' src='"+knackLocation+"cancel.png' onClick='knackHideTaxForm()'><input style='border:0px !important;padding:0;margin:0;float:right' type='image' src='"+knackLocation+"calculate.png' onClick='knackCalculateTax()'></div></div><div id='knack_add_result'><div style='padding: 130px 0pt 0pt; height: 100px;'><span id='knack-add-result'>Item is successfully added, Please check your <a style='text-decoration:underline;cursor:pointer;color: #6599CB;' onclick='gotoRegistry();'>registry</a></span></div><br/></div><div id='knack-wait-wrapper' style='filter:alpha(opacity=50); -moz-opacity:.50; opacity:.50;'><div id='knack-wait-container' style=''><img alt='' src='"+knackLocation+"wait.gif' /></div></div>";
	
	 
	document.body.appendChild(newD);
}

function createKnackLoginWindow(){
    var newD = document.createElement('div');
    newD.setAttribute('id','knackLoginWindow');
    newD.className = 'knack-wraper';

	function knackGetClientWidth()
	{
		return document.compatMode=='CSS1Compat' && !window.opera?document.documentElement.clientWidth:document.body.clientWidth;
	}

    var kn_left = knackGetClientWidth()/2 - 150;
    newD.style.position = 'absolute';
    newD.style.height = '200px';
    newD.style.width ='300px';
    newD.style.left= kn_left+'px';
    newD.style.top = '230px';

    newD.style.zIndex = '66666';
    //newD.style.visibility = 'hidden';
    newD.style.background = '#FFFFFF';
    newD.style.border = '1px solid #666';


    newD.innerHTML = "<div id='knack-header-login'><div class='div-knack-header-login'><span id='knack-ht'>Login</span></div><a href='javascript:void(0)' onClick='exitKnackLogin();' ><img class='knack-close' src='/images/design/close/btn_close_x.png'/></a></div><div id='knack-content-wraper-login'><div class='knack-div-block'><div class='knack-editor-label'>Login(Email)</div><div class='knack-editor-field'><input type='text' id='knackEmail'/></div></div><div class='knack-div-block'><div class='knack-editor-label'>Password</div><div class='knack-editor-field'><input type='password' id='knackPass'/></div></div><div class='knack-div-block'><div class='knack-editor-label'><div class='knack-not-register'>Not registered on Knack?</div><a class='knack-link-registration' href='javascript:void(0);' onclick='knackOpenRegistration();'>Sign Up Today!</a></div><div class='knack-editor-field' style='text-align: right'><input type='button' onclick='knackLogin();' id='knackBtnLogin' value=' '/></div></div></div>";
	document.body.appendChild(newD);
}

function createKnackRegisterWindow(){
    var newD = document.createElement('div');
    newD.setAttribute('id','knackRegisterWindow');
    newD.className = 'knack-wraper';

	function knackGetClientWidth()
	{
		return document.compatMode=='CSS1Compat' && !window.opera?document.documentElement.clientWidth:document.body.clientWidth;
	}

    var kn_left = knackGetClientWidth()/2 - 200;
    newD.style.position = 'absolute';
    newD.style.height = '450px';
    newD.style.width ='400px';
    newD.style.left= kn_left+'px';
    newD.style.top = '105px';

    newD.style.zIndex = '99999';
    //newD.style.visibility = 'hidden';
    newD.style.background = '#FFFFFF';
    newD.style.border = '1px solid #666';


    newD.innerHTML = "<div id='knack-header-register'><div class='div-knack-header-register'><span id='knack-ht'>Registration</span></div><a href='javascript:void(0)' onClick='exitKnackRegister();' ><img class='knack-close' src='/images/design/close/btn_close_x.png'/></a></div><div  id='knack-content-wraper-register'><div class='knack-div-block'><div class='knack-editor-label'>First Name*</div><div class='knack-editor-field'><input type='text' id='knackFirstName'/></div></div><div class='knack-div-block'><div class='knack-editor-label'>Last Name*</div><div class='knack-editor-field'><input type='text' id='knackLastName'/></div></div><div class='knack-div-block'><div class='knack-editor-label'>Email*</div><div class='knack-editor-field'><input type='text' id='knackRegEmail'/></div></div><div class='knack-div-block'><div class='knack-editor-label'>Password*</div><div class='knack-editor-field'><input type='password' id='knackRegPass'/></div></div><div class='knack-div-block'><div class='knack-editor-label'>Confirm Password*</div><div class='knack-editor-field'><input type='password' id='knackConfPass'/></div></div><div class='knack-div-block'><div class='knack-editor-label'>City*</div><div class='knack-editor-field'><input type='text' id='knackCity'/></div></div><div class='knack-div-block'><div class='knack-editor-label'>State*</div><div class='knack-editor-field'><select id='knackState'><option value='0' selected>please select</option><option value='1'>Alabama</option><option value='2'>Alaska</option><option value='3'>Arizona</option><option value='4'>Arkansas</option><option value='5'>California</option><option value='6'>Colorado</option><option value='7'>Connecticut</option><option value='8'>Delaware</option><option value='9'>District of Columbia</option><option value='10'>Florida</option><option value='11'>Georgia</option><option value='12'>Hawaii</option><option value='13'>Idaho</option><option value='4'>Illinois</option>	<option value='15'>Indiana</option>	<option value='16'>Iowa</option><option value='17'>Kansas</option><option value='18'>Kentucky</option><option value='19'>Louisiana</option><option value='20'>Maine</option><option value='21'>Matyland</option><option value='22'>Massachusetts</option><option value='23'>Michigan</option><option value='24'>Minnesota</option><option value='25'>Mississippi</option><option value='26'>Missouri</option><option value='27'>Montana</option><option value='28'>Nebraska</option><option value='29'>Nevada</option><option value='30'>New Hampshire</option><option value='31'>New Jersey</option><option value='32'>New Mexico</option><option value='33'>New York</option><option value='34'>North Carolina</option><option value='35'>North Dacota</option><option value='36'>Ohio</option><option value='37'>Oklahoma</option><option value='38'>Oregon</option><option value='39'>Pennsylvania</option><option value='40'>Puerto Rico</option><option value='41'>Rhode Island</option><option value='42'>South Carolina</option><option value='43'>South Dacota</option><option value='44'>Tennessee</option><option value='45'>Texas</option><option value='46'>Utah</option><option value='47'>Vermont</option><option value='48'>Virginia</option><option value='49'>Washington</option><option value='50'>West Virginia</option><option value='51'>Wisconsin</option><option value='52'> Wyoming</option></select></div></div><div class='knack-div-block'><div class='knack-editor-label'>ZIP*</div><div class='knack-editor-field'><input type='text' id='knackZIP'/></div></div><div id='knack-div-accept'><input type='checkbox' id='knackAgree'/> <span>I accept the </span> <a target='_blank' href='https://knackregistry.com/info/policy'><span class='sitePolicyHref'>Knackregistry.com's website policy</span></a></div><div class='knack-div-block'><div class='knack-editor-label'><div style='visibility: hidden'>.</div></div><div class='knack-editor-field' style='text-align: right'><input type='button' onclick='knackRegister();' id='knackBtnRegister' value=' '/></div></div></div>";
	document.body.appendChild(newD);
}