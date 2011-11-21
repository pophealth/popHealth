@Dashboard = {
	calculateMeasure: (response) ->
		$.each response, (i, result) ->
			row = Dashboard.measureRow(result.measure_id, result.sub_id)
			Render.percent row.find("div.measureProviderPopulationPercentage"), result
			Render.barChart row.find("div.tableBar"), result
			Render.fraction row.find("td.fraction"), result
	measureRow: (measure, sub_id) ->
		sub_id or= ''
		return $("tr.measure[data-measure='#{measure}'][data-measure-sub='#{sub_id}']")
	fadeIn: (measure) -> 
		Dashboard.measureRow(measure).fadeIn("fast")
	fadeOut: (measure) -> 
		Dashboard.measureRow(measure).fadeOut("fast")
		$.post("/measure/#{measure}/remove", {})
	onLoad: ->
		Page.onMeasureSelect = (measure) -> Dashboard.fadeIn(measure)
		Page.onMeasureRemove = (measure) -> Dashboard.fadeOut(measure)
		Page.onReportComplete = (result) -> Dashboard.calculateMeasure(result)
		$("div.measureItemList ul li.checked").each (i, m) ->
			measureId = $(m).attr("data-measure-id")
			qr = new QualityReport(measureId)
			qr.poll {}, (result) ->
				Dashboard.calculateMeasure(result)
}