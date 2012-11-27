PopHealth.Utils =
  bootstrapCategories: (categories, measures, el) ->
    el.append(new PopHealth.CategorizedMeasuresView(collection: measures, categories: categories).render().el)
  bootstrapFilters: (filters, selected_measures) ->
    for category in _.keys(filters)
        collection = new PopHealth.FilterGroup(filters[category], {name: category})
        view = new PopHealth.MeasureSelectorGroupView(collection: collection, selected: selected_measures)
        $("#sidebar").append(view.render().el)
  bootstrapDemographics: (name, demographics) ->
    collection = new PopHealth.FilterGroup(demographics, {name: name})
    view = new PopHealth.DemographicsFilterGroupView(collection: collection)
    $("#main ul.nav-pills").append(view.render().el)
    
    