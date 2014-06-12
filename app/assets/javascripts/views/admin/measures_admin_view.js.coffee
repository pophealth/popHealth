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
      console.log("error")
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
    'change #lower_is_better_cb' : 'update_lower_is_better'

  setup: ->
    @editDialog = @$("#editMeasureDialog")

  update_lower_is_better: (event) ->
    @$("#lower_is_better")[0].value=event.target.checked

  saveToModel: ->
    formData = new FormData($('form')[0]);
    _this = @
    $.ajax( url: @$("form").attr('action'),
    type: 'POST',
    success: (res)-> 
      console.log("success")
      location.reload(true) 
      _this.wait.modal('hide')
    ,
    error: (res)-> 
      console.log(res)
      _this.importWait.modal('hide')
      _this.displayError(res)
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
    @editDialog.modal('hide')
    @$('form').submit()