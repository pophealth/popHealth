class Thorax.Models.User extends Thorax.Model
  url: '/users' # no ID necessary, as this corresponds to the currently logged in user
  idAttribute: '_id'

  maskStatus: -> @get('preferences').mask_phi_data
  shouldDisplayPercentageVisual: -> @get('preferences').should_display_circle_visual
  populationChartScaledToIPP: -> @get('preferences').population_chart_scaled_to_IPP
  shouldDisplayProviderTree: -> @get('preferences').should_display_provider_tree
  showAggregateResult: -> @get('preferences').show_aggregate_result
 
  setShowAggregateResult: (value) -> 
    @get('preferences').show_aggregate_result = value
    @save()

  effectiveDateString: (end) ->
    # if end is true, returns to date string. else it returns from date string
    if end
      d = new Date(@get('effective_end_date') *1000)
    else
      d = new Date(@get('effective_start_date') *1000)
    date = (d.getUTCMonth() + 1 ) + '/' + d.getUTCDate() + '/' + d.getUTCFullYear()

  setPopulationChartScale: (value) ->
    @get('preferences').population_chart_scaled_to_IPP = value
    @save()

  selectedCategories: (categories) ->
    selectedCats = new categories.constructor
    categories.each (cat) =>
      selectedMeasures = cat.get('measures').select (m) => _(@get('preferences').selected_measure_ids).contains m.get('hqmf_id')
      if selectedMeasures.length
        selectedCategory = cat.clone()
        selectedCategory.set 'measures', new Thorax.Collections.Measures selectedMeasures, parent: selectedCategory
        selectedCats.add selectedCategory

    selectedCats.selectMeasure = (measure) =>
      return if _(@get('preferences').selected_measure_ids).any (id) -> id is measure.get('hqmf_id')
      categoryName = measure.collection.parent.get('category')
      selectedCategory = selectedCats.findWhere category: categoryName
      isFreshlyAdded = not selectedCategory?
      if isFreshlyAdded
        selectedCategory = new Thorax.Models.Category category: categoryName, measures: [], {parse: true}
      selectedCategory.get('measures').add measure
      if isFreshlyAdded
        selectedCats.add selectedCategory
      @get('preferences').selected_measure_ids.push measure.get('hqmf_id')
      @save()

    selectedCats.removeMeasure = (measure) =>
      idx = @get('preferences').selected_measure_ids.indexOf(measure.get('hqmf_id'))
      return unless idx > -1
      categoryName = measure.collection.parent.get('category')
      selectedCategory = selectedCats.findWhere category: categoryName
      measures = selectedCategory.get('measures')
      measures.remove measure
      selectedCats.remove(selectedCategory) if measures.isEmpty()
      @get('preferences').selected_measure_ids.splice idx, 1
      @save()

    selectedCats.selectCategory = (category) =>
      selectedCategory = selectedCats.findWhere category: category.get('category')
      isFreshlyAdded = not selectedCategory?
      if isFreshlyAdded
        selectedCategory = new Thorax.Models.Category {category: category.get('category'), measures: []}, parse: true
      selectedCategory.get('measures').reset category.get('measures').models
      if isFreshlyAdded
        selectedCats.add selectedCategory
      @get('preferences').selected_measure_ids.push _(category.get('measures').pluck('hqmf_id')).difference(@get('preferences').selected_measure_ids)...
      @save()

    selectedCats.removeCategory = (category) =>
      selectedCategory = selectedCats.findWhere category: category.get('category')
      selectedCats.remove selectedCategory
      for id in category.get('measures').pluck('hqmf_id')
        idx = _(@get('preferences').selected_measure_ids).indexOf(id)
        @get('preferences').selected_measure_ids.splice(idx, 1) if idx > -1
      @save()


    return selectedCats



# categories;

# # categories.getSelected() // Categories collection that's sorted, filtered

# # // when i remove or add to the selected, user.select(measure) / user.remove(measure) gets called


# user.get@get('preferences').selected_measure_ids


# # category.on 'reset',
# category.on 'add', (measure) -> user.select(measure)

