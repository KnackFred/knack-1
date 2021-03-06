/**
 * Decimal Mask Plugin
 * 
 * @version 1.1.1
 * 
 * @licensed MIT License Copyright (c) 2010 St?fano Stypulkowski <http://www.icewares.com.br/license/MIT.txt>
 * @licensed GPL LIcense Copyright (c) 2010 St?fano Stypulkowski <http://www.icewares.com.br/license/GPL.txt>
 * 
 * @requires jQuery 1.4.x
 * @requires jQuery.caret.1.02.min.js
 * 
 * @author St?fano Stypulkowski
 */
(function(a){a.fn.decimalMask=function(e){var c={separator:",",decSize:4,intSize:8};c=a.extend(c,e);var d;
if([",","."].indexOf(c.separator.substring(0,1))===-1){d=","}else{d=c.separator.substring(0,1)}var g=c.intSize;
var b=c.decSize;var h=function(){var m=false;for(var k=1,j=arguments.length;k<j;k++){if(arguments[0]===arguments[k]){m=true;
break}}return m};a(this).each(function(){a(this).attr("maxlength",(g+b+1));var j=a(this).val().replace(".",d);
if(j.indexOf(d)===0){j="0"+value}a(this).val(j)});var i=function(m){var n=a(this).val();var p="";var q=n.indexOf(d)>-1?true:false;
for(var k=0,j=n.length;k<j;k++){if(n.substring(k,k+1).match("[0-9,"+d+"]")){if(n.substring(k,k+1)===d&&p.indexOf(d)===-1){p=p+n.substring(k,k+1)
}if(n.substring(k,k+1)!==d){p=p+n.substring(k,k+1)}}}var o=p.split(d);if(o[0].length>g){if(o[1]===undefined&&!q){q=true;
o[1]=o[0].substring(g,o[0].length)}o[0]=o[0].substring(0,g)}if(o[1]!==undefined&&o[1].length>b){o[1]=o[1].substring(0,b)
}a(this).val((o[0]===undefined?"":o[0])+(q?d:"")+(o[1]===undefined?"":o[1]))};var f=function(l){var j=l.keyCode;
if(l.shiftKey||l.ctrlKey||l.altKey){return true}if(h(j,35,36,9)){return true}if(h(j,37,38,39,40)){return true
}if(j===46){var m=a(this).val();if(a(this).caret().start===a(this).val().indexOf(d)&&a(this).caret().start==a(this).caret().end&&m.length>1&&m.indexOf(d)>0&&m.indexOf(d)+1<m.length){return false
}if(m.indexOf(d)>=a(this).caret().start&&m.indexOf(d)<a(this).caret().end){a(this).val(m.substring(0,a(this).caret().start)+d+m.substring(a(this).caret().end,m.length));
if(a(this).val().length===1){a(this).val("")}return false}return true}if(j===8){var m=a(this).val();if(a(this).caret().start===m.indexOf(d)+1&&a(this).caret().start===a(this).caret().end&&m.length>1&&m.indexOf(d)>0&&m.indexOf(d)+1<m.length){return false
}if(m.indexOf(d)>=a(this).caret().start&&m.indexOf(d)<a(this).caret().end){a(this).val(m.substring(0,a(this).caret().start)+d+m.substring(a(this).caret().end,m.length));
if(a(this).val().length===1){a(this).val("")}return false}return true}if(h(j,110,188)){if(d==="."){return false
}if(d===","&&a(this).val().indexOf(",")!==-1){return false}return true}if(h(j,190,194)){if(d===","){return false
}if(d==="."&&a(this).val().indexOf(".")!==-1){return false}return true}if((j>=96&&j<=105)||(j>=48&&j<=57)){if(a(this).val().length>(g+b+1)){return false
}var o=a(this).val();var n=o.split(d);if(h(j,48,96)&&a(this).caret().start===0&&o.length>0){return false
}if(a(this).caret().start===a(this).caret().end){if(a(this).caret().start>o.indexOf(d)&&o.indexOf(d)>-1&&n[1].length>=b){return false
}if((a(this).caret().start<=o.indexOf(d)||o.indexOf(d)===-1)&&n[0].length>=g){return true}}else{if(a(this).caret().end-a(this).caret().start===o.length){return true
}if(a(this).caret().start<=o.indexOf(d)&&a(this).caret().end>o.indexOf(d)){return false}}return true}return false
};a(this).bind("input",i);a(this).bind("keydown",f)}})(jQuery);