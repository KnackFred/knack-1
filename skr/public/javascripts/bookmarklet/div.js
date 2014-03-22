
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
    newD.style.height = '335px';
    newD.style.width ='550px';
    newD.style.left= kn_left+'px';
    newD.style.top = '150px';
	
    newD.style.zIndex = '99999';
	newD.style.visibility = 'hidden';
	newD.style.background = '#FFFFFF';
	newD.style.border = '1px solid #666';

    newD.innerHTML = "<div id='knack-header' >     <a id='knack-help' target='_blank' href='"+knack_host+"info/helppage#ref81' info/helppage#ref81'>help</a>     <span id='ht'>Add Item to your Knack Registry Gift List</span>     <a id='knack-close' href='javascript:void(0)' onClick='exitKnack();' >close</a> </div> <div  id='knack-content-wraper' style='padding: 10px 40px 0 10px;'>     <div id='image-side'style='height:200px; width: 250px; margin: 0; padding: 0;'>         <div id='image' style='width:240px;height:180px;border:solid 0px #ddd;text-align:center;overflow:hidden'>             <img src='"+knackLocation+"noimage.png'  id='pic0'style='max-width:240px;max-height:180px;border:solid 0px #ddd'>         </div>         <div id='img-navi' style='width: 240px;'>             <span class='knack-prev' onClick='prevImage();' style='cursor:pointer;'>&#60;</span>             <span id='image-number' >No image</span>             <span style='cursor:pointer;'class='knack-next' onClick='nextImage();'>&#62;</span>         </div>     </div>     <div id='input-side' style='float:left;width:240px;height:200px;margin:0;border:solid 1px #fff !important;'>         <div id='knack-input-form'>             <table id='knack-table' style='border:solid 1px #fff !important;padding:0;margin:0;'>                 <tr style='border:solid 1px #fff !important; min-height:0 !important;height:10px !important; vertical-align:bottom !important;padding:0;margin:0;'>                     <td colspan='2'style='vertical-align:bottom;padding:0;margin:0;' >                         <label for='HName' style='margin:0;padding:0;'>Product Name</label>                     </td>                 </tr>                 <tr style='height:10px;padding:0;margin:0;vertical-align:top;'>                     <td colspan='2' style='border:solid 0;padding:0;margin:0;'>                         <input  type='text' style='width:236px !important;margin:0 !important;'  id='HName' >                     </td>                 </tr>                 <tr style='border:solid 1px #fff !important;height:10px;vertical-align:bottom;padding:0;margin:0;'>                     <td style='vertical-align:bottom;padding:0;margin:0;'>                         <label for='HPrice'>Price</label>                     </td>                     <td style='vertical-align:bottom;padding:0;margin:0;padding-left:10px;'>                         <label for='HQuantity'>Quantity</label>                     </td>                 </tr>                 <tr style='height:10px;padding:0;margin:0;vertical-align:top;'>                     <td style='padding:0;margin:0;vertical-align:top;'>                         <input type='text' style='width:111px !important;'  id='HPrice'>                     </td>                     <td style='padding:0;margin:0;padding-left:10px;vertical-align:top'>                         <input type='text'style='width:111px !important;' id='HQuantity' value='1'>                     </td>                 </tr>                 <tr style='border:solid 1px #fff !important;height:10px;vertical-align:bottom;padding:0;margin:0;'>                     <td style='vertical-align:bottom;padding:0;margin:0;'>                         <label for='HColor'>Color/Style</label>                     </td>                     <td style='vertical-align:bottom;padding:0;margin:0;padding-left:10px;'>                         <label for='HSize'>Size</label>                     </td>                 </tr>                 <tr style='height:10px;padding:0;margin:0;vertical-align:top;'>                     <td style='padding:0;margin:0;vertical-align:top;'>                         <input type='text' style='width:111px !important;'  id='HColor'>                     </td>                     <td style='padding:0;margin:0;padding-left:10px;vertical-align:top'>                         <input type='text'style='width:111px !important;' id='HSize'>                     </td>                 </tr>                  <tr style='border:solid 1px #fff !important; min-height:0 !important;height:10px !important; vertical-align:bottom !important;padding:0;margin:0;'>                     <td colspan='2'style='vertical-align:bottom;padding:0;margin:0;' >                         <label for='HOther' style='margin:0;padding:0;'>Other Instructions</label>                     </td>                 </tr>                 <tr style='height:10px;padding:0;margin:0;vertical-align:top;'>                     <td colspan='2' style='border:solid 0;padding:0;margin:0;'>                         <input  type='text' style='width:236px !important;margin:0 !important;'  id='HOther' >                     </td>                 </tr>                 <tr style='border:solid 1px #fff !important; min-height:0 !important;height:10px !important; vertical-align:bottom !important;padding:0;margin:0;'>                     <td colspan='2'style='vertical-align:bottom;padding:0;margin:0;' >                         <label for='HSection' style='margin:0;padding:0;'>Section</label>                     </td>                 </tr>                 <tr style='height:10px;padding:0;margin:0;vertical-align:top;'>                     <td colspan='2' style='border:solid 0;padding:0;margin:0;'>                         <select style='width:240px !important;margin:0 !important;'  id='HSection' >                             <option value='0'>Default Section</option>                         </select>                     </td>                 </tr>             </table>         </div>     </div>      <div id='knack-more' style='clear:both; text-align: left; padding-top: 4px;'>         <label for='HComment' style='padding:0;margin:0;display:block;clear:both;font-size:10pt;color:#6698CB;font-weight:bold;text-align: left;'>Description             <span style='color:#595858;font-weight:normal;'>(up to 900 characters)</span>         </label>         <textarea id='HComment' style='width:488px !important;height:35px !important; display:block;'></textarea>         <input type='image' src='"+knackLocation+"add.png' onClick='knackAddToRegistry();' style='border:0px !important;padding:0;margin:6px 0 0 0;float:right;display:block;'>     </div>     <div id='knack-footer' style='clear:both; text-align: left; display: none;'>         <span style='font-family: Arial, sans-serif; font-size: 10pt; color: #6698CB; font-weight: bold; background: white; padding: 0;'>Suggestions From Our Catalog</span>         <div id='KnackSuggestions' style='padding: 10px 0;'>         </div>         <div class='KnackProductTemplate' style='display: none; float: left; width: 102px; padding: 0 8px; vertical-align: top;'>             <a target='_blank' >                 <div style='border: 1px solid #CCC; width: 99.6px; height: 75px; text-align: center; padding: 0; margin: 0'>                     <img  alt='product.Name' style='max-width: 99.6px; max-height: 75px; border:solid 0;'/>                 </div>                 <div>                     <div class='KnackName' style='font-family: Arial, sans-serif; font-size: 7.5pt; color: #595858; background: white; padding: 0; margin: 0'></div>                     <div class='KnackPrice' style='font-family: Arial, sans-serif; font-size: 7pt; color: #595858; background: white; padding: 0; margin: 0'></div>                 </div>             </a>         </div>     </div> </div> <div id='knack_add_result'>     <span id='knack-add-result'>Item is successfully added, Please check your registry</span>     <br/>     <span style='padding:250px 52px 0 0;float:right;cursor:pointer;font-size:10pt;color:#595858;' onClick='knackHideResult();'>add another gift</span> </div> <div id='knack-wait-wrapper' style='filter:alpha(opacity=50); -moz-opacity:.50; opacity:.50;'>     <div id='knack-wait-container' style=''><img alt='' src='"+knackLocation+"wait.gif' />     </div> </div>";


    document.body.appendChild(newD);
}


	