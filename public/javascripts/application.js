// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {

		// make the param list expand/collapse
		$("#measureClassList li label").click(function(){
			$(this).toggleClass("open");
			if ($(this).hasClass("open")) {
				$(this).siblings("div.measureItemList").slideDown();
			} else {
				$(this).siblings("div.measureItemList").slideUp();
			}
		});
	});
