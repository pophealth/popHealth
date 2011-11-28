@Dashboard = {
	calculateMeasure: (response) ->
		$.each response, (i, result) ->
			row = Dashboard.measureRow(result.measure_id, result.sub_id)
			Render.percent row.find("div.measureProviderPopulationPercentage"), result
			Render.barChart row.find("div.tableBar"), result
			Render.fraction row.find("td.fraction"), result
	measureRow: (measure, sub_id) ->
		return $("tr.measure[data-measure='#{measure}'][data-measure-sub='#{sub_id || ''}']")
	measureRows: (measure) ->
		return $("tr.measure[data-measure='#{measure}']")
	fadeIn: (measure) ->  
		Dashboard.measureRows(measure).fadeIn("fast")
	fadeOut: (measure) -> 
		Dashboard.measureRows(measure).fadeOut("fast")
		$.post("/measure/#{measure}/remove", {})
	calculateSelected: ->
		$("div.measureItemList ul li.checked").each (i, m) ->
			measureId = $(m).attr("data-measure-id")
			qr = new QualityReport(measureId)
			qr.poll {}, (result) ->
				Dashboard.calculateMeasure(result)
	onLoad: ->
		Page.onMeasureSelect = (measure) -> Dashboard.fadeIn(measure)
		Page.onMeasureRemove = (measure) -> Dashboard.fadeOut(measure)
		Page.onReportComplete = (result) -> Dashboard.calculateMeasure(result)
		$('#btnExportReport').click(Dashboard.exportReport);
		$('#btnMeasurementPeriodChange').click(Dashboard.changeMeasurePeriod);
		$('#measurementPeriodEndDate').calendricalDate({usa: true, changed: Dashboard.updatePeriodEnd});
		$('.dialog-menu li a').hover((-> $(this).addClass('ui-state-hover')) , (-> $(this).removeClass('ui-state-hover')))
		Page.onFilterChange = (li) ->
			Dashboard.calculateSelected()
		Dashboard.calculateSelected()
  
  exportMenuHasMouse: false
	exportReport: ->
    #window.location.href="/measures/measure_report.xml";
    position = $(this).offset()
    dialog = $( "#generate-menu" ).dialog({ position: [position.left+5, position.top + $(this).height() + 10], resizable: false, dialogClass: 'dialog-menuwindow', minWidth: false, minHeight: false, width: 170 }).css('padding', '2px');
    dialog.hover((-> Dashboard.exportMenuHasMouse=false), (-> dialog.dialog('close'); Dashboard.exportMenuHasMouse=true) )
    $('#btnExportReport').hover((->), (-> setTimeout((-> dialog.dialog('close') if (Dashboard.exportMenuHasMouse) ), 600) ) )
    $('.dialog-menu li').click -> 
      dialog.dialog('close')
      Dashboard.exportMenuHasMouse=false
      window.location.href="/measures/measure_report.xml?type=#{$(this).data('type')}"
	  
	changeMeasurePeriod: ->
    effective_date = $('#measurementPeriodEndDate').val();
    period = {"effective_date": effective_date, "persist": true};
    $.post("/measures/period", {"effective_date": effective_date, "persist": true}, (data) ->
      $('#measurementPeriodStartDate').text(data.start)
      window.location.href="/measures"
    , 'json')
        
  updatePeriodEnd: (selected) -> 
    effective_date = $('#measurementPeriodEndDate').val();
    $.post("/measures/period", {"effective_date": effective_date, "persist": false}, (data) ->
      $('#measurementPeriodStartDate').text(data.start)
#      window.location.href="/measures"
    , 'json')

      
}