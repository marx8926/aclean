# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  count = 0;
  HorarioTable = $('#horario').dataTable
    "aoColumns": [{"mDataProp": "dia"},{"mDataProp": "hora"},{"mDataProp": "btn_elim"}]
    "bPaginate": false
    "sDom": "<r>t<'row-fluid'>"
    "fnCreatedRow": (  nRow, aData, iDisplayIndex ) ->
      $(nRow).find('.delete-row').click (e) ->
        index = $(HorarioTable.fnGetData()).getIndexObj aData, 'id'
        HorarioTable.fnDeleteRow index

  $('#addhorario').click ->
    btn_elim = '<a class="delete-row" data-original-title="Delete" href="#"><img alt="trash" src="http://d9i0z8gxqnxp1.cloudfront.net/img/trash-icon.png"></a>'
    horario = { "dia":$("#dia").val(), "hora" :$("#hora").val(), "btn_elim":btn_elim, "id":count}
    HorarioTable.fnAddData horario
    count++

  $("#servicio").hide()

  $('#registrar').click ->
    $("#servicio").toggle()