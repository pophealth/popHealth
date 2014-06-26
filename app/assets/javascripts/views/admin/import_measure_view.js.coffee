class Thorax.Views.ImportMeasure extends Thorax.View
  template: JST['import/import_measure']

  context: ->
    currentRoute = Backbone.history.fragment
    _(super).extend
      titleSize: 3
      dataSize: 9
      token: $("meta[name='csrf-token']").attr('content')
      dialogTitle:  "New Measure"
      isUpdate: @model?
      showLoadInformation: true
      measureTypeLabel: null
      calculationTypeLabel: null
      hqmfSetId: null
      redirectRoute: currentRoute

  events:
    'ready': 'setup'
    'change input:file':  'enableLoad'
    'keypress input:text': 'enableLoadVsac'
    'keypress input:password': 'enableLoadVsac'
    'submit #measure_upload_form': 'saveToModel'
   
  saveToModel: ->
    formData = new FormData(@$('form')[0]);
    _this = @
    $.ajax( url: @$("form").attr('action'),
    type: 'POST',
    success: (res)-> 
      a = res
      if res["episode_ids"]
        _this.finalizeMeasure(res)
      else
        location.reload(true) 
      _this.importWait.modal('hide')
    ,
    error: (res)-> 
      _this.importWait.modal('hide')
      _this.displayError(res)
    ,
    data: formData,
    cache: false,
    contentType: false,
    processData: false
    )
    false
  
  finalizeMeasure: (res) ->
    @finalizeMeasureView = new Thorax.Views.FinalizeMeasureView(res)
    @finalizeMeasureView.appendTo(@el.parentNode)
    @finalizeMeasureView.display()

  displayError: (res) ->
    @importDialog.modal("hide") if @importDialog
    @importWait.modal("hide") if @importWait
    @finalizeDialog.modal("hide") if @finalizeMeasure
    @errorDialog =new Thorax.Views.ErrorDialog({error: {title: "Error", summary: "Error importing measure", body: res.responseText}})  
    @errorDialog.appendTo(@el.parentNode)
    @errorDialog.display()

  enableLoadVsac: ->
    username = @$('#vsacUser')
    password = @$('#vsacPassword')
    if (username.val().length > 0) 
      username.closest('.form-group').removeClass('has-error')
      hasUser = true
    if (password.val().length > 0) 
      password.closest('.form-group').removeClass('has-error')
      hasPassword = true
    @$('#loadButton').prop('disabled', !(hasUser && hasPassword)) 

  enableLoad: ->
    if @$('input:file').val().match /xml$/i
      @$('#vsacSignIn').removeClass('hidden')
    else
      @$('#vsacSignIn').addClass('hidden')
      @$('#loadButton').prop('disabled', !@$('input:file').val().length > 0)

  setup: ->
    @importDialog = @$("#importMeasureDialog")
    @importWait = @$("#pleaseWaitDialog")
    @finalizeDialog = @$("#finalizeMeasureDialog")
    @errorDialog = @$("#errorDialog")

  display: ->
    @importDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true)

  submit: ->
    @importWait.modal(
      "backdrop" : "static",
      "keyboard" : false,
      "show" : true)
    @importDialog.modal('hide')
    @$('form').submit()

  # FIXME: Is anything additional required for cleaning up this view on close?
  close: -> ''
