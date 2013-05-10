/**
 *	jQuery.noticeAdd() and jQuery.noticeRemove()
 *	These functions create and remove growl-like notices
 *
 *   Copyright (c) 2009 Tim Benniks
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to deal
 *	in the Software without restriction, including without limitation the rights
 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *	copies of the Software, and to permit persons to whom the Software is
 *	furnished to do so, subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *	THE SOFTWARE.
 *
 *	@author 	Tim Benniks <tim@timbenniks.com>
 * 	@copyright  2009 timbenniks.com
 *	@version    $Id: jquery.notice.js 1 2009-01-24 12:24:18Z timbenniks $
 **/
(function(jQuery){
    jQuery.extend({
        noticeAdd: function(options){
            var defaults = {
                inEffect: {
                    opacity: 'show'
                }, // in effect
                inEffectDuration: 600, // in effect duration in miliseconds
                stayTime: 5000, // time in miliseconds before the item has to disappear
                text: '', // content of the item
                stay: false, // should the notice item stay or not?
                type: 'notice' // could also be error, succes
            }
            
            // declare varaibles
            var options, noticeWrapAll, noticeItemOuter, noticeItemInner, noticeItemClose;
            
            options = jQuery.extend({}, defaults, options);
            noticeWrapAll = (!jQuery('.notice-wrap').length) ? jQuery('<div></div>').addClass('notice-wrap').appendTo('body') : jQuery('.notice-wrap');
            noticeItemOuter = jQuery('<div></div>').addClass('notice-item-wrapper');
            noticeItemInner = jQuery('<div></div>').hide().addClass('notice-item ' + options.type).appendTo(noticeWrapAll).html('<p>' + options.text + '</p>').animate(options.inEffect, options.inEffectDuration).wrap(noticeItemOuter);
            noticeItemClose = jQuery('<div></div>').addClass('notice-item-close').prependTo(noticeItemInner).html('x').click(function(){
                jQuery.noticeRemove(noticeItemInner)
            });
            if (navigator.userAgent.match(/MSIE /i)) {
                if (options.type == 'error') {
                    $('.notice-item').each(function(i,el){
                        $(el).css({
                            'background': '#ff6600',
                            'left': '400px'
                        });
                    });
                }
                else {
                    $('.notice-item').each(function(i,el){
                        $(el).css({
                            'background': '#81a13d',
                            'border' : '2px solid #556F1B',
                            'left': '400px'
                        });
                    });
                }
            }
            else {
                if (options.type == 'error') {
                    $('.notice-item').css({
                        'background': '#ff6600',
                        'left': width() / 2 - 175 + 'px'
                    })
                }
                else {
                    $('.notice-item').css({
                        'background': '#81a13d',
                        'border' : '2px solid #556F1B',
                        'left': width() / 2 - 175 + 'px'
                    })
                }
            }
            if (navigator.userAgent.match(/MSIE /i)) {
            
            //  $('.notice-item').corner("round 8px")
            // hmmmz, zucht
            }
            if (navigator.userAgent.match(/MSIE 6/i)) {
                noticeWrapAll.css({
                    top: document.documentElement.scrollTop
                });
            }
            
            if (!options.stay) {
                setTimeout(function(){
                    jQuery.noticeRemove(noticeItemInner);
                }, options.stayTime);
            }
        },
        
        noticeRemove: function(obj){
            obj.animate({
                opacity: '0'
            }, 400, function(){
                obj.parent().animate({
                    height: '0px'
                }, 300, function(){
                    obj.parent().remove();
                });
            });
        }
    });
})(jQuery);

function width(){
    // the more standards compliant browsers (mozilla/netscape/opera/IE7) use window.innerWidth and window.innerHeight
    
    if (typeof window.innerWidth != 'undefined') {
        viewportwidth = window.innerWidth, viewportheight = window.innerHeight
    }
    
    // IE6 in standards compliant mode (i.e. with a valid doctype as the first line in the document)
    
    else 
    if (typeof document.documentElement != 'undefined' &&
        typeof document.documentElement.clientWidth !=
        'undefined' &&
        document.documentElement.clientWidth != 0) {
        viewportwidth = document.documentElement.clientWidth, viewportheight = document.documentElement.clientHeight
    }
        
    // older versions of IE
        
    else {
        viewportwidth = document.getElementsByTagName('body')[0].clientWidth, viewportheight = document.getElementsByTagName('body')[0].clientHeight
    }
    
    return viewportwidth
}
