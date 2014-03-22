function Param()
{
    this.id = '';
    this.name = '';
    this.values = '';
    this.template = '';
}

function TemplateParam()
{
    this.id = '';
    this.name = '';
    this.values = '';
    this.product_id = '';
    this.partner_id = '';
}

jQuery(function(){

    jQuery('#jquery-colour-picker-example select').colourPicker({
        ico:    '/images/color/jquery.colourPicker.gif',
        title:    false
    });

    $('#save').click(function(){
			//params
			var param = jQuery('#t-param tbody tr');
			var params = new Array();

			for(i = 0; i < param.length - 1; i++){
				var par = jQuery(param[i]);
				var obj = new Param();
				obj.id = $.trim(jQuery(par).attr('dataid'));
				obj.template = $.trim(jQuery(par).attr('template'));
				obj.name = $.trim(jQuery(par[0].cells[0]).text());
				obj.values = $.trim(jQuery(par[0].cells[1]).text());

				params.push(obj);
			}
			var json = JSON.stringify(params, replacer);

			jQuery('#list_params').val(json);
			$('form.edit_product').submit();
			$('form.new_product').submit();
    });

    new_attachment_template = $('.attachment-template').remove().removeClass("attachment-template");
    $('#add-new-attachment').click(function(event){
        event.preventDefault();
        var new_id = new Date().getTime();
        var regexp = new RegExp("\\Sproduct_attachments_attributes\\S\\S\d*\\S", "g")

        var new_attachment = new_attachment_template.html().replace(regexp, "[product_attachments_attributes]["+new_id+"]")
        $(new_attachment).appendTo("#attachment-list");
    });

    new_image_template = $('.image-template').remove().removeClass("image-template");;
    $('#add-new-image').click(function(event){
        event.preventDefault();

        var new_id = new Date().getTime();
        var regexp = new RegExp("\\Sproduct_images_attributes\\S\\S\d*\\S", "g")

        var new_image = new_image_template.html().replace(regexp, "[product_images_attributes]["+new_id+"]")
        $(new_image).appendTo("#image-list");
    });

    var tree;

    //* POP UP CATEGORY
    jQuery('#add-cat').bind('click', function(event){
        event.preventDefault();
        jQuery('#cat-iframe').modal({
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

        var csv;

        $.ajax({
            url: controller+"/gettreecategories",
            type: "GET",
            complete: function(param){
                csv = param.responseText;
                tree.loadCSVString(csv);

                //categories
                var category = jQuery('#t-category tr');
                var id_categories = "";

                for(i = 0; i < category.length - 1; i++){
                    var cat = jQuery(category[i]).attr('dataid');
                    if (cat != undefined){
                        id_categories = $.trim(cat);
                        tree.setCheck(id_categories, true);
                        tree.disableCheckbox(id_categories, true);
                    }
                }
            }
        });
    });

    $('#btn-add-cat').click(function(){
        if (tree.getAllChecked() != ""){
            var checked = tree.getAllChecked().split(',');

            for(i=0;i<checked.length;i++){
                cat_id = checked[i];
                var text = tree.getItemText(cat_id);
                add_line(cat_id, text, 'delete-cat', 'tr-add');
            }
            $('#product_category_ids').val(checked.concat($('#product_category_ids').val()));
        }
        $.modal.close();
    });

    $('#t-category').delegate('.delete-cat', 'click', function(event){
        var id = $(this).attr('dataid');
        $('#t-category-add tr[dataid='+$.trim(id) + ']').removeClass('tag-none');
        $('#t-category tr[dataid='+$.trim(id) + ']').remove();
        var cat_ids = $('#product_category_ids').val();
        cat_ids.splice(cat_ids.indexOf(id), 1)
        $('#product_category_ids').val(cat_ids);
        event.preventDefault();
    });


////////// end categories block
////////// colors block
    $('#t-color').delegate('.delete-color', 'click', function(event){
        var id = $.trim(jQuery(this).attr('dataid'));
        jQuery('#t-color tr[dataid='+id + ']').remove();

        var color_ids = $('#product_color_ids').val();
        color_ids.splice(color_ids.indexOf(id), 1)
        $('#product_color_ids').val(color_ids);
        event.preventDefault();
    });

////////// end colors block

    // * POP UP STORES
    jQuery('#add-store').bind('click', function(event){
        event.preventDefault();
        jQuery('#store-iframe').modal({
            overlayClose:true,
            minHeight:400,
            minWidth: 500,
            close: true
        });

        tree = new dhtmlXTreeObject("treeboxbox_tree_store", "100%", "100%", 0);

        tree.setImagePath("/javascripts/tree/codebase/imgs/csh_vista/");
        tree.enableDragAndDrop(true);
        tree.enableCheckBoxes(1);
        tree.enableTreeImages("false");

        var csv;
        $.ajax({
            url: controller+"/getstores",
            type: "GET",
            complete: function(param){
                csv = param.responseText;
                tree.loadCSVString(csv);

                //colors
                var store = jQuery('#t-store tr');
                var id_stores = "";

                for(i = 0; i < store.length - 1; i++){
                    var cat = jQuery(store[i]).attr('dataid');
                    if (cat != undefined){
                        id_stores = $.trim(cat);
                        tree.setCheck(id_stores, true);
                        tree.disableCheckbox(id_stores, true);
                    }
                }
            }
        });
    });

    jQuery('#btn-add-store').click(function(){
        if (tree.getAllChecked() != ""){
            var checked = tree.getAllChecked().split(',');
            for(i=0;i<checked.length;i++){
                store_id = checked[i];
                if(store_id == ''){
                    continue;
                }
                var text = tree.getItemText(store_id);
                add_line(store_id, text, 'delete-store', 'tr-add-store');
            }
            $('#product_store_ids').val(checked.concat($('#product_store_ids').val()));
        }
        $.modal.close();
    });

    $('#t-store').delegate('.delete-store', 'click', function(event){
        var id = $.trim(jQuery(this).attr('dataid'));
        jQuery('#t-store tr[dataid='+id + ']').remove();
        $().remove();
        var store_ids = $('#product_store_ids').val();
        store_ids.splice(store_ids.indexOf(id), 1)
        $('#product_store_ids').val(store_ids);
        event.preventDefault();
    });



////////// params block
		event_delete_param();
		event_delete_value();

    jQuery('#add-param').bind('click', function(event){
			event.preventDefault();

			$.ajax({
				url: controller+"/gettemplatelist",
				type: "GET",
				async: false,
				complete: function(param){
					var a = jQuery.parseJSON(param.responseText);
					jQuery('#product_templates option').remove();
					jQuery('#product_templates').append($("<option></option>").attr("value",'').text('Empty'));

					for(i = 1; i < a.length; i++){
						jQuery('#product_templates').append($("<option></option>").attr("value",a[i].product_param.id).text(a[i].product_param.Name));
					}
				}
			});

			popup_param();
    });

    jQuery('#add-value').bind('click', function(event){
			event.preventDefault();
			var div = jQuery('#value-param').clone();
			div.removeClass('display-none');
			div.removeAttr('id');
			div.insertBefore('.add-param');

			event_delete_value();
		});

		jQuery('#t-param tbody tr').live('click', function(){
			popup_param();

			var param = jQuery(this);
			var id = $.trim(jQuery(param).attr('dataid'));
			var template = $.trim(jQuery(param).attr('template')) == 'true' ? true : false;
			var name = $.trim(jQuery(param[0].cells[0]).text());
			var values = $.trim(jQuery(param[0].cells[1]).text()).split(',');

			jQuery('#param-is-edit').val('1');
			jQuery('#use-template').attr('checked', template);
			jQuery('#param-id').val(id);
			jQuery('#param-name').val(name);
			jQuery('.value-param').val(values[0]);
			for(i = 1; i < values.length; i++){
				var div = jQuery('#value-param').clone();
				div.removeClass('display-none');
				div.removeAttr('id');
				div.insertBefore('.add-param');
				div.find('.value-param').val(values[i]);
			}

			event_delete_value();
		});

    jQuery('#product_templates').live('change',function(){
        var t_id = jQuery(this).val();
        if(t_id == '')
        {
            jQuery('.link-delete').remove();
            return;
        }

        jQuery('.link-delete').remove();
        jQuery('<a href="#" class="link-delete" dataid="'+ t_id + '">Delete</a>').appendTo('.delete-template');
        
        jQuery('.link-delete').click(function(event){
            event.preventDefault();
            var tmp_id = jQuery(this).attr('dataid');
            $.ajax({
                    url: controller+"/delete_template",
                    type: "POST",
                    data: {id : tmp_id},
                    async: false,
                    complete: function(param)
                    {
                    }
                  });
            jQuery('#product_templates option[value=' + tmp_id + ']').remove();
            jQuery('.link-delete').remove();
        });
        $.ajax({
            url: controller+"/gettemplate",
            type: "GET",
            data: {id : t_id},
            async: false,
            complete: function(param)
            {
                var a = jQuery.parseJSON(param.responseText).product_param;
                jQuery('#param-name').val(a.Name);
                $.ajax({
                    url: controller+"/getvalues",
                    type: "GET",
                    data: {id : t_id},
                    async: false,
                    complete: function(param)
                    {
                        var b = jQuery.parseJSON(param.responseText);
                        var value_param = jQuery('.value-param');

                        for(i = 1; i < value_param.length - 1; i++)
                        {
                            jQuery(value_param[i]).closest('.div-block').remove();
                        }

                        jQuery('.value-param').first().val(b[0].value_param.Value);
                        for(i = 1; i < b.length; i++)
                        {
                            var div = jQuery('#value-param').clone();
                            div.removeClass('display-none');
                            div.removeAttr('id');
                            div.insertBefore('.add-param');
                            div.find('.value-param').val(b[i].value_param.Value);
                        }

                        jQuery('.delete-value').click(function(event){
                            event.preventDefault();
                            jQuery(this).closest('.div-block').remove();
                        });
                    }
                  });
            }
          });
    });

    jQuery('#t-param tbody tr').hover(function(){
        jQuery(this).addClass('select-edit');
    }, function(){
        jQuery(this).removeClass('select-edit');
    });

		jQuery('#use-template').click(function(){
			var product_id = jQuery('#product-id').val();
			var template = jQuery(this).attr('checked');
			if(product_id == ''){
				if(template){
					jQuery('.text-template').text('Variant is stored when this product is stored');
				}
				else{
					jQuery('.text-template').text('');
				}
			}
		});
		
    jQuery('#btn-add-param').click(function(){

        var name = jQuery('#param-name').val();
        var values_obj = jQuery('.value-param');
        var values = '';
        var id = jQuery('#param-id').val();
        var template = jQuery('#use-template').attr('checked');
        var product_id = jQuery('#product-id').val();
        var partner_id = jQuery('#partner-id').val();

        if(jQuery('#param-is-edit').val() == '1')
        {
            jQuery('#t-param tr[dataid='+id + ']').remove();
        }

        var last = values_obj.length - 2;
        for(i=0;i < values_obj.length - 1;i++)
            {
                values += jQuery(values_obj[i]).val();
                if (i < last)
                    {
                        values += ',';
                    }

            }

        if(product_id != '' && template)
            {
                var template_param = new TemplateParam();
                template_param.id = id;
                template_param.name = name;
                template_param.partner_id = partner_id;
                template_param.product_id = product_id;
                template_param.values = values;

                 $.ajax({
                    url: controller+"/save_template",
                    type: "POST",
                    data: {template : template_param},
                    async: false,
                    complete: function(param)
                    {
                        if(param.responseText == '0')
                            alert('Invalid data');
                        else
                            {
                                jQuery.modal.close();
                                jQuery('#param-id').val(param.responseText);
                                jQuery('#product_templates').append($("<option></option>").attr("value",param.responseText).text(name));
                            }
                    }
                  });
            }
            else
                {
                    jQuery.modal.close();
                }

        
        var tr = '<tr dataid="'+ id +'"'+
        'template="'+ template +'">'+
                            '<td>'+
                              name +
                            '</td>'+
                            '<td>'+
                              values +
                            '</td>'+
                            '<td>'+
                              '<a dataid="'+ id +'" class="delete-param" href="/">Delete</a>'+
                            '</td>'+
                          '</tr>';
        jQuery('#tr-add-param').before(tr);
        jQuery('.delete-param').bind('click', function(event){
            var id = $.trim(jQuery(this).attr('dataid'));
            jQuery('#t-param tr[dataid='+id + ']').remove();
           event.preventDefault();
        });

        jQuery('#t-param tbody tr').hover(function(){
            jQuery(this).addClass('select-edit');
        }, function(){
            jQuery(this).removeClass('select-edit');
        });
    });
});


function popup_param(){
	jQuery('#param-iframe').modal({
		overlayClose:true,
		minHeight:400,
		minWidth: 500,
		close: true
	});
}

function deleteImage(event, obj){
	var id= $.trim(jQuery(obj).attr('imgid'));
	delete_hidden('list_images', id);
	jQuery('#'+id).remove();

	event.preventDefault();
}

function replacer(key, value) {
    if (typeof value === 'number' && !isFinite(value)) {
        return String(value);
    }
    return value;
}

function create_hidden(name, value){
	 var hidden = '<input type="hidden" name="product['+name+'][]" value="'+value+'"/>';
	 $('.hidden_container').append(hidden);
}

function delete_hidden(name, value){
	$('input[name="product['+name+'][]"][value="'+value+'"]').remove();
}

function event_delete_value(){
	jQuery('.delete-value').click(function(event){
		event.preventDefault();
		jQuery(this).closest('.div-block').remove();
	});
}

function event_delete_param(){
	jQuery('.delete-param').bind('click', function(event){
		var id = $.trim(jQuery(this).attr('dataid'));
		jQuery('#t-param tr[dataid='+id + ']').remove();
		event.preventDefault();
  });
}

function add_line(dataid, text, delete_class, block){
	var tr = '<tr dataid="'+ dataid +'">'+
      '<td>'+
        text +
      '</td>'+
      '<td>'+
        '<a dataid="'+ dataid +'" class="'+delete_class+'" href="/">Delete</a>'+
      '</td>'+
    '</tr>';
  jQuery('#'+block).before(tr);
}

