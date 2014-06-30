class Thorax.Views.FinalizeMeasureView extends Thorax.View
  template: JST['import/finalize_measures']

  context: ->
    titleSize: 3
    dataSize: 9
    token: $("meta[name='csrf-token']").attr('content')

  events:
     'ready': 'setup'
     'click #finalizeMeasureSubmit': 'submit'
     'change select':  'enableDone'
     'submit #finalize_measure_form': 'saveToModel'

  saveToModel: ->
    formData = new FormData(@$('form')[0]);
    _this = @
    $.ajax( url: @$("form").attr('action'),
    type: 'POST',
    success: (res)-> 
      location.reload(true)
    ,
    error: (res)-> 
      _this.displayError(res)
    ,
    data: formData,
    cache: false,
    contentType: false,
    processData: false
    )
    false
       
  displayError: (res) ->
    @finalizeDialog.modal("hide") if @finalizeDialog
    @pleaseWaitDialog.modal("hide") if @pleaseWaitDialog
    @errorDialog =new Thorax.Views.ErrorDialog({error: {title: "Error", summary: "Error finailizing measure", body: res.responseText}})
    @errorDialog.appendTo(@el.parentNode)
    @errorDialog.display()
    
  enableDone: ->
    selects = (@$(s).val()?.length > 0 for s in @$('select'))
    @$('#finalizeMeasureSubmit').prop('disabled', false in selects)

  setup: ->
    # if we have no measures to finalize than there's nothing to do
      @finalizeDialog = @$("#finalizeMeasureDialog")
      @pleaseWaitDialog = @$("#pleaseWaitDialog")

  display: ->
    @$('#finalizeMeasureSubmit').prop('disabled', @$('select').length > 0)
    @finalizeDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true).find('.modal-dialog').css('width','650px')

  submit: ->
    @finalizeDialog.modal('hide')
    @pleaseWaitDialog.modal(
      "backdrop" : "static",
      "keyboard" : false,
      "show" : true)
    @$('form').submit()

  
