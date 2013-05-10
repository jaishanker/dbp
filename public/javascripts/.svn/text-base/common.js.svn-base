/* Include Files */
$(document).ready(function(){
    $(function () {
		
	
		
        //$("#rightcol").load("RightCol_Designs.html");
        //$("#rightcol_Index").load("RightCol_Index.html");
        //$("#discussionRight").load("RightCol_Discussion.html");
        //$("#rightcol_learning").load("RightCol_Learning.html");
        //$("#rightcol_contest").load("RightCol_Contest.html");
        //$("#rightcol_games").load("RightCol_Games.html");
        //$("#rightcol_group").load("RightCol_Group.html");
        //$("#Footer").load("Footer.html");
        //$("#eventRight").load("RightCol_Events.html");
      DD_roundies.addRule('.welcome_div', '5px', true);

	DD_roundies.addRule('.greenheadrightcol, .greenheadrightcol01', '5px', true);
        DD_roundies.addRule('.editbtn, .grnbtn, .grnbtn01, .grnbtn02,.grnbtn05, code.box, #background_conditions_test', '3px', true);
        DD_roundies.addRule('.logout', '0 0 5px 5px', true);
        DD_roundies.addRule('.greenhead, #morph', '5px', true);
        DD_roundies.addRule('a.big_link', '20px', true);
        //DD_roundies.addRule('#totally_round', '10000px 0 10000px 0', true);
        DD_roundies.addRule('.cBoxhead', '5px 5px 0 0', true);
        DD_roundies.addRule('.cBoxcontainer', '0 0 5px 5px', true);
	DD_roundies.addRule('.box01', '5px', true);
	DD_roundies.addRule('.file1', '3px', true);
	DD_roundies.addRule('.Blue4pxbox', '5px', true);         
  
		
        });
});



function profileTabSelect(curr){   

    $('#container-9 ul li').each(function(i,el){
        $( el).removeClass('tabs-selected');
    });
    $(curr).addClass('tabs-selected')
  

}


/*Login validator*/

function login()
{ 
    var username01=document.loginfrm.username.value;
    var password01=document.loginfrm.password.value;
    if(username01=="kamlesh" && password01=="kamlesh")
    {
        document.loginfrm.submit();
    }
    else
        alert("Invalid username password");
}
<!-- Script by hscripts.com -->


/*Login validator*/

/* Curve Corner Method */
//$(document).ready(function(){
   // $(".Blue4pxbox").each(function(){
   //     eval($("code", this).text());
    //});
//});

/*
$(document).ready(function(){
    $(".logout").each(function(){
		eval($("code", this).text());
	});
});
*/

/*Login Form */
/*
$(document).ready(function() {
       		$('input[type="text"]').focus(function() {
    		    if (this.value == this.defaultValue){ 
    		    	this.value = '';
				}
				if(this.value != this.defaultValue){
	    			this.select();
	    		}
    		});
    		$('input[type="text"]').blur(function() {
    		    if ($.trim(this.value) == ''){
			    	this.value = (this.defaultValue ? this.defaultValue : '');
				}
    		});
			
	$('#password-clear').show();
	$('#password-password').hide();
	
	$('#password-clear').focus(function() {
		$('#password-clear').hide();
		$('#password-password').show();
		$('#password-password').focus();
	});
	$('#password-password').blur(function() {
		if($('#password-password').val() == '') {
			$('#password-clear').show();
			$('#password-password').hide();
			$('#password-clear').value = 'Password';
		}
	});
			
});	

*/

/* text */


$(document).ready(function(){

    $('.swap_value').focus(function() {
        if (this.value == this.defaultValue){
            this.value = '';
        }
        if(this.value != this.defaultValue){
            this.select();
        }
    });
    $('.swap_value').blur(function() {
        if ($.trim(this.value) == ''){
            this.value = (this.defaultValue ? this.defaultValue : '');
        }
    });

})


/* Post Comment start */
$(document).ready(function() {
						   
    var hash = window.location.hash.substr(1);
    var href = $('#ComLink a').each(function(){
        var href = $(this).attr('href');
        if(hash==href.substr(0,href.length-5)){
            var toLoad = hash+'.html #ComContent';
            $('#ComContent').load(toLoad)
        }
    });

    $('#ComLink a').click(function(){
								  
        var toLoad = $(this).attr('href')+' #ComContent';
        $('#ComContent').hide('fast',loadContent);
        $('#load').remove();
        $('#wrapper').append('<span id="load">LOADING...</span>');
        $('#load').fadeIn('normal');
        window.location.hash = $(this).attr('href').substr(0,$(this).attr('href').length-5);
        function loadContent() {
            $('#ComContent').load(toLoad,'',showNewContent())
        }
        function showNewContent() {
            $('#ComContent').show('normal',hideLoader());
        }
        function hideLoader() {
            $('#load').fadeOut('normal');
        }
        return false;
		
    });

});

