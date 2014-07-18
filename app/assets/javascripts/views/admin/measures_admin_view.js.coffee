class Thorax.Views.MeasuresAdminView extends Thorax.View
  template: JST['admin/measures']
  _measures: []
  initialize: ->
    _this = this
    $.ajax(url: "/api/measures",
    type: 'get',
    success: (res)->
       _this.parseMeasures(res)
    ,
    error: (res)->
      _this.displayError(res)
    ,
    cache: false,
    contentType: false,
    processData: false
    )

  parseMeasures: (json) ->
    _measures = []
    for mes in json
      if !mes.sub_id || mes.sub_id == 'a'
        _measures.push(mes)
    this.measures = _measures
    @pleaseWaitDialog.modal("hide") if @pleaseWaitDialog
    this.render(@template)

  importMeasure: (event) ->
    importMeasureView = new Thorax.Views.ImportMeasure(firstMeasure: true)
    importMeasureView.appendTo(@$el)
    importMeasureView.display()

  editMeasure: (event) ->
    measure = null
    for mes in @measures
      measure = mes if mes.hqmf_id == event.target.id
    if measure
      editMeasureView = new Thorax.Views.EditMeasureView(measure)
      editMeasureView.parent = @
      editMeasureView.appendTo(@$el)
      editMeasureView.display()


  handleDelete: (e)->
    _this = @
    $.ajax(url: "/api/measures/"+e.target.id,
    type: 'delete',
    beforeSend: ->
      console.log("before send")
    ,
    success: (res)->
      console.log("success")
      location.reload(true)
    ,
    error: (res)->
      console.log("error")
      _this.displayError(res)
    ,
    cache: false,
    contentType: false,
    processData: false
    )

  displayError: (res) ->
    @finalizeDialog.modal("hide") if @finalizeDialog
    @pleaseWaitDialog.modal("hide") if @pleaseWaitDialog
    @errorDialog =new Thorax.Views.ErrorDialog({error: {title: "Error", summary: "Error deleting measure", body: res.responseText}})
    @errorDialog.appendTo(@el.parentNode)
    @errorDialog.display()

class Thorax.Views.EditMeasureView extends Thorax.View
  template: JST['admin/edit_measure']
  events:
    'ready': 'setup',
    'submit #edit_measure_form': 'saveToModel',
    'change #measureResultMeaningSelect' : 'update_lower_is_better'

  initialize: ->
    @categories = new Thorax.Collections.Categories PopHealth.categories, parse: true

  setup: ->
    @editDialog = @$("#editMeasureDialog")
    @wait = @$("#pleaseWaitDialog")

  lowerIsSet: -> @lower_is_better != null

  higher_is_better: -> @lowerIsSet() and !@lower_is_better

  categoryContext: (cat) ->
    selectedCategory = cat.get('category') == @category
    _(cat.toJSON()).extend selected: selectedCategory

  update_lower_is_better: (event) ->
    @$("#lower_is_better")[0].value=event.target.value

  saveToModel: ->
    formData = new FormData($('form')[0]);
    _this = @
    $.ajax( url: @$("form").attr('action'),
    type: 'POST',
    success: (res)->
      location.reload(true)
      _this.wait.modal('hide')
    ,
    error: (res)->
      _this.wait.modal('hide')
      _this.parent.displayError(res)
    ,
    data: formData,
    cache: false,
    contentType: false,
    processData: false
    )
    false

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
