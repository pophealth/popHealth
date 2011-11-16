class @QualityReport
	constructor: (@measure, @sub_id, @filters) ->
		@sub_id or= null
		@filters or= ActiveFilters.all()
	url: -> 
		base = "/measure/#{@measure}"
		if @sub_id? then "#{base}/#{@sub_id}" else base
	fetch: (extraParams, callback) ->
		unless @result?
			params = $.extend({}, @filters, extraParams)
			$.getJSON this.url(), $.extend({}, @filters, params), (data) -> 
				callback(data)
	poll: (params, callback) ->
		ref = this
		this.fetch params, (data) ->
			if data?
				callback(data)
			else
				setTimeout (-> ref.poll(params, callback)), 4000

@Page = {
	onMeasureSelect: (measure_id) ->
		console.log("OnMeasureSelect placeholder")
	onMeasureRemove: (measure_id) ->
		console.log("OnMeasureRemove placeholder")
	onFilterChange: (qr, li) ->
		console.log("OnFilterChange placeholder")
	onReportComplete: (qr) ->
		console.log("OnReportComplete placeholder")
	onLoad: ->
		console.log("onLoad placeholder")
}

@ActiveFilters = {
	all: ->
		ActiveFilters.findFilters(".filterItemList li:not(.checked)")
	providers: ->
		ActiveFilters.findFilters(".filterItemList li.checked[data-filter-type='provider']")
	nonProvider: ->
		ActiveFilters.findFilters(".findFilterList li:not([data-filter-type='provider'])")
	findFilters: (selector) ->
		filterElements = _.map $(selector), (el) -> 
			type: $(el).data("filter-type"), value: $(el).data("filter-value")
		filters = _.reduce filterElements, (memo, filter) ->
			filter_key = "#{filter.type}\[\]"
			memo[filter_key] = [] unless memo[filter_key]?
			memo[filter_key].push(filter.value)
			return memo
		, {}
		return filters
}

@Render = {
	fraction: (selector, data) ->
		selector.find(".numeratorValue").html(data.numerator)
		selector.find(".denominatorValue").html(data.denominator)
	
	percent: (selector, data) -> 
		percent = if data.denominator == 0 then data.denominator else  (data.numerator / data.denominator)
		selector.html("#{Math.floor(percent)}%")
	
	barChart: (selector, data) ->
		numerator_width = 0
		denominator_width = 0
		if data.population != 0 && data.denominator != 0
			numerator_width = (data.numerator / data.population) * 100
			denominator_width = ((data.denominator - data.numerator) / data.population) * 100
			selector.children("div.tableBarNumerator").animate(width: "#{numerator_width}%")
			selector.children("div.tableBarDenominator").animate(width: "#{denominator_width}%")
}

makeListsExpandable = ->
	$(".groupList li label").click ->
		$(this).toggleClass("open")
		$(this).siblings("div.expandableList").toggle("blind")

makeMeasureListClickable = ->
	$(".measureItemList ul li").click ->
		$(this).toggleClass("checked")
		measure = $(this).attr("data-measure-id")
		if $(this).hasClass("checked") 
			Page.onMeasureSelect(measure)
			qr = new QualityReport(measure)
			qr.poll(-> Page.onReportComplete(qr))
		else
			Page.onMeasureRemoved(measure)

makeFilterListsClickable = ->
	$(".filterItemList ul li").click ->
		$(this).toggleClass("checked")
		Page.onFilterChange(this)
		
# Load Page
$ ->
	makeMeasureListClickable()
	makeFilterListsClickable()
	makeListsExpandable()
	Page.onLoad();
