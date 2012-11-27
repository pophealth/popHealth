class @QualityReport
	constructor: (@measure, @sub_id, @filters) ->
		@sub_id or= null
		@filters or= ActiveFilters.all()
	url: -> 
		base = "#{rootContext}/measure/#{@measure}"
		if @sub_id? then "#{base}/#{@sub_id}" else base
	fetch: (extraParams, callback) ->
		params = $.extend({}, @filters, extraParams)
		$.getJSON this.url(), $.extend({}, @filters, params), (data) -> 
			callback(data)
	poll: (params, callback) ->
		this.fetch params, (response) =>
			uuids={}
			$.each response.jobs, (i, job) =>
				sub_id = ''
				sub_id = job['sub_id'] if job['sub_id']
				uuids[job['measure_id'] + sub_id] = job['uuid']
			pollParams = $.extend(params, {jobs: uuids})

			callback(response)
			if (!response.complete && !response.failed)
				setTimeout (=> @poll(pollParams, callback)), 3000

@Page = {
	onMeasureSelect: (measure_id) ->
	onMeasureRemove: (measure_id) ->
	onFilterChange: (qr, li) ->
	onReportComplete: (qr) ->
	onLoad: ->
	params: {}
}

@ActiveFilters = {
	all: ->
		ActiveFilters.findFilters(".filterItemList input:checked:not(:disabled)")
	providers: ->
		ActiveFilters.findFilters(".filterItemList input:checked:not(:disabled)[data-filter-type='provider']")
	nonProvider: ->
		ActiveFilters.findFilters(".filterItemList input:checked:not([data-filter-type='provider'])")
	findFilters: (selector) ->
		filterElements = _.map $(selector), (el) -> type: $(el).data("filter-type"), value: $(el).data("filter-value")
		filters = _.reduce filterElements, (memo, filter) ->
			if filter.type?
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
		percent = if (data.denominator == 0 || data.denominator == undefined) then 0 else  (data.numerator / data.denominator) * 100
		selector.html("#{Math.floor(percent)}%")	
}

@makeMeasureListClickable = ->
	$("a.measure-group").focus ->
		$("a.measure-group:visible").popover("hide")
		$

	$(".measureItemList input").on "change", ->
		console.log('go')
		measure = $(this).attr("data-measure-id")
		subs = $(this).data("sub-measures")
		sub_ids = if subs? then subs.split(",") else [null]
		if $(this).attr("checked")
			Page.onMeasureSelect(measure)
			$.each sub_ids, (i, sub) ->
				qr = new QualityReport(measure, sub)
				qr.poll({npi: Page.npi}, Page.onReportComplete)
		else
			Page.onMeasureRemove(measure)
@makeFilterListsClickable = ->
	$("ul input.all").change ->
		filterList = $(@).parents("ul").filter(":first")
		allSelected = $(@).attr("checked")?
		$.each filterList.find("input:not(.all)"), (i, filter) =>
			$(filter).attr("checked", true)	
			$(filter).attr("disabled", $(@).attr("checked")?)
	$(".filterItemList li input").change ->
		Page.onFilterChange(@)


	
# Load Page
$ ->
	makeMeasureListClickable()
	makeFilterListsClickable()
	# makeListsExpandable()
	Page.onLoad();
