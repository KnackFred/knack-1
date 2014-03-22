jQuery(function(){
   jQuery('#btn-captcha').click(function(){
      var guid = jQuery('#guid-captcha') .val();
      var text = jQuery('#captcha').val();
      var url = "http://captchator.com/captcha/check_answer/" + guid + "/" + text;
      var req;
      if(navigator.appName == "Microsoft Internet Explorer") {
              req = new ActiveXObject("Microsoft.XMLHTTP");
          } else {
              req = new XMLHttpRequest();
          }

      function handleHttpResponse() {
          if (req.readyState == 4) {
                 captchaOK = req.responseText;
                if(captchaOK != 1) {
                     alert('The entered code was not correct. Please try again');
                     return false;
                }
              alert("Captcha okie dokie");
           }
      }

      req.open("GET", url);
      req.onreadystatechange = handleHttpResponse();
//      $.ajax({
//         type: "GET",
//         async: false,
//         url: url,
//         success: function(param){
//             var a = param;
//             alert(a);
//         },
//         error: function(param){
//             alert(param);
//         }
//      });
   });
});

