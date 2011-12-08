/*
 * Copyright 2010 Guillaume Bort
 * http://github.com/guillaumebort/jquery-ndd
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Fix styles
jQuery(function() {
    jQuery('head').append('<style type="text/css">[draggable=true] {-webkit-user-drag: element; -webkit-user-select: none; -moz-user-select: none;}</style>');
})

// Fix events fix...
var originalFix = jQuery.event.fix;

jQuery.event.fix = function(event) {
    event = originalFix.apply(this, [event]);
    if( event.type.indexOf('drag') == 0 || event.type.indexOf('drop') == 0 ) {
        event.dataTransfer = event.originalEvent.dataTransfer;
    }
    return event;
}

// Add Drag&Drop handlers
jQuery.each( ("drag dragenter dragleave dragover dragend drop dragstart").split(" "), function( i, name ) {

	// Handle event binding
	jQuery.fn[ name ] = function( fn ) {
		return fn ? this.bind( name, fn ) : this.trigger( name );
	};

	if ( jQuery.attrFn ) {
		jQuery.attrFn[ name ] = true;
	}
});

// Live draggable's && droppable's
jQuery.fn.extend({

    draggable: function(start, end) {
    
        this.live('dragstart dragend', function(e) {
            
            if(e.type == 'dragstart' && start) {
               var data = start.apply(this, [e]); 
               if(data) {
                   for(var k in data) {
                       if(k == 'effect') {
                           e.dataTransfer.effectAllowed = data[k];
                       } else {
                           e.dataTransfer.setData(k, data[k]);
                       }                       
                   }
               }
            }
            
            if(e.type == 'dragend' && end) {
               end.apply(this, [e]); 
            }
            
        });
    },

    droppable: function(accept, enter, leave, drop) {
        var currents = {}, uuid = 0;
            
        this.live('dragenter dragleave dragover drop', function(e) {
            if(!this.uuid) {
                this.uuid = ++uuid;
                currents[this.uuid] = {hover: false, leaveTimeout: null};
            }
            
            // TODO add custom drop effect
            if(!e.dataTransfer.dropEffect && e.dataTransfer.effectAllowed) {
                switch(e.dataTransfer.effectAllowed) {
                    case 'none': e.dataTransfer.dropEffect = 'none'; break
                    case 'copy': e.dataTransfer.dropEffect = 'copy'; break
                    case 'move': e.dataTransfer.dropEffect = 'move'; break
                    case 'link': e.dataTransfer.dropEffect = 'link'; break
                    case 'copyMove': e.dataTransfer.dropEffect = 'copy'; break
                    case 'copyLink': e.dataTransfer.dropEffect = 'copy'; break
                    case 'linkMove': e.dataTransfer.dropEffect = 'move'; break
                    case 'all': e.dataTransfer.dropEffect = 'copy'; break
                }
            }
            
            if(e.type == 'dragenter' || e.type == 'dragover') {
                clearTimeout(currents[this.uuid].leaveTimeout);
                
                if(!currents[this.uuid].hover) {
                    var accepted = false;
                    if(jQuery.isFunction(accept)) {
                        accepted = accept.apply(this, [e])
                    } else {
                        var types = accept.toString().split(' ');
                        for(var i=0; i<types.length; i++) {
                            var type = types[i];
                            
                            if(type.toLowerCase() == 'text') {
                                type = 'text/plain';
                            }
                            if(type.toLowerCase() == 'url') {
                                type = 'text/uri-list';
                            }
                            if(type == '*') {
                                accepted = true;
                                break;
                            }
                            if(type == 'Files') {
                                
                                // Fix Safari Mac (seems fixed in webkit nightly)
                                for(var ii=0; ii<e.dataTransfer.types.length; ii++) {
                                    if('public.file-url' == e.dataTransfer.types[ii]) {
                                        accepted = true;
                                        break;
                                    }
                                }
                            }
                            
                            if(e.dataTransfer.types) {
                                for(var ii=0; ii<e.dataTransfer.types.length; ii++) {
                                    if(type == e.dataTransfer.types[ii]) {
                                        accepted = true;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                
                    if(accepted) {
                        e.preventDefault();
                        if(enter) enter.apply(this, [e]);
                        currents[this.uuid].hover = true;
                    }
                } else {
                    e.preventDefault();
                }
            } 
             
            if(e.type == 'dragleave') {
                if(currents[this.uuid].hover) {
                    var self = this;
                    currents[this.uuid].leaveTimeout = setTimeout(function() {
                        if(leave) leave.apply(self, [e]);
                        currents[self.uuid].hover = false;
                    }, 50);
                }
            }  
            
            if(e.type == 'drop') {
                if(currents[this.uuid].hover) {
                    if(leave) leave.apply(this, [e]);
                    currents[this.uuid].hover = false;
                    if(drop) drop.apply(this, [e]);
                    e.preventDefault();
                }
            }
                
        });
                
    }

});


