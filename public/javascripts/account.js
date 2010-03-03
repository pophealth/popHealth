	// select all forms, bind keypress, and if enter was pushed, submit the form.
	(function(){
		$(function(){
			$("form").keypress(function(e){
				var code = e.keyCode || e.which;
				if(code == 13)
					this.submit();
			});
		});
	})();
