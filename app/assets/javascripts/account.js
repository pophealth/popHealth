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
    submitLoginform();
    return false;
  }
  else
  {
    return true;
  }
}

function submitLoginform()
{
   document.forms[0].submit();
}

function submitRegisterform()
{
   document.forms[0].submit();
}

function submitResetPasswordinform()
{
   document.forms[0].submit();
}

