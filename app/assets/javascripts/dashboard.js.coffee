@Dashboard = {
	calculateMeasure: (response) ->
		$.each response, (i, result) ->
			Dashboard.calculateSingleMeasure(result)
	calculateSingleMeasure: (result) ->
		row = Dashboard.measureRow(result.measure_id, result.sub_id)
		row.fadeTo("fast", 1.0)
		Render.percent row.find("div.measureProviderPopulationPercentage"), result
		Render.barChart row.find("div.tableBar"), result
		Render.fraction row.find("td.fraction"), result
	measureRow: (measure, sub_id) ->
		selector = "tr.measure[data-measure='#{measure}']"
		selector += "[data-measure-sub='#{sub_id || ''}']" if sub_id?
		$(selector)
	measureRows: (measure) ->
		return $("tr.measure[data-measure='#{measure}']")
	fadeIn: (measure) -> 
		Dashboard.measureRows(measure).fadeTo("fast", 0.5)
		$.post("/measure/#{measure}/select", {})
	fadeOut: (measure) -> 
		Dashboard.measureRows(measure).fadeOut("fast")
		$.post("/measure/#{measure}/remove", {})
	calculateSelected: ->
		$(".measureProviderPopulationPercentage").html("<div><div class='jobLabel'></div><img src='/assets/loading.gif'/></div>")
		$(".numeratorValue").html('0')
		$(".denominatorValue").html('0')
		$("div.measureItemList ul li.checked").each (i, m) ->
			measureId = $(m).attr("data-measure-id")
			qr = new QualityReport(measureId)
			Dashboard.measureRows(measureId).fadeTo("fast", 0.5)
			params = {}
			params['npi'] = Page.npi
			qr.poll params, Page.onReportComplete
	onLoad: ->
		Page.onMeasureSelect = (measure) ->
			Dashboard.measureRow(measure).prevAll(".headerRow").first().show()
			Dashboard.fadeIn(measure)
		Page.onMeasureRemove = (measure) -> 
			Dashboard.fadeOut(measure)
			measureRow = Dashboard.measureRow(measure).first()
			Dashboard.measureRow(measure).prevAll(".headerRow").first().hide() if measureRow.prevUntil(".headerRow", ":not([data-measure='#{measure}']):visible").length == 0 && measureRow.nextUntil(".headerRow", ":not([data-measure='#{measure}']):visible").length == 0
			
		Page.onReportComplete = (result, complete) -> 
			if (complete)
				Dashboard.calculateMeasure(result)
			else
				$.each result, (i, data) ->
					if data.job?
						row = Dashboard.measureRow(data.job.measure_id, data.job.sub_id)
						if (data.job.status != 'failed')
							row.find('.jobLabel').text(data.job.status)
						else
							row.find('.jobLabel').parent().html(data.job.status)
					else
						Dashboard.calculateSingleMeasure(data)
				
		$('#btnExportReport').click(Dashboard.exportReport);
		$('#btnExportReportSingle').click(Dashboard.doReportExport);
		$('#btnMeasurementPeriodChange').click(Dashboard.changeMeasurePeriod);
		$('#measurementPeriodEndDate').calendricalDate({usa: true, changed: Dashboard.updatePeriodEnd});
		$('.dialog-menu li a').hover((-> $(this).addClass('ui-state-hover')) , (-> $(this).removeClass('ui-state-hover')))
		Page.onFilterChange = (li) ->
			Dashboard.calculateSelected()
		Dashboard.calculateSelected()
  
  exportMenuHasMouse: false
	exportReport: ->
    position = $(this).offset()
    dialog = $( "#generate-menu" ).dialog({ position: [position.left+5, (position.top + $(this).height() + 10 - $(window).scrollTop())], resizable: false, dialogClass: 'dialog-menuwindow', minWidth: false, minHeight: false, width: 170 }).css('padding', '2px');
    dialog.hover((-> Dashboard.exportMenuHasMouse=false), (-> dialog.dialog('close'); Dashboard.exportMenuHasMouse=true) )
    $('#btnExportReport').hover((->), (-> setTimeout((-> dialog.dialog('close') if (Dashboard.exportMenuHasMouse) ), 600) ) )
    $('.dialog-menu li').click -> 
      dialog.dialog('close')
      Dashboard.exportMenuHasMouse=false
      Dashboard.doReportExport(null, $(this).data('type'))
  
	doReportExport: (event, type) ->
    type or= 'provider'
    providers = ActiveFilters.providers()
    providerParams = ''
    if (providers['provider[]'])
      providerParams = "&#{$.param(providers)}"
    window.location.href="/measures/measure_report.xml?type=#{type}#{providerParams}"
	  
	changeMeasurePeriod: ->
    effective_date = $('#measurementPeriodEndDate').val();
    period = {"effective_date": effective_date, "persist": true};
    npi = $(this).data('npi')
    $.post("/measures/period", {"effective_date": effective_date, "persist": true}, (data) ->
      $('#measurementPeriodStartDate').text(data.start)
      npiParam = ''
      npiParam = "?npi=#{npi}" if (npi)
      window.location.href="/measures"+npiParam
    , 'json')
        
  updatePeriodEnd: (selected) -> 
    effective_date = $('#measurementPeriodEndDate').val();
    $.post("/measures/period", {"effective_date": effective_date, "persist": false}, (data) ->
      $('#measurementPeriodStartDate').text(data.start)
#      window.location.href="/measures"
    , 'json')

      
}