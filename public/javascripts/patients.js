function update_value(x, y)
{
	document.getElementById(y).value = document.getElementById(x).value
}

function swap_div(id1, id2)
{
  $(id1).style.display="none";		
  $(id2).style.display="inline";
  //Effect.toggle(id2,'appear'); 
}

function scroll_to_module_and_highlight(id, time)
{
  scroll_to_module(id,time);
  new Effect.Highlight(id,{duration:3.0});
}

function scroll_to_module(id, time)
{
  new Effect.ScrollTo(id,{duration:time});
}

function highlight_module(id)
{
  new Effect.Highlight(id,{duration:3.0});
  //scroll_to_module(id1,{duration:1.0});
}
