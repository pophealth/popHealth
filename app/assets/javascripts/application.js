// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function roundNumber(num, dec) {
  return Math.round(num*Math.pow(10,dec))/Math.pow(10,dec);
}

$(document).ajaxSend(function(e, xhr, options) {
  var token = $("meta[name='csrf-token']").attr("content");
  xhr.setRequestHeader("X-CSRF-Token", token);
});
