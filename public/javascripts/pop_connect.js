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
    var value;
    var prefixed_key;
    var child_prefix = '';
    
    if($.isArray(object)) {
      for (var key in object) {
        if (typeof object[key] == 'object' || typeof object[key] == 'array') {
        
          if (prefix.length > 0) {
            child_prefix = prefix + '[]';
          } else {
            child_prefix = key;
          }
        
          values = this.recursive_serialize(object[key], values, child_prefix);
                
        } else if (typeof object[key] != 'function') {
          value = encodeURIComponent(object[key]);
          if (prefix.length > 0) {
            prefixed_key = prefix+'[]'
          } else {
            prefixed_key = key
          }
          prefixed_key = encodeURIComponent(prefixed_key);
          if (value) values.push(prefixed_key + '=' + value);
        }
      }
    } else {    
      for (var key in object) {
        if (typeof object[key] == 'object' || typeof object[key] == 'array') {
        
          if (prefix.length > 0) {
            child_prefix = prefix + '['+key+']';         
          } else {
            child_prefix = key;
          }
        
          values = this.recursive_serialize(object[key], values, child_prefix);
                
        } else if (typeof object[key] != 'function') {
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
    }
    return values;
  }
}
