@Providers = {
	updateAggregate: (current_measure, sub_id) ->
		@isPollRequestActive = true
		Providers.isLoading()
		qr = new QualityReport(current_measure, sub_id)
		ref = this
		qr.poll {}, (results) ->
			if (results.complete)
				result = results.result[0]
				Render.percent $("#measureMetrics #measurePopulationPercentage"), result
				Render.fraction $("#measureMetrics div.inline-fraction"), result
				ref.isPollRequestActive = false
				Providers.isLoading()
			else
				$.each results, (i, data) ->
					if (data.job && data.job.status == 'failed')
						ref.isPollRequestActive = false
						Providers.isLoading()
						$('#measurePopulationPercentage').text('failed')
	updateProviders: (current_measure, sub_id) ->
		$(".measureProviderPopulationPercentage").html("<div><div class='jobLabel'></div><img src='#{rootContext}/assets/loading.gif'/></div>")
		$(".numeratorValue").html('0')
		$(".denominatorValue").html('0')
		pr = new ProvidersReport(current_measure, sub_id)
		provider_ids = _.map $("tr.provider"), (provider) ->
			return $(provider).data("provider")
		pr.poll {provider: provider_ids}, Page.onReportComplete
	row: (id) ->
		$("div.provider[data-provider='" + id + "']")
	onFilterChange: (current_measure, sub_id) ->
		return (li) ->
			if $(li).data("filter-type") is "provider" || $(li).hasClass("providerSelectAll" || $(li).data("filter-type") is "team")
				Providers.row($(li).data("filter-value")).fadeToggle "fast"
				Providers.updateAggregate(current_measure, sub_id)
				
			else
				Providers.fadeOut();
				Providers.updatePage(current_measure, sub_id)
	fadeOut: ->
		$("#providers div.provider:visible").fadeTo("fast", 0.5)
	onLoad: (current_measure, sub_id) ->
		Page.onFilterChange = Providers.onFilterChange(current_measure, sub_id);
		Page.onReportComplete = (results) -> 
			
			if (results.complete)
				$(results.result).each (i, result) ->

					providers = result.filters.providers
					if providers
						row = $(Providers.row(providers[0]))
						Render.percent row.find(".measureProviderPopulationPercentage"), result
						Render.fraction row, result
						row.fadeTo("fast", 1.0)
			else
				$.each results, (i, data) ->
					providerId = data.job.filters.providers[0] if data.job
					row = Providers.row(providerId)
					if (data.job)
						if (data.job.status != 'failed')
							row.find('.jobLabel').text(data.job.status)
						else
							row.find('.jobLabel').parent().html(data.job.status)
		Providers.fadeOut();
		Providers.updatePage(current_measure, sub_id);
	updatePage: (current_measure, sub_id) ->
		Providers.updateProviders(current_measure, sub_id)
		Providers.updateAggregate(current_measure, sub_id)
	isLoading: ->
		if @isPollRequestActive
			$("div#measureMetrics").fadeTo "fast", 0.25, ->
			$("#loadingAggregate").show()
		else
			$("#loadingAggregate").hide()
			$("div#measureMetrics").fadeTo "fast", 1.0, ->
			
}

class @ProvidersReport extends QualityReport
	constructor: (measure, sub_id) ->
		super(measure, sub_id)
	url: -> "#{super()}/providers.json"
