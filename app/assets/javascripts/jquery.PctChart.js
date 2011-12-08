$.fn['PctChart'] = function(options){
	if (!this.length) return this;
		var _options = $.extend({
			phraseTmpl : "${numerator} / ${denominator} = ${percentage}"
			},options);
		var $this = $(this);

		var _show = function() {
			
		}
	
		return {show:_show}
	};