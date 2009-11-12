Selenium.prototype.getStyles = function(xpath) {
  /*
  var styles = [ 'background',          'background-attachment',  'background-color',     'background-image', 
                 'background-position', 'background-repeat',      'border',               'border-bottom', 
                 'border-bottom-color', 'border-bottom-style',    'border-bottom-width',  'border-collapse', 
                 'border-color',        'border-left',            'border-left-color',    'border-left-style', 
                 'border-left-width',   'border-right',           'border-right-color',   'border-right-style', 
                 'border-right-width',  'border-style',           'border-top',           'border-top-color', 
                 'border-top-style',    'border-top-width',       'border-width',         'bottom', 
                 'clear',               'clip',                   'color',                'content', 
                 'counter-increment',   'counter-reset',          'cursor',               'direction', 
                 'display',             'float',                  'font',                 'font-family', 
                 'font-size',           'font-size-adjust',       'font-stretch',         'font-style', 
                 'font-variant',        'font-weight',            'height',               'left', 
                 'letter-spacing',      'line-height',            'list-style',           'list-style-image', 
                 'list-style-position', 'list-style-type',        'margin',               'margin-bottom', 
                 'margin-left',         'margin-right',           'margin-top',           'max-height', 
                 'max-width',           'min-height',             'min-width',            'outline', 
                 'outline-color',       'outline-style',          'outline-width',        'overflow', 
                 'padding',             'padding-bottom',         'padding-left',         'padding-right', 
                 'padding-top',         'position',               'quotes',               'right', 
                 'text-align',          'text-decoration',        'text-indent',          'text-transform', 
                 'top',                 'vertical-align',         'visibility',           'white-space', 
                 'width',               'word-spacing',           'z-index',              'marker-offset', 
                 'border-spacing',      'caption-side',           'empty-cells',          'table-layout', 
                 'text-shadow',         'unicode-bidi'];
  */

  var styles        = ['font-size'];
  var calculated    = "";
  var index         = 0;
  var test_document = selenium.browserbot.getCurrentWindow().document;
  var elements      = test_document.evaluate(xpath, test_document, null, XPathResult.ANY_TYPE, null);
  var element       = elements.iterateNext();
  
  while(element) {
    if(element.tagName) {
      var key   = SeleniumRC_FU.verboseXPath(element);
      var style = '';
      
      for(var i = 0; i < styles.length; i ++) {
        var property = styles[i];
        var value    = SeleniumRC_FU.getStyle(test_document, element, property);

        if (!(value == "" || value == null)) {
          style += ('"' + property + '" => "' + value.replace(/"/g, "'") + '",');
        }
      }
      
      style = '"styles" => {' + style + '}';

      calculated += ('"' + key + '" => {' + style + '},');
    }
    
    index ++;
    element = elements.iterateNext();
  }
  
  return "{" + calculated + "}";
}

SeleniumRC_FU = {}

SeleniumRC_FU.verboseXPath = function(element) {
  var parent    = element.parentNode;
  var tag       = element.tagName.toLowerCase();
  var likes     = parent.getElementsByTagName(tag);
  var position  = 1;
  
  while(likes[position - 1] != element) {
    position ++;
  }
  
  var xpath = tag + '[' + position + ']';
  if(parent && parent.tagName) {
    xpath = SeleniumRC_FU.verboseXPath(parent) + '/' + xpath;
  }
  
  return xpath;
}

SeleniumRC_FU.getStyle = function(test_document, element, property) {
  if(element.currentStyle) {
    var result = element.currentStyle[property];
  }
  else if(window.getComputedStyle) {
    var result = test_document.defaultView.getComputedStyle(element, null).getPropertyValue(property);
  }
  return result;
}