/* for second option only appears on TopicDiscussion_Details.html */
$(document).ready(function() {
						   
    var hash = window.location.hash.substr(1);
    var href = $('#ComLink01 a').each(function(){
        var href = $(this).attr('href');
        if(hash==href.substr(0,href.length-5)){
            var toLoad = hash+'.html #ComContent01';
            $('#ComContent01').load(toLoad)
        }
    });

    $('#ComLink01 a').click(function(){
								  
        var toLoad = $(this).attr('href')+' #ComContent01';
        $('#ComContent01').hide('fast',loadContent);
        $('#load').remove();
        $('#wrapper').append('<span id="load">LOADING...</span>');
        $('#load').fadeIn('normal');
        window.location.hash = $(this).attr('href').substr(0,$(this).attr('href').length-5);
        function loadContent() {
            $('#ComContent01').load(toLoad,'',showNewContent())
        }
        function showNewContent() {
            $('#ComContent01').show('normal',hideLoader());
        }
        function hideLoader() {
            $('#load').fadeOut('normal');
        }
        return false;
		
    });

});

/* Post Comment end */


/* Show Hide Div */
//<![CDATA[

// initialize the jquery code
$(document).ready(function(){
    //close all the content divs on page load
    $('.profilebox').hide();
 
    $('#fadeInOut').toggle(function() {
        $(this).siblings('.profilebox').fadeIn('slow');
    }, function() {
        $(this).siblings('.profilebox').fadeOut('slow');
    });
});



$(document).ready(function(){
    //close all the content divs on page load
    $('.edituploadpic').hide();
 
    $('#uploadpic').toggle(function() {
        $(this).siblings('.edituploadpic').fadeIn('slow');
    }, function() {
        $(this).siblings('.edituploadpic').fadeOut('slow');
    });
});

// this tells jquery to run the function below once the DOM is ready
$(document).ready(function() {

    // choose text for the show/hide link
    var showText="hide [-]";
    var hideText="show [+]";

    // capture clicks on the newly created link
    $('#fadeInOut').click(function() {
        // change the link text
        if ($('#fadeInOut').text()==showText) {
            $('#fadeInOut').text(hideText);
        }
        else {
            $('#fadeInOut').text(showText);
        }

        // return false so any link destination is not followed
        return false;
    });
});
//]]>
	


/* Input type file button */
(function($) {
    
    $.fn.filestyle = function(options) {
                
        /* TODO: This should not override CSS. */
        var settings = {
            width : 250
        };
                
        if(options) {
            $.extend(settings, options);
        };
                        
        return this.each(function() {
            
            var self = this;
            var wrapper = $("<div>")
            .css({
                "width": settings.imagewidth + "px",
                "height": settings.imageheight + "px",
                "background": "url(" + settings.image + ") 0 0 no-repeat",
                "background-position": "right",
                "display": "inline",
                "position": "absolute",
                "overflow": "hidden"
            }).addClass('file1');
                            
            var filename = $('<input class="file">')
            .addClass($(self).attr("class"))
            .css({
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
                } else {
                    $(self).css("margin-left", "-168px");                    
                };
            } else {
                $(self).css("margin-left", settings.imagewidth - settings.width + "px");                
            };

            $(self).bind("change", function() {
                filename.val($(self).val());
            });
      
        });
        

    };
    
})(jQuery);

$(function() {
            
    $("input.inputtxt").filestyle({
        image: "/images/choose-file.gif",
        imageheight : 18,
        imagewidth : 82,
        width : 100
    });
});
$(function() {
            
    $("input.file").filestyle({
        image: "/images/browse.gif",
        imageheight : 18,
        imagewidth : 50,
        width : 200
    });
});

/* Input type file button end */



/* input error highlighinng */

function displayError(parent,element,message){ 
    $('#'+parent + '_' + element ).addClass('error');
    $('#' +element + '_error'  ).html("<font color='red'>" + message + "</font>");  
    setTimeout(function(){
        $('#'+parent + '_' + element ).removeClass('error');
        $('#' +element + '_error'  ).html('');
    },10000) 
}

function destroyDiv(id){
    var DIVtoRemove = document.getElementById(id);
    DIVtoRemove.parentNode.removeChild(DIVtoRemove);
}

// Added on 10/03/10 by anil for hidding notice on click
$(function()
{
    $("#browser_notice").click(function(event) {
        $("#browser_notice").hide().remove();
        SetCookie('browser_notice_closed',true);
    });
});

