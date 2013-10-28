class PopHealth.Measure extends Backbone.Model
  urlRoot: "/measures"
  report: ->
    console.log('polling')
    setTimeout => @report
    3000
    # fetch()
    # ref = this
    # this.fetch params, (response) ->
    #   uuids={}
    #   $.each response.jobs, (i, job) ->
    #     sub_id = ''
    #     sub_id = job['sub_id'] if job['sub_id']
    #     uuids[job['measure_id'] + sub_id] = job['uuid']
    #   pollParams = $.extend(params, {jobs: uuids})
    #   callback(response.result, response.complete)
    #   if (!response.complete && !response.failed)
    #     setTimeout (-> ref.poll(pollParams, callback)), 3000

class PopHealth.SelectedMeasures extends Backbone.Collection
	initialize: ->
    @on "add", @query, @
  model: PopHealth.Measure
  query: (measure) -> measure.report()


    
