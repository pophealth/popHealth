// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// = require jquery
// = require jquery_ujs
// = require_tree .

$(".tableMeasureTitle span").hoverIntent(
       {over: function(e) {
           var xOffset = -10; 
           var yOffset = 20;
           this.t = this.title;
           this.title = ''; 
           this.top = (e.pageY + yOffset); this.left = (e.pageX + xOffset);
           
           $('body').append( '<p id="vtip"><img id="vtipArrow" />' + this.t + '</p>' );
                       
           $('p#vtip #vtipArrow').attr("src", 'assets/vtip_arrow.png');
           $('p#vtip').css("top", this.top+"px").css("left", this.left+"px").fadeIn("slow");
         },
         timeout:600,
         interval:250,
         out: function() { this.title = this.t;
           $("p#vtip").fadeOut("slow")
           $("p#vtip").remove();}
      });