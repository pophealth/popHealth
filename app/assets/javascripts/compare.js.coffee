@Compare = {
	calculateMeasure: (response, comparison) ->
		$.each response, (i, result) ->
			Compare.calculateSingleMeasure(result, comparison)
	calculateSingleMeasure: (result, comparison) ->
		row = Compare.measureRow(result.measure_id, result.sub_id)
		row.fadeTo("fast", 1.0)
		Render.barChart row.find("div.tableBar"+ (comparison || '.phval')), result
		Render.fraction row.find("td.compareValue"+ (comparison || '.phval')), result
	measureRow: (measure, sub_id) ->
		selector = "tr.measure[data-measure='#{measure}']"
		selector += "[data-measure-sub='#{sub_id || ''}']" if sub_id?
		$(selector)
	measureRows: (measure) ->
		return $("tr.measure[data-measure='#{measure}']")
	fadeIn: (measure) -> 
		Compare.measureRows(measure).fadeTo("fast", 0.5)
		$.post("/measure/#{measure}/select", {})
	fadeOut: (measure) -> 
		Compare.measureRows(measure).fadeOut("fast")
		$.post("/measure/#{measure}/remove", {})
	calculateSelected: ->
		$(".measureProviderPopulationPercentage").html("<div><div class='jobLabel'></div><img src='/assets/loading.gif'/></div>")
		$(".numeratorValue").html('0')
		$(".denominatorValue").html('0')
		$("div.measureItemList ul li.checked").each (i, m) ->
			measureId = $(m).attr("data-measure-id")
			qr = new QualityReport(measureId)
			Compare.measureRows(measureId).fadeTo("fast", 0.5)
			params = {}
			params['npi'] = Page.npi
			params['compare_report'] = Page.compare_report if Page.compare_report
			qr.poll params, Page.onReportComplete
	onLoad: ->
		Page.onMeasureSelect = (measure) ->
			Compare.measureRow(measure).prevAll(".headerRow").first().show()
			Compare.fadeIn(measure)
		Page.onMeasureRemove = (measure) -> 
			Compare.fadeOut(measure)
			measureRow = Compare.measureRow(measure).first()
			Compare.measureRow(measure).prevAll(".headerRow").first().hide() if measureRow.prevUntil(".headerRow", ":not([data-measure='#{measure}']):visible").length == 0 && measureRow.nextUntil(".headerRow", ":not([data-measure='#{measure}']):visible").length == 0
			
		Page.onReportComplete = (result, complete, compare_result) -> 
			if (complete)
				Compare.calculateMeasure(result)
				Compare.calculateMeasure(compare_result, '.compare')
				Compare.highlightRow Compare.measureRow(row.measure_id, row.sub_id) for row in result
			else
				$.each result, (i, data) ->
					if data.job?
						row = Compare.measureRow(data.job.measure_id, data.job.sub_id)
						if (data.job.status != 'failed')
							row.find('.jobLabel').text(data.job.status)
						else
							row.find('.jobLabel').parent().html(data.job.status)
					else
						Compare.calculateSingleMeasure(data)
				
		Page.onFilterChange = (li) ->
			Compare.calculateSelected()
		$('#highlight_zero').click(-> 
			Compare.highlightZero = $(this).is(':checked')
			Compare.highlightData())
		Compare.calculateSelected()
	
	minHighlight: 5
	maxHighlight: 20
	highlightZero: true
	highlightData: ->
		$.each $('tr.measure'), (index, val) ->
			val = $(val)
			Compare.highlightRow(val)
	highlightRow: (val)->
		phNum = parseInt(val.find('td.compareValue.phval.numeratorCompare').find('.numeratorValue').text())
		phDen = parseInt(val.find('td.compareValue.phval.denominatorCompare').find('.denominatorValue').text())
		compareNum = parseInt(val.find('td.compareValue.compare.numeratorCompare').find('.numeratorValue').text())
		compareDen = parseInt(val.find('td.compareValue.compare.denominatorCompare').find('.denominatorValue').text())
		
		
		numPercent = 0
		numPercent = Math.abs(phNum - compareNum)*100/Math.max(phNum, compareNum) if (Math.max(phNum, compareNum) > 0)
		denPercent = 0
		denPercent = Math.abs(phDen - compareDen)*100/Math.max(phDen, compareDen) if (Math.max(phDen, compareDen) > 0)
		
		greenHighlight = '#E3FFE3'
		redHighlight = '#FFE3E3'
		
		if (Compare.highlightZero or Math.max(phNum,compareNum) > 0)
			if (numPercent <= Compare.minHighlight)
				val.find('td.numeratorCompare').animate({backgroundColor:greenHighlight}, 500)
			else if (numPercent >= Compare.maxHighlight)
				val.find('td.numeratorCompare').animate({backgroundColor:redHighlight}, 500)
			else
				val.find('td.numeratorCompare').animate({backgroundColor:'#FFF'}, 500)
		else
			val.find('td.numeratorCompare').animate({backgroundColor:'#FFF'}, 500)
		
		if (Compare.highlightZero or Math.max(phDen,compareDen) > 0)
			if (denPercent <= Compare.minHighlight)
				val.find('td.denominatorCompare').animate({backgroundColor:greenHighlight}, 500)
			else if (denPercent >= Compare.maxHighlight)
				val.find('td.denominatorCompare').animate({backgroundColor:redHighlight}, 500)
			else
				val.find('td.denominatorCompare').animate({backgroundColor:'#FFF'}, 500)
		else
			val.find('td.denominatorCompare').animate({backgroundColor:'#FFF'}, 500)
		

}