function submitKeyPress(e) {
	var keynum;
	if(window.event) 
	{
		keynum = e.keyCode;
	}
	else if(e.which)
	{
		keynum = e.which;
	}
	else return true;

	if (keynum == 13)
	{
		document.laika_login_form.submit();
		return false;
	}
	else
	return true;
}

function submitLaikaLoginform() {      
	document.laika_login_form.submit(); 
}

function cancelLogin() {
	document.laika_login_form.reset();
}

function submitLaikaAccountCreationform() {      
	document.laika_account_creation_form.submit(); 
}

function submitResetPasswordinform() {
	document.laika_reset_form.submit(); 
}

function wait(msecs) {
	var start = new Date().getTime();
	var cur = start
	while(cur - start < msecs)
	{
		cur = new Date().getTime();
	}		
}

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
