class Thorax.Views.MeasuresAdminView extends Thorax.View
  template: JST['admin/measures']
  fetchTriggerPoint: 500 # fetch data when we're 500 pixels away from the bottom
  events:
    rendered: ->
      $(document).on 'scroll', @scrollHandler
    destroyed: ->
      $(document).off 'scroll', @scrollHandler
    collection:
      sync: -> @isFetching = false

  initialize: ->
    @isFetching = false
    @scrollHandler = =>
      distanceToBottom = $(document).height() - $(window).scrollTop() - $(window).height()
      if !@isFetching and @collection?.length and @fetchTriggerPoint > distanceToBottom
        @isFetching = true
        @collection.fetchNextPage()

  importMeasure: (event) ->
    importMeasureView = new Thorax.Views.ImportMeasure(firstMeasure: true)
    importMeasureView.appendTo(@$el)
    importMeasureView.display()

  editMeasure: (e) ->
    measure = $(e.target).model()
    editMeasureView = new Thorax.Views.EditMeasureView model: measure
    editMeasureView.parent = @
    editMeasureView.appendTo(@$el)
    editMeasureView.display()


  handleDelete: (e) ->
    measure = $(e.target).model()
    measure.destroy(contentType: false, processData: false).fail (res) => @displayError res

  displayError: (res) ->
    @finalizeDialog.modal("hide") if @finalizeDialog
    @pleaseWaitDialog.modal("hide") if @pleaseWaitDialog
    @errorDialog =new Thorax.Views.ErrorDialog({error: {title: "Error", summary: "Error deleting measure", body: res.responseText}})
    @errorDialog.appendTo(@el.parentNode)
    @errorDialog.display()

class Thorax.Views.EditMeasureView extends Thorax.View
  template: JST['admin/edit_measure']
  events:
    'submit #edit_measure_form': 'saveToModel',
    'change #measureResultMeaningSelect' : 'update_lower_is_better',
    'change #measureCategorySelect' : 'show_hide_custom_category',
    'input #newMeasureCategoryInput' : 'update_measure_category_input'
    ready: 'setup'

  initialize: ->
    @categories = new Thorax.Collections.Categories PopHealth.categories, parse: true
    @$("#newMeasureCategoryInput")

  setup: ->
    @editDialog = @$("#editMeasureDialog")
    @wait = @$("#pleaseWaitDialog")
    @newMeasureInput = @$("#newMeasureCategoryInput").hide()
    @measureCategory = @$("#measure_category")[0]

  lowerIsNotSet: -> @lower_is_better == null

  higher_is_better: -> !@lowerIsNotSet() and !@lower_is_better

  categoryContext: (cat, index) ->
    selectedCategory = cat.get('category') == @model.get('category')
    isFirst = index == 0
    _(cat.toJSON()).extend selected: selectedCategory, first: isFirst

  update_lower_is_better: (event) ->
    @$("#lower_is_better")[0].value=event.target.value

  show_hide_custom_category: (event) ->
    if event.target.value == "New"
      @newMeasureInput.show()
      @measureCategory.value = ""
    else
      @newMeasureInput.hide()
      @measureCategory.value = event.target.value

  update_measure_category_input: (event) ->
    @measureCategory.value = event.target.value

  saveToModel: (e) ->
    e.preventDefault()
    formData = _(@serialize()).pick('hqmf_id', 'measure')
    # FIXME use @model.save()
    $.ajax
      url: @$("form").attr('action')
      type: 'POST'
      success: (res) =>
        location.reload(true)
        @wait.modal('hide')
      error: (res) =>
        @wait.modal('hide')
        @parent.displayError(res)
      data: formData
      cache: false

  display: ->
    @editDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  close: ->
    @editDialog.modal("hide")

  submit: ->
    @wait.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)
    @editDialog.modal('hide')
    @$('form').submit()
