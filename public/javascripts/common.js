function writeSource(div) {
	if (!document.getElementById) { return; }
	var o = document.getElementById(div);
	if (typeof(o) == "undefined" || o==null) { return; }
	var s = o.innerHTML;
	if (s==null || s.length==0) { 
		return;
		}
	else {
		var i;
		for(i=0;s.charAt(i)==" "||s.charAt(i)=="\n"||s.charAt(i)=="\r"||s.charAt(i)=="\t";i++) {}
		s = s.substring(i);
		for (i = s.length; i>0; i--) {
			if (s.charAt(i)=="<") {
				s = s.substring(0,i) + "&lt;" + s.substring(i+1) ;
				}
			}
		for (i = s.length; i>0; i--) {
			if (s.charAt(i)==">") {
				s = s.substring(0,i) + "&gt;" + s.substring(i+1) ;
				}
			}
		for (i = s.length; i>0; i--) {
			if (s.charAt(i)=="\t") {
				s = s.substring(0,i) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + s.substring(i+1) ;
				}
			}
		for (i = s.length; i>0; i--) {
			if (s.charAt(i)=="\n") {
				s = s.substring(0,i) + "<BR>" + s.substring(i+1) ;
				}
			}
		s = s + "<BR>";
		}
	document.write('<A STYLE="font-family:arial; font-size:x-small; text-decoration:none;" HREF="#" onClick="var d=document.getElementById(\'jssource'+div+'\').style; if(d.display==\'block\'){d.display=\'none\';this.innerText=\'+ Show Source\';}else{d.display=\'block\';this.innerText=\'- Hide Source\';} return false;">+ Show Source</A><BR>');
	document.write('<SPAN ID="jssource'+div+'" STYLE="display:none;background-color:#EEEEEE"><TT>'+s+'</TT></SPAN>');
	}
	