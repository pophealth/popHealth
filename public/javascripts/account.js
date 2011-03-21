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
    document.login_form.submit();
    return false;
  }
  else
  {
    return true;
  }
}

function submitLoginform()
{
   document.login_form.submit();
}

function submitRegisterform()
{
   document.register_form.submit();
}

function submitResetPasswordinform()
{
  document.forgot_password_form.submit();
}

