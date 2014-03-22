$(function(){
    $(".destroy").click(function(e){
        var r = confirm($(".destroy").data("confirm"));
        if (r != true) {
            e.preventDefault();
        }

    });
});


