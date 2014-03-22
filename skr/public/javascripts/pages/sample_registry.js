/**
 * Created by JetBrains RubyMine.
 * User: jshriver-blake
 * Date: 1/11/12
 * Time: 2:51 PM
 * To change this template use File | Settings | File Templates.
 */

$(function() {
    $('.open').toggle();
    $('.close').click( function(event) {
        event.preventDefault();
        $('.like-dialog').animate({width: '40px'});
        $('.close').toggle();
        $('.open').toggle();
    });

    $('.open').click( function(event) {
        event.preventDefault();
        $('.like-dialog').animate({width: '488px'});
        $('.close').toggle();
        $('.open').toggle();
    });

    $('#kitchen-nav').click( function(event) {
        $.scrollTo("#kitchen", 800);
        event.preventDefault();
    });

    $('#table-nav').click( function(event) {
        $.scrollTo("#table", 800);
        event.preventDefault();
    });

    $('#home-nav').click( function(event) {
        $.scrollTo("#home", 800);
        event.preventDefault();
    });

    $('#art-nav').click( function(event) {
        $.scrollTo("#art", 800);
        event.preventDefault();
    });

    $('#peru-nav').click( function(event) {
        $.scrollTo("#peru", 800);
        event.preventDefault();
    });

    $('#adventures-nav').click( function(event) {
        $.scrollTo("#adventures", 800);
        event.preventDefault();
    });
});