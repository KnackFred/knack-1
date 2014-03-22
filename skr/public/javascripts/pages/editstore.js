jQuery(function(){

    var tree;

     /**********************************************
     * POP UP CATEGORY
     *********************************************/
    jQuery('#store_CategoryName').bind('click', function(event){
        event.preventDefault();
       jQuery('#cat-iframe').modal(
       {
           overlayClose:true,
           minHeight:400,
           minWidth: 500,
           close: true
       });

       tree = new dhtmlXTreeObject("treeboxbox_tree", "100%", "100%", 0);

        tree.setImagePath("/javascripts/tree/codebase/imgs/csh_vista/");
        tree.enableDragAndDrop(true);
        tree.enableCheckBoxes(1);
        tree.enableTreeImages("false");
        tree.attachEvent("onCheck", function(id, state){
            var checked = tree.getAllChecked().split(',');
            for(i = 0; i < checked.length; i++)
                {
                   tree.setCheck(checked[i],false);
                }
            tree.setCheck(id,true);
        });

       var csv;
      $.ajax({
        url: "/partner/gettreecategories",
        type: "GET",
        complete: function(param)
        {
            csv = param.responseText;
            tree.loadCSVString(csv);

            //categories
            var category = jQuery('#t-category tr');
            var id_categories = "";

            for(i = 0; i < category.length - 1; i++)
            {
                var cat = jQuery(category[i]).attr('dataid');
                if (cat != undefined)
                    {
                        id_categories = $.trim(cat);
                        tree.setCheck(id_categories, true);
                        tree.disableCheckbox(id_categories, true);
                    }
            }
        }
      });

    });

    jQuery('#btn-add-cat').click(function(){
        if (tree.getAllChecked() != ""){
	        var checked = tree.getAllChecked().split(',');

	        for(i=0;i<checked.length;i++)
	            {
	                cat_id = checked[i];
	                var text = '';
	                $.ajax({
	                    url: "/partner/getnamecategory",
	                    type: "GET",
	                    data: {id : cat_id},
	                    async: false,
	                    complete: function(param)
	                    {
	                        jQuery('#store_CategoryName').val(param.responseText);
	                        jQuery('#store_Category_ID').val(cat_id);
	                    }
	                  });
	            }
		}
        jQuery.modal.close();
    });

    //menu-active

    jQuery('#fupload').change(function(){
        jQuery('#imageupload').submit();
    });

    jQuery('#cat-wrapper').ajaxComplete(
        function() {
        jQuery('.image-up').attr('src','/images/upload/'+jQuery('#guid').val()+'.jpg?t='+ new Date());
    });

    jQuery('#del-image').bind('click', function(event){
        event.preventDefault();
        jQuery('#fupload').remove();
        jQuery('#bi').before('<input type="file" id="fupload" name="fupload" />');


        jQuery('#fupload').change(function(){
            jQuery('#imageupload').submit();
        });
        jQuery('#imageupload').submit();

    });

    jQuery('#imageupload').ajaxForm(function(param){
        if(param == 1)
            {
                jQuery('#errorPopup').modal(
                   {
                       overlayClose:true,
                       minHeight:100,
                       minWidth: 200,
                       close: true
                   });
                jQuery('#errorPopup').attr('src','/buy/errorpage/1');
            }
        else
            {
                var id = jQuery('#guid').val();
                jQuery('.image-up').attr('src','/images/upload/'+ id +'.jpg?t='+ new Date());
            }
    });

    jQuery('.btn-save').click(function(){
       jQuery('.wrap-image').unwrap();
       jQuery('.wrap-data').wrap('<form id="store_form" action="/partner/editstore" method="post"></form>');
       jQuery('#store_form').submit();
    });
});