function show_notice(text, type){
    jQuery.noticeAdd({
        text: text,
        type: type    
    });
}


function addError(id){
    $('#' + id).addClass('error');
/*	setTimeout(function(){
		$('#' + id).removeClass('error');
	},10000) */
}


function selectAllMembers(chk){    
    var checked_status = chk.checked;
    $(".member").each(function(i,el){
        el.checked = checked_status;
    });
};    

function selectAllFollowings(chk){    
    var checked_status = chk.checked;
    $(".following").each(function(i,el){
        el.checked = checked_status;
    });
};    

function validateQualification(){
    var success = true;
    if ($("[name='profile[diploma]']:checked",$("#qualification_form")).length != 1)
    {
        displayError("profile","diploma","Please check atleast one");
        success= false;
    }

    if ($("[name='profile[be]']:checked",$("#qualification_form")).length != 1)
    {
        displayError("profile","be","Please check atleast one");
        success= false;
    }

    if ($("[name='profile[masters]']:checked",$("#qualification_form")).length != 1)
    {
        displayError("profile","masters","Please check atleast one");
        success= false;
    } 
    if ($("#profile_graduation_year_1i").val() == "")
    {
        displayError("profile","graduation_year","Please select graduation year");
        success= false;  
    }
      
    $('.qualification').each(function( i, el){   
        if ($(el).val() == "" || $(el).val() == "-1" )
        {
            $(el) .addClass('error');
            $(el).parent().find('span').html("<span class='errmsg'><font color='red'>&nbsp;Please specify qualification</font></span>")
            success= false;
               
                  
        /*              setTimeout(function(){
                   $(el).removeClass('error');
                   $('.errmsg').each(function( i, el){  
                       $(el).html('');
                   }); 
            },10000)  */            
        }
    });
    
    $('.specialization').each(function( i, el){   
        if ($(el).val() == "" || $(el).val() == "-1" )
        {
            $(el) .addClass('error');
            $(el).parent().find('span').html("<span class='errmsg'><font color='red'>&nbsp;Please specify specialization</font></span>")
            success= false;
               
                  
        /*              setTimeout(function(){
                   $(el).removeClass('error');
                   $('.errmsg').each(function( i, el){  
                       $(el).html('');
                   }); 
            },10000)  */            
        }
    });    
    
   $('.graduation_year').each(function( i, el){   
        if ($(el).val() == "" || $(el).val() == "-1" )
        {
            $(el) .addClass('error');
            $(el).parent().find('span').html("<span class='errmsg'><font color='red'>&nbsp;Please specify graduation year</font></span>")
            success= false;
               
                  
        /*              setTimeout(function(){
                   $(el).removeClass('error');
                   $('.errmsg').each(function( i, el){  
                       $(el).html('');
                   }); 
            },10000)  */            
        }
    });       
    
    return success;
}

function validateProfession(){
    $('.errmsg').each(function( i, el){  
        $(el).html('');
    });
    var success = true;
    
    $('.Employer').each(function( i, el){   
        if ($(el).val() == "" || $(el).val() == "-1" )
        {
            $(el) .addClass('error');
            //                   $(el).add('br').html("<font color='red'>Please specify year of passing</font>");
            $(el).parent().append("<span class='errmsg'><font color='red'>&nbsp;Please specify employer</font></span>")
            success= false;
                  
        /*                setTimeout(function(){
                   $(el).removeClass('error');
                   $('.errmsg').each(function( i, el){  
                       $(el).html('');
                   }); 
            },10000) */
        }
    });
         
    $('.Position').each(function( i, el){   
        if ($(el).val() == "" || $(el).val() == "-1" )
        {
            $(el) .addClass('error');
            //                   $(el).add('br').html("<font color='red'>Please specify year of passing</font>");
            $(el).parent().append("<span class='errmsg'><font color='red'>&nbsp;Please specify position</font></span>")
            success= false;
                  
        /*               setTimeout(function(){
                   $(el).removeClass('error');
                   $('.errmsg').each(function( i, el){  
                       $(el).html('');
                   }); 
            },10000)  */
        }
    });
         
    $('.Industry').each(function( i, el){   
        if ($(el).val() == "" || $(el).val() == "-1" )
        {
            $(el) .addClass('error');
            //                   $(el).add('br').html("<font color='red'>Please specify year of passing</font>");
            $(el).parent().append("<span class='errmsg'><font color='red'>&nbsp;Please specify industry</font></span>")
            success= false;
                  
        /*              setTimeout(function(){
                   $(el).removeClass('error');
                   $('.errmsg').each(function( i, el){  
                       $(el).html('');
                   }); 
            },10000)  */
        }
    });
         
    $('.Duration').each(function( i, el){   
        if ($(el).val() == "" || $(el).val() == "-1" )
        {
            $(el) .addClass('error');
            $(el).parent().find('span').html("<span class='errmsg'><font color='red'>&nbsp;Please specify proper duration</font></span>")
            success= false;
               
                  
        /*              setTimeout(function(){
                   $(el).removeClass('error');
                   $('.errmsg').each(function( i, el){  
                       $(el).html('');
                   }); 
            },10000)  */            
        }
    });
         
    return success;
}

