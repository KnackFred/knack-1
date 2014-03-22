jQuery(function(){
    jQuery('.active-link').click(function(event){
      event.preventDefault();
      var id = jQuery(this).attr('dataid');
      var link = jQuery(this);
      $.ajax({
         type: 'POST',
         async: false,
         url: "/administrative/activeregistries",
         data: {id: id},
         success: function(param){
             link.text(param);
         }
      });
  });
});

