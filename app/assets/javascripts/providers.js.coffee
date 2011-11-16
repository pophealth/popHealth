@Providers = {
	updateAggregate: (current_measure, sub_id) ->
		Providers.isLoading()
		qr = new QualityReport(current_measure, sub_id)
		qr.poll {}, (result) ->
			Render.percent $("#aggregate #measurePopulationPercentage"), result
			Render.fraction $("#aggregate div.inline-fraction"), result
			$("div#measureMetrics").fadeTo "fast", 1.0, ->
				@isPollRequestActive = false
	updateProviders: (current_measure, sub_id) ->
		$("li[data-filter-type='provider']").each (i, el) ->
			pr = new ProvidersReport(current_measure, sub_id)
			pr.poll ActiveFilters.providers, (results) ->
						$(results).each (i, result) ->
							providerId = result.filters.providers[0]
							row = Providers.row(providerId)
							Render.percent $(row).find(".measureProviderPopulationPercentage"), result
							Render.fraction row, result
							Render.barChart row, result
	row: (id) ->
		$ "#providerTable tr[data-provider='" + id + "']"
	onFilterChange: (current_measure, sub_id) ->
		return (li) ->
			if $(li).data("filter-type") is "provider"
				Providers.row($(li).data("filter-value")).fadeToggle "fast"
			else
			Providers.updatePage(current_measure, sub_id)
	onLoad: (current_measure, sub_id) ->
		Providers.updatePage(current_measure, sub_id)
	updatePage: (current_measure, sub_id) ->
		Providers.updateProviders(current_measure, sub_id)
		Providers.updateAggregate(current_measure, sub_id)
	isLoading: ->
		if @isPollRequestActive
			$("div#measureMetrics").fadeTo "fast", 0.25, ->
				if isPollRequestActive
					$("#loadingAggregate").show()
				else
				$("div#measureMetrics").fadeTo "fast", 1.0, ->
}

class @ProvidersReport extends QualityReport
	constructor: (measure, sub_id) ->
		super(measure, sub_id)
	url: -> "#{super()}/providers.json"
	