function filterLearnings(val){
    if(val == "")
    {
        show_notice('Please select proper filtering option','error')
    }
    else
    {
        window.location = '/learnings/index?category_id=' + val
    }
}

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


function hide_show(id)
{
    $('.icolink a').removeClass('orange')
    $('#'+id).addClass('orange')
}

$(document).ready(function(){
    $('.ask_login').click(function() {
        $.scrollTo($('#login_div'));
        $('#username').focus();
    });
});


function toggleActivityContent()
{
    $('#twcol').toggle();
    var minimized = get_cookie('minimized')
     if(minimized == 'true')
    {
         minimized = false;
    }
    else
    {
        minimized = true;
    }
    SetCookie('minimized',minimized);
}

function SetCookie(cookieName,cookieValue,nDays) {
 var today = new Date();
 var expire = new Date();
// if (nDays==null || nDays==0) nDays=1;
// expire.setTime(today.getTime() + 3600000*24*nDays);
 expire.setTime(today.getTime() + 3600000);
 document.cookie = cookieName+"="+escape(cookieValue)
                 + ";expires="+expire.toGMTString();
}

function get_cookie ( cookie_name )
{
  var results = document.cookie.match ( '(^|;) ?' + cookie_name + '=([^;]*)(;|$)' );

  if ( results )
    return ( unescape ( results[2] ) );
  else
    return null;
}

$(document).ready(function(){
     var minimized = get_cookie('minimized')
     var closed = get_cookie('closed')
     if(closed=='true')
     {
        $('#myActivity').hide();
     }
     else
     {
        $('#myActivity').show();
     }
   if(minimized== 'true')
    {
         $('#twcol').hide();
    }
    else
    {
         $('#twcol').show();
    }
    //close all the content divs on page load

});

function hideActivityWidget()
{
    $('#myActivity').hide();
    SetCookie('closed','true');    
}

$(document).ready(function(){
	$(".jqzoom").jqzoom();
});

function checkIfOther(specialization)
{
   if(specialization.value == 'Other')
   {
         specialization.disabled = "disabled";
        var textbox = document.createElement('input');
        var textboxName = specialization.name;
         specialization.name = 'temp';
        textbox.setAttribute('name',textboxName);
        textbox.setAttribute('type','text');
        textbox.setAttribute('class','proinput specialization');
        spanElement = specialization.parentNode.getElementsByTagName("span")[0];
        specialization.parentNode.removeChild(spanElement)
        var new_span = document.createElement('span');
        specialization.parentNode.appendChild(textbox);
       specialization.parentNode.appendChild(new_span);
    }
}

    function disableOtherChkBox(checked,class_name)
    {
        if(checked)
            {
                 $('.'+class_name).each(function( i, el){   
                        el.checked = false;
                        el.disabled = true;
                 });
            }
        else
            {
                 $('.'+class_name).each(function( i, el){   
                         el.disabled = false;
                 });
            }
    }
    
    function disableLink(link)
    {
        $('#follow').html('Processing....');
    }
    
    function disablePartLink(link,link_id)
    {
        $('#follow_'+link_id).html('Processing....');
    }             
    
// saves the tiny mce content 
bTextareaWasTinyfied = false; //this should be global, could be stored in a cookie...
function setTextareaToTinyMCE(sEditorID){
    var oEditor = document.getElementById(sEditorID);
    if (oEditor && !bTextareaWasTinyfied) {
        tinyMCE.execCommand('mceAddControl', true, sEditorID);
        bTextareaWasTinyfied = true;
    }
    return;
}

function unsetTextareaToTinyMCE(sEditorID){
    var oEditor = document.getElementById(sEditorID);
    if (oEditor && bTextareaWasTinyfied) {
        tinyMCE.execCommand('mceRemoveControl', true, sEditorID);
        bTextareaWasTinyfied = false;
    }
    return;
}    

var FCKFixer = {
  fixIt: function() {
    for ( i = 0; i < parent.frames.length; ++i )
      if ( parent.frames[i].FCK )
        parent.frames[i].FCK.UpdateLinkedField();
  }
}


