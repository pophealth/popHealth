 $(".tableMeasureTitle span").hoverIntent(
        {over: function(e) {
            var xOffset = -10; 
            var yOffset = 20;
            this.t = this.title;
            this.title = ''; 
            this.top = (e.pageY + yOffset); this.left = (e.pageX + xOffset);
            
            $('body').append( '<p id="vtip"><img id="vtipArrow" />' + this.t + '</p>' );
                        
            $('p#vtip #vtipArrow').attr("src", 'images/vtip_arrow.png');
            $('p#vtip').css("top", this.top+"px").css("left", this.left+"px").fadeIn("slow");
          },
          timeout:600,
          interval:250,
          out: function() { this.title = this.t;
            $("p#vtip").fadeOut("slow")
            $("p#vtip").remove();}
       });