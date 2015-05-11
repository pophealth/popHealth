$ ->       
  @teamProviderTable = $('.teamProviderTable').dataTable({
    "order" : [2,'desc'],
    paging: false,
    scrollY: "300px",
  })

  $('.teamSaveBtn').on 'click', { table: @teamProviderTable }, (e)->
    e.data.table.fnFilter ''
