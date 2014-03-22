$(function(){

    /**********************************************
     * Set Up On First Load
     *********************************************/

    $('.edit_registrant').validate();
    $('textarea#registrant_Description').autoResize({
        extraSpace: 0
    });

    $('input[placeholder], textarea[placeholder]').placeholder();


    $(".section").each(
        function ()
        {
            prepNewSection(this);

        });

    setSections();

    createNav();

    var warnMessage = "You haven't saved your changes, if you continue they will be lost!";

    $('input:not(:button,:submit),textarea,select').live('change', function () {
        window.onbeforeunload = function () {
            if (warnMessage != null) return warnMessage;
        }
    });
    $('input:submit').click(function(e) {
        warnMessage = null;
    });




    /**********************************************
     * Category Nav Actions
     *********************************************/
    $('.category-nav-link').live('click' , function(event){
        event.preventDefault();
        var i = $(this).parents('.category-nav-item').index();
        var section = $('#sections>:nth-child('+(i)+')');
        $.scrollTo(section, 800);
    });

    /**********************************************
     * Section Actions
     *********************************************/
    $('.add-section').live('click' , function(event){
        event.preventDefault();
        addSection(this);
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
        section = $(this).parents('.section');
        destSection = (section.prevAll('.section').html() != null)?section.prevAll('.section').first():section.nextAll('.section').first()
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
    });

    /**********************************************
     * Item Actions
     *********************************************/
    $('.move-item-up').live('click' , function(event){
        event.preventDefault();

        var item = $(this).parents('.gift-entry');
        var section = $(this).parents('.section');
        var dstSection = section.prevAll('.section');
        if (dstSection.html() != null) {
            dstSection.find('.section-items').append(item);
            setSections();
        }
    });

    $('.move-item-down').live('click' , function(event){
        event.preventDefault();

        var item = $(this).parents('.gift-entry');
        var section = $(this).parents('.section');
        var dstSection = section.nextAll('.section');
        if (dstSection.html() != null) {
            dstSection.find('.section-items').prepend(item);
            setSections();
        }
    });

    /**********************************************
     * POP UP
     *********************************************/
    jQuery('.buy').click(function(){
        var id = jQuery(this).attr('r2pid');

        jQuery('.block-iframe').modal(
            {
                overlayClose:true,
                minHeight:540,
                minWidth: 500,
                close: true
            });
        jQuery('#ifr-popup').attr('src','/buy/buy/'+ id);
    });

    jQuery('.contribute').click(function(){

        var id = jQuery(this).attr('r2pid');

        jQuery('.block-iframe').modal(
            {
                overlayClose:true,
                minHeight:100,
                minWidth: 200,
                close: true
            });
        jQuery('#ifr-popup').attr('src','/buy/contribute/'+ id)
    });


});

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
        updateNav($(this).parents('.section'));
    });

    $(newSection).find('input[placeholder], textarea[placeholder]').placeholder();

    $(newSection).find( ".section-items" ).sortable({
        connectWith: ".section-items",
        receive: function(event, ui) {
            updateNav($(this).parents('.section'));
            setGiftEntries($(this).parents('.section'))
        },
        remove: function(event, ui) {
            updateNav($(this).parents('.section'));
            setGiftEntries($(this).parents('.section'))
        },
        stop: function(event, ui) {
            updateNav($(this).parents('.section'));
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

function updateNav(section) {
    var i = $(section).index();
    $('.category-nav>:nth-child('+(i+2)+') .category-nav-title').html($(section).find('.section-title').val());
    var src = $(section).find('.gift-entry img').first().attr("src");
    if (src == null) {
        src = "/images/defaultImage.png"
    }
    $('.category-nav>:nth-child('+(i+2)+') img').attr("src", src);
}

function createNav() {
    $('.category-nav').find('.category-nav-item').remove();
    $(".section").each(
        function ()
        {
            var new_nav = $('.category-nav-template').clone().removeClass('category-nav-template').addClass('category-nav-item').show();
            var text;
            if ($(this).find('.section-title').hasClass('placeholder'))
            {
                text = "";
            } else {
                text = $(this).find('.section-title').val();
            }

            new_nav.find('.category-nav-title').html(text);

            var src = $(this).find('.gift-entry img').first().attr("src");
            if (src == null) {
                src = "/images/defaultImage.png"
            }
            new_nav.find('img').attr("src", src);

            $('.category-nav').append( new_nav );
        }
    )
}