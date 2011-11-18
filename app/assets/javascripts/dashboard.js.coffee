@Dashboard = {
	calculateMeasure: (result) ->
		row = Dashboard.measureRow(result.measure_id)
		Render.percent row.find("div.measureProviderPopulationPercentage"), result
		Render.barChart row.find("div.tableBar"), result
		Render.fraction row.find("td.fraction"), result
	measureRow: (measure) ->
		return $("tr.measure[data-measure='#{measure}']")
	fadeIn: (measure) -> 
		Dashboard.measureRow(measure).fadeIn("fast")
	fadeOut: (measure) -> 
		Dashboard.measureRow(measure).fadeOut("fast")
		$.post("/measure/#{measure}/remove", {})
	onLoad: ->
		Page.onMeasureSelect = (measure) -> Dashboard.fadeIn(measure)
		Page.onMeasureRemove = (measure) -> Dashboard.fadeOut(measure)
		Page.onReportComplete = (result) -> Dashboard.calculateMeasure(result)
}