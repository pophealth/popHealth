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


/*
  Number counter and formater
*/
function addCommas(nStr){
  nStr += '';
  x = nStr.split('.');
  x1 = x[0];
  x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + ',' + '$2');
  }
  return x1 + x2;
}


popConnect.Counter = function(start, end, target, append){
  // if appending to the resulting text
  if(!append){append=''}

  this.decr = false;
  if(start>end){
    this.decr = true;
  }
  
  if(typeof start=='string'){
    // clean value from appendages and commas
    start = start.replace(/%|,/, '');
  }
  
  this.num      = start
  this.end      = end;
  this.target   = target;
  var self      = this;
  console.log(start,end)
  this.interval = setInterval(function(){ self.run(); }, 1);

  this.run = function(){
    this.count();
    $(this.target).text( addCommas(this.num)+append );
  }

  this.count = function(){
    if(this.decr){
      if(this.num-10>=this.end){
        this.num -=10;
      }else{
        this.num--;
      }
      if (this.num<=this.end){
        this.stop();
      }
    }else{
      // count by 10s to reduce wait
      if(this.num+10<=this.end){
        this.num +=10;
      }else{
        this.num++;
      }
      if (this.num>=this.end){
        this.stop();
      }
    }
  }

  this.stop = function () {
    clearInterval(this.interval);
  }
}
