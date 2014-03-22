function pop_up (url, width, height, text) {
    $.modal(
        '<div class="pop-up"><div class="wait-container"><img alt="Please Wait" src="/images/wait.gif"></div><iframe src="'+url+'" id="popup" width="'+width+'px" height="'+height+'x" frameborder="0" style="border: 0;"></iframe></div>',
        {
            minHeight:height,
            minWidth: width,
            textHeader: text,
            onShow: function(){
              $(".pop-up iframe").load(function(){
                  $(".pop-up .wait-container").hide();
              });
            }
        }
    );
}

function make_pop_up (link, width, height, text) {
    $(link).click(function(e){
        e.preventDefault();
        pop_up( $(link).attr("href"), width, height, text);
    })
}
