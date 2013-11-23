class Thorax.Models.User extends Thorax.Model
  url: '/users' # no ID necessary, as this corresponds to the currently logged in user
  idAttribute: '_id'

  selectedCategories: (categories) ->
    selectedIds = @get('preferences').selected_measure_ids
    selectedCats = new categories.constructor
    categories.each (cat) ->
      selectedMeasures = cat.get('measures').select (m) -> _(selectedIds).contains m.id
      if selectedMeasures.length
        selectedCategory = cat.clone()
        selectedCategory.set 'measures', new Thorax.Collections.Measures selectedMeasures, parent: selectedCategory
        selectedCats.add selectedCategory

    selectedCats.selectMeasure = (measure) =>
      return if _(selectedIds).any (id) -> id is measure.id
      categoryName = measure.collection.parent.get('category')
      selectedCategory = selectedCats.findWhere category: categoryName
      unless selectedCategory?
        selectedCategory = new Thorax.Models.Category category: categoryName, measures: [], {parse: true}
        selectedCats.add selectedCategory
      selectedCategory.get('measures').add measure
      selectedIds.push measure.id
      @save()

    selectedCats.removeMeasure = (measure) =>
      idx = selectedIds.indexOf(measure.id)
      return unless idx > -1
      categoryName = measure.collection.parent.get('category')
      selectedCategory = selectedCats.findWhere category: categoryName
      measures = selectedCategory.get('measures')
      measures.remove measure
      selectedCats.remove(selectedCategory) if measures.isEmpty()
      selectedIds.splice idx, 1
      @save()

    selectedCats.selectCategory = (category) =>
      selectedCategory = selectedCats.findWhere category: category.get('category')
      unless selectedCategory?
        selectedCategory = new Thorax.Models.Category {category: category.get('category'), measures: []}, parse: true
        selectedCats.add selectedCategory
      selectedCategory.get('measures').reset category.get('measures').models
      @get('preferences').selected_measure_ids = _(selectedIds).union(category.get('measures').map (m) -> m.id)
      @save()

    selectedCats.removeCategory = (category) =>
      selectedCategory = selectedCats.findWhere category: category.get('category')
      selectedCats.remove selectedCategory
      @get('preferences').selected_measure_ids = _(selectedIds).difference(category.get('measures').map (m) -> m.id)
      @save()


    return selectedCats



# categories;

# # categories.getSelected() // Categories collection that's sorted, filtered

# # // when i remove or add to the selected, user.select(measure) / user.remove(measure) gets called


# user.getSelectedIds


# # category.on 'reset',
# category.on 'add', (measure) -> user.select(measure)
