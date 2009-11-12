	function submitKeyPress(e)
	{
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
	
    function submitLaikaLoginform()
    {      
      document.laika_login_form.submit(); 
    }

	function submitLaikaAccountCreationform()
    {      
      document.laika_account_creation_form.submit(); 
    }
      
    function submitResetPasswordinform()
    {
      document.laika_reset_form.submit(); 
    }

    function wait(msecs)
    {
      var start = new Date().getTime();
      var cur = start
      while(cur - start < msecs)
      {
        cur = new Date().getTime();
      }		
    }

    function toggleVisibility(id1,id2,id3)
    {
		  if ($(id1).style.visibility=="hidden")
      {
        Effect.toggle(id3,'appear');
        wait(200);
        $(id1).style.visibility="visible";
        $(id2).style.visibility="visible";
		  }
		  else
      {
        Effect.toggle(id3,'appear');
		  	$(id1).style.visibility="hidden";
        $(id2).style.visibility="hidden";
		  }
		}          
