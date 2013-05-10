/* input error highlighinng 
 function displayError(parent,element,message){
 $('#'+parent + '_' + element ).addClass('error');
 $('#' +element + '_error'  ).html("<font color='red'>"+message + "</font>");
 
 setTimeout(function(){
 //          element = element.replace(/^\w/, function($0) { return $0.toLowerCase(); })
 $('#'+parent + '_' + element ).removeClass('error');
 $('#' +element + '_error'  ).html('');
 },20000)
 
 }
 */
function closePopup(){
    $("iframe[name=hsIframe0]").close();
    //  return hs.close(popup);
}



function show_notice(text, type){
    jQuery.noticeAdd({
        text: text,
        type: type
    
    });
}


/* Input type file button */
(function($){

    $.fn.filestyle = function(options){
    
        /* TODO: This should not override CSS. */
        var settings = {
            width: 250
        };
        
        if (options) {
            $.extend(settings, options);
        };
        
        return this.each(function(){
        
            var self = this;
            var wrapper = $("<div>").css({
                "width": settings.imagewidth + "px",
                "height": settings.imageheight + "px",
                "background": "url(" + settings.image + ") 0 0 no-repeat",
                "background-position": "right",
                "display": "inline",
                "position": "absolute",
                "overflow": "hidden"
            });
            
            var filename = $('<input class="file">').addClass($(self).attr("class")).css({
                "display": "inline",
                "width": settings.width + "px"
            });
            
            $(self).before(filename);
            $(self).wrap(wrapper);
            
            $(self).css({
                "position": "relative",
                "height": settings.imageheight + "px",
                "width": settings.width + "px",
                "display": "inline",
                "cursor": "pointer",
                "opacity": "0.0"
            });
            
            if ($.browser.mozilla) {
                if (/Win/.test(navigator.platform)) {
                    $(self).css("margin-left", "-142px");
                }
                else {
                    $(self).css("margin-left", "-168px");
                };
                            }
            else {
                $(self).css("margin-left", settings.imagewidth - settings.width + "px");
            };
            
            $(self).bind("change", function(){
                filename.val($(self).val());
            });
            
        });
        
        
    };
    
})(jQuery);

$(function(){

    $("input.inputtxt").filestyle({
        image: "/images/choose-file.gif",
        imageheight: 18,
        imagewidth: 82,
        width: 100
    });
});
$(function(){

    $("input.file").filestyle({
        image: "/images/upload.gif",
        imageheight: 18,
        imagewidth: 50,
        width: 200
    });
});

/* Input type file button end */


function addError(id){
    $('#' + id).addClass('error');
    setTimeout(function(){
        $('#' + id).removeClass('error');
    }, 10000)
}


/* data table */

$(document).ready(function(){

    oTable = $('#example').dataTable({
        "bJQueryUI": true,
        "sPaginationType": "full_numbers"
    });
    
});


function beforeLoader(){
    block();
}


function afterLoader(){
    unblock();
}

function block(){
    $("BODY").append('<div id="popup_overlay"></div>');
    $("#popup_overlay").css({
        position: 'absolute',
        zIndex: 9998,
        top: '0px',
        left: '0px',
        width: '100%',
        height: $(document).height(),
        background: '#000',
        opacity: 0.2
    });
}


function unblock(){

    $("#popup_overlay").remove();
}


$(document).ready(function(){
    DD_roundies.addRule('.editbtn, .grnbtn, .grnbtn01, .grnbtn02, code.box, #background_conditions_test', '3px', true);
    DD_roundies.addRule('.logout', '0 0 5px 5px', true);
    DD_roundies.addRule('.greenhead, #morph', '5px', true);
    DD_roundies.addRule('a.big_link', '20px', true);
    //DD_roundies.addRule('#totally_round', '10000px 0 10000px 0', true);
    DD_roundies.addRule('.cBoxhead', '5px 5px 0 0', true);
    DD_roundies.addRule('.cBoxcontainer', '0 0 5px 5px', true);
    
})
