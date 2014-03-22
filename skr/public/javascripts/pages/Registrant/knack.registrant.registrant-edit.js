$(function(){

    // Primary Nav Shading
    jQuery('#dm-receive').css('background', 'none repeat scroll 0 0 #f6d4d4');

    $("#help").tooltip({
        effect: 'slide',
        position: 'bottom left'
    });

  /**********************************************
     * Set Up On First Load
     *********************************************/

    $('input[placeholder], textarea[placeholder]').placeholder();


    $(".section").each(
        function ()
        {
            prepNewSection(this);

        });

    setSections();

    var warnMessage = "You haven't saved your changes, if you continue they will be lost!";

    $('input:not(:button,:submit),textarea,select').live('change', function () {
        window.onbeforeunload = function () {
            if (warnMessage != null) return warnMessage;
        }
    });
    $('input:submit').click(function() {
        warnMessage = null;
    });


    /**********************************************
     * Section Actions
     *********************************************/
    $('.add-section').live('click' , function(event){
        event.preventDefault();
        if ($('.section').size() < 10) {
            addSection(this);
        }
    });

    $('.move-section-up').live('click' , function(event){
        event.preventDefault();

        section = $(this).parents('.section');
        if (section.prevAll('.section').html() != null) {
            section.insertBefore(section.prevAll('.section').first());
            $.scrollTo(section, 800);
        }

        setSections();
    });

    $('.move-section-down').live('click' , function(event){
        event.preventDefault();
        section = $(this).parents('.section');
        if (section.nextAll('.section').html() != null) {
            section.insertAfter(section.nextAll('.section').first());
            $.scrollTo(section, 800);
        }

        setSections();
    });

    $('.delete-section').live('click' , function(event){
        event.preventDefault();
        if ($('.section').size() != 1) {
            section = $(this).parents('.section');
            var destSection = (section.prevAll('.section').html() != null)?section.prevAll('.section').first():section.nextAll('.section').first();
            if (destSection.html() != null) {
                (section).children('.section-items').children().each(
                    function (index, value)
                    {
                        destSection.children('.section-items').append(value);
                    });
                section.find('.destroy').val(true);
                section.hide();
                section.removeClass("section")

            }
            setSections();
            setGiftEntries(destSection);
        }
    });

    /**********************************************
     * Item Actions
     *********************************************/
    $('.move-item-up').live('click' , function(event){
        event.preventDefault();

        var item = $(this).parents('.gift-entry');
        var section = $(this).parents('.section');
        var dstSection = section.prev('.section');
        if (dstSection.html() != null) {
            dstSection.find('.section-items').append(item);
            setSections();
        }
    });

    $('.move-item-down').live('click' , function(event){
        event.preventDefault();

        var item = $(this).parents('.gift-entry');
        var section = $(this).parents('.section');
        var dstSection = section.next('.section');
        if (dstSection.html() != null) {
            dstSection.find('.section-items').prepend(item);
            setSections();
        }
    });

    /**********************************************
     * Change Image
     *********************************************/

    make_pop_up($('#change-picture'), 260, 100);
});

function reloadProfileImage(url) {
    $('.image').attr('src',url+'?t='+ new Date());

}

function closeModalWindowWCall(call, sucess, data) {
    $.modal.close();
    switch (call) {
        case "upload_image":
            setTimeout( function() {
                if(sucess)
                    pop_up(data, 420, 360);
                else
                    alert(data)
            }, 20);
            break;
        case "crop_image":
            if (sucess)
                reloadProfileImage(data);
            else
                alert(data);
            break;
        default:
            alert ("Error: Unknown Call");
    }
}


    function closeModalWindow(a, id)
{
    jQuery('iframe').attr('src','');
    $.modal.close();
    if(a == '1')
        {
            document.location.assign('/cart');
            return;
        }
    jQuery('input[r2pid="'+id+'"]').remove();
}

function prepNewSection(newSection){

    $(newSection).find('.section-description').autoResize({
        extraSpace: 0
    });

    $(newSection).find('.section-title').bind('change', function () {
        updateNavTitle($(this).parents('.section'));
    });

    $(newSection).find('input[placeholder], textarea[placeholder]').placeholder();

    $(newSection).find( ".section-items" ).sortable({
        connectWith: ".section-items",
        receive: function() {
            setGiftEntries($(this).parents('.section'))
        },
        remove: function() {
            setGiftEntries($(this).parents('.section'))
        },
        stop: function() {
            createNav();
            setGiftEntries($(this).parents('.section'))
        },
        placeholder: "gift-entry-highlight",
        scrollSensitivity: 60,
        forcePlaceholderSize: true,
        tolerance: "intersect"
    }).disableSelection();
}

function setSections(){
    /**********************************************
     * Set Section Buttons and reset ID's
     *********************************************/
    if ($('.section').size() == 1) {
        $(".section .delete-section").addClass("hidden-button");
    } else {
        $(".section .delete-section").removeClass("hidden-button");
    }

    if ($('.section').size() == 10) {
        $(".section .add-section").addClass("hidden-button");
    } else {
        $(".section .add-section").removeClass("hidden-button");
    }

//    $(".move").empty();

    $(".section").each(
        function (i)
        {
            $(this).find('.order').val(i);

            if ($(this).prevAll('.section').html() == null) {
                $(this).find('.move-section-up').addClass("hidden-button");
            } else {
                $(this).find('.move-section-up').removeClass("hidden-button");
            }
            if ($(this).nextAll('.section').html() == null) {
                $(this).find('.move-section-down').addClass("hidden-button");
            } else {
                $(this).find('.move-section-down').removeClass("hidden-button");
            }
            setGiftEntries(this);
//            $(".move").append("<option value='"+i+"'>"+($(this).find('.section-title').val().substring(0, 10).split(" ").slice(0, -1).join(" ") + "...") +"</option>");
        }
    );

    createNav();
}

function setGiftEntries(section){

    /**********************************************
     * Set Order for Items
     *********************************************/
    var section_id = $(section).find('.s-id').val();
    var section_order = $(section).find('.order').val();
    $(section).find('.gift-entry').each( function (e) {
        $(this).find('.order').val(e).change();
        $(this).find('.section-id').val(section_id);
        $(this).find('.section-order').val(section_order);

    });

    if ($(section).find('.gift-entry').length == 0) {
       $(section).find('.section-items').addClass('section-items-empty');
    } else {
       $(section).find('.section-items').removeClass('section-items-empty');
    }

    if ( $(section).prevAll('.section').html() == null) {
        $(section).find('.move-item-up').hide();
    }   else {
        $(section).find('.move-item-up').show()
    }

    if ( $(section).nextAll('.section').html() == null) {
        $(section).find('.move-item-down').hide();
    }   else {
        $(section).find('.move-item-down').show();
    }


}


function addSection(link) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_section", "g");
    var newSection = $(newSectionText.replace(regexp, new_id));


    prepNewSection(newSection);

    newSection.insertAfter($(link).parents('.section')).show(0, function() {
        $.scrollTo(newSection, 800);
    });
    setSections();
}

function updateNavTitle(section) {
    var i = $(section).index();
    $('.category-nav>:nth-child('+(i+2)+') .category-nav-title').html($(section).find('.section-title').val());
}
