/**
Vertigo Tip by www.vertigo-project.com
Requires jQuery
*/

this.vtip = function() {    
    this.xOffset = -10; // x distance from mouse
    this.yOffset = 10; // y distance from mouse       
    
    $(".vtip").unbind();
    $("#dashboardPeriod").delegate(".vtip","mouseover mouseout mousemove",    
        function(e) {
        if (e.type == 'mouseover') {
            this.t = this.title;
            this.title = ''; 
            this.top = (e.pageY + yOffset); this.left = (e.pageX + xOffset);
            
            $('body').append( '<p id="vtip"><img id="vtipArrow" />' + this.t + '</p>' );
                        
            $('p#vtip #vtipArrow').attr("src", '/assets/vtip_arrow.png');
            $('p#vtip').css("top", this.top+"px").css("left", this.left+"px").fadeIn("slow");
            
        }
        if (e.type == 'mouseout') {
            this.title = this.t;
            $("p#vtip").fadeOut("slow").remove();
        }
    if (e.type == 'mousemove') {
            this.top = (e.pageY + yOffset);
            this.left = (e.pageX + xOffset);
                         
            $("p#vtip").css("top", this.top+"px").css("left", this.left+"px");
        }
    }
    );            
    
};

jQuery(document).ready(function($){vtip();}) 