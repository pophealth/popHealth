class Thorax.Views.ProviderView extends Thorax.View
  template: JST['providers/show']
  initialize: ->
    @dashboardView = new Thorax.Views.Dashboard provider_id: @model.id, collection: new Thorax.Collections.Categories PopHealth.categories, parse: true, effectiveDate: PopHealth.currentUser.get 'effective_date'
    if PopHealth.currentUser.shouldDisplayProviderTree() then @providerChart = PopHealth.viz.providerChart()
    @startDate = PopHealth.currentUser.effectiveDateString(false)
  context: ->
    _(super).extend
      providerType: @model.providerType() || ""
      providerExtension: @model.providerExtension() || ""
      npi: @model.npi() || ""
      patient_count: @model.get('patient_count')
  events:
    'click .effective-date-btn' : 'setEffectiveDate'
    rendered: ->
      if @model.isPopulated()
        d3.select(@el).select("#providerChart").datum(@model.toJSON()).call(@providerChart)
        @$('.node').popover()
    model:
      change: ->
          @dashboardView.filterEHMeasures(@model.providerType() == Config.ehExclusionType)
  setEffectiveDate: (e) ->
    effectiveDate = $(".effective-date-picker").val()
    user = PopHealth.currentUser.get 'username'
    $.post "home/set_reporting_period", {"effective_date": effectiveDate, "username": user}, (d) -> location.reload()

# Layout for provider index; includes search bar and provider table
class Thorax.Views.ProvidersView extends Thorax.View
  template: JST['providers/index_layout']
  events:
    'keyup .provider-search' : 'search'
    'click .clear-search' : 'clearSearch'
  initialize: ->
    @providers = new Thorax.Views.ProvidersIndex collection: new Thorax.Collections.Providers
  search: (e) ->
    $sb = $(e.target)
    query = $.trim($sb.val())
    $(".providerTable tr").show() # show everything
    if query.length > 0
      $(".providerTable tbody tr:not(:containsi(#{query}))").hide()
    else
      $(".providerTable tr").show()

  clearSearch: (e) ->
    $sb = $(e.target).parent().prev('.provider-search')
    $sb.val('').trigger('keyup')

# Provider table
class Thorax.Views.ProvidersIndex extends Thorax.View
  tagName: 'table'
  className: "table table-hover"
  template: JST['providers/index']
  fetchTriggerPoint: 500 #Fetch data when we're 500 pixels away from the bottom
  itemContext: (model, index) ->
    _.extend {}, model.attributes, providerType: model.providerType() || "", providerExtension: model.providerExtension() || "", npi: model.npi(), admin: (PopHealth.currentUser.get("admin") && !Config.OPML)
  events:
    rendered: ->
      $(document).on 'scroll', @scrollHandler
    destroyed: ->
      $(document).off 'scroll', @scrollHandler
    collection:
        sync: -> @isFetching = false
  initialize: ->
    @admin = (PopHealth.currentUser.get("admin") && !Config.OPML)
    @isFetching = false
    @scrollHandler = =>
      distanceToBottom = $(document).height() - $(window).scrollTop() - $(window).height()
      if !@isFetching and @collection?.length and @fetchTriggerPoint > distanceToBottom
        @isFetching = true
        @collection.fetchNextPage()
