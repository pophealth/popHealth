$ ->
	$("#unassigned input:checkbox").click ->
		$(this).parents("tr").find(":text").toggle();
		if $("#unassigned :text:visible").length > 0
			$("th.dateHeader").show();
		else
			$("th.dateHeader").hide();