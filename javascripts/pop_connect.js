/*jslint indent: 2, onevar: false, browser: true, onevar: false, white: false  */
/*global $, cyoc */

if(popConnect === undefined) {
  var popConnect = {};
}

// Handy little function to turn an arbitrary JS object
// into a Rails params hash
popConnect.railsSerializer = {
 
  serialize : function(object) {
    var values = []; 
    var prefix = '';
    
    values = this.recursive_serialize(object, values, prefix);
    
    param_string = values.join('&');
    return param_string;
  },
  
  recursive_serialize : function(object, values, prefix) {
    for (key in object) {
      if (typeof object[key] == 'object') {
        
        if (prefix.length > 0) {
          prefix += '['+key+']';         
        } else {
          prefix += key;
        }
        
        values = this.recursive_serialize(object[key], values, prefix);
        
        prefixes = prefix.split('[');
        
        if (prefixes.length > 1) {
          prefix = prefixes.slice(0,prefixes.length-1).join('[');
        } else {
          prefix = prefixes[0];
        }
        
      } else {
        value = encodeURIComponent(object[key]);
        if (prefix.length > 0) {
          prefixed_key = prefix+'['+key+']'          
        } else {
          prefixed_key = key
        }
        prefixed_key = encodeURIComponent(prefixed_key);
        if (value) values.push(prefixed_key + '=' + value);
      }
    }
    return values;
  }
}