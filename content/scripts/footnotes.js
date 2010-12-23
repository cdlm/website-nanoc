// Slightly adapted from http://ignorethecode.net/blog/2010/04/20/footnotes/
// this script requires jQuery

// need to learn how to write clean javascript for closure compiler
(function () {

    var footnoteTimeout = false;

    function footnoteOver() {
        clearTimeout(footnoteTimeout);
        $('#footnotebubble').stop();
        $('#footnotebubble').remove();
        
        var id = $(this).attr('href').substr(1);
        var position = $(this).offset();
    
        var div = $(document.createElement('div'));
        div.attr('id','footnotebubble');
        div.css('position','absolute');
        div.bind('mouseover', divOver);
        div.bind('mouseout', footnoteOut);
        div.html($(document.getElementById(id)).html());
        
        $(document.body).append(div);

        var w = $(window);
        var left = position.left;
        if(left + 420  > w.width() + w.scrollLeft()) {
            left = w.width() - 420 + w.scrollLeft();
        }
        var top = position.top + 20;
        if(top + div.height() > w.height() + w.scrollTop()) {
            top = position.top - div.height() - 15;
        }
        div.css({
            left: left,
            top: top,
            opacity: 0.9
        });
    }
    
    function footnoteOut() {
        footnoteTimeout = setTimeout(function() {
            $('#footnotebubble').animate({ opacity: 0 }, 600,
                function() { $('#footnotebubble').remove(); });
        }, 100);
    }
    
    function divOver() {
        clearTimeout(footnoteTimeout);
        $('#footnotebubble').stop();
        $('#footnotebubble').css({ opacity: 0.9 });
    }
    
    $(document).ready(function() {
        var footnoteLinks = $("a[rel='footnote']");
        
        footnoteLinks.unbind('mouseover', footnoteOver);
        footnoteLinks.unbind('mouseout', footnoteOut);
    
        footnoteLinks.bind('mouseover', footnoteOver);
        footnoteLinks.bind('mouseout', footnoteOut);
    });
    
})();
