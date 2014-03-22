jQuery(function(){

    var tree;

     /**********************************************
     * POP UP CATEGORY
     *********************************************/
    jQuery('#category_parent_name').bind('click', function(event){
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
        url: "/administrative/gettreecategories",
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
	                    url: "/administrative/getnamecategory",
	                    type: "GET",
	                    data: {id : cat_id},
	                    async: false,
	                    complete: function(param)
	                    {
	                        jQuery('#category_parent_name').val(param.responseText);
	                        jQuery('#category_parent_id').val(cat_id);
	                    }
	                  });
	            }
		}
		else{
			jQuery('#category_parent_name').val('');
            jQuery('#category_Parent_ID').val('');
		}
		jQuery.modal.close();
    });

    jQuery('#cancel').click(function(){
        document.location.assign('/administrative/categorylist');
    });

    jQuery('#save').click(function(){
        jQuery('#form-category').submit();
    });

});

function click_check()
{
    alert(1);
}