class Thorax.Views.ProviderView extends Thorax.View
  template: JST['providers/show']
  initialize: ->
    @dashboardView = new Thorax.Views.Dashboard provider_id: @model.id, collection: new Thorax.Collections.Categories PopHealth.categories, parse: true, datesobj: 
      effectiveDate: PopHealth.currentUser.get 'effective_date'
      effectiveStartDate: PopHealth.currentUser.get 'effective_start_date'
    if PopHealth.currentUser.shouldDisplayProviderTree() 
      @providerChart = PopHealth.viz.providerChart()
    else
      @providerChart = null    
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
      if @model.isPopulated() and @providerChart != null
        d3.select(@el).select("#providerChart").datum(@model.toJSON()).call(@providerChart)
        @$('.node').popover()
    model:
      change: ->
          @dashboardView.filterEHMeasures(@model.providerType() == Config.ehExclusionType)
  setEffectiveDate: (e) ->
    effectiveStartDate = $(".effective-date-picker.start").val()
    effectiveDate = $(".effective-date-picker.end").val()
    if Date.parse(effectiveDate) <= Date.parse(effectiveStartDate)
      return alert("That date range is invalid. Please check and try again.")   
    if confirm("Caution! Changing the reporting period may initially cause a significant delay. Do you wish to continue?")
      user = PopHealth.currentUser.get 'username'
      $.post "home/set_reporting_period", {"effective_start_date": effectiveStartDate, "effective_date": effectiveDate, "username": user}, (d) -> location.reload()

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
