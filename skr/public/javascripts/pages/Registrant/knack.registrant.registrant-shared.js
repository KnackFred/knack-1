$(function(){

    /**********************************************
     * Set Up On First Load
     *********************************************/

    $('textarea#registrant_Description').autoResize({
        extraSpace: 0
    });

    $('.section-description').autoResize({
        extraSpace: 0
    });
    createNav(true);


    /**********************************************
     * Category Nav Actions
     *********************************************/
    $('.category-nav-link').live('click' , function(event){
        event.preventDefault();
        var i = $(this).parents('.category-nav-item').index();
        var section = $('#sections>:nth-child('+(i)+')');
        $.scrollTo(section, 800);
    });


});

function createNav(first) {
    $('.category-nav').find('.category-nav-item').remove();
    var section_count = 0;
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
            if (src != null) {
                section_count++;
                new_nav.find('img').attr("src", src);
                $('.category-nav').append( new_nav );
            }
        }
    )
    if (section_count <= 1) {
        if (first) {
            $('.category-nav').hide();
        } else {
            $('.category-nav').slideUp();
        }
    } else {
        if (first) {
            $('.category-nav').show();
        } else {
            $('.category-nav').slideDown();
        }
    }
}