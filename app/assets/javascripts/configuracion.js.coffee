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

  FormatoServiciosTable = [   { "sWidth": "25%","mDataProp": "int_servicio_id"},
                              { "sWidth": "35%","mDataProp": "var_servicio_nombre"},
                              { "sWidth": "15%","mDataProp": "int_servicio_tipo"},
                              { "sWidth": "15%","mDataProp": "int_servicio_tipo"},
                              { "sWidth": "10%","mDataProp": "int_servicio_tipo"}
                              ]

  ServiciosTable = $('#tablaservicios').dataTable
    "bProcessing": true,
    "bServerSide": false,
    "bDestroy": true,
    "sAjaxSource": "/configuracion/recuperar_servicio",    
    "aoColumns": FormatoServiciosTable,               
    "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span12'i><'span12 center'p>>"

  $('#addhorario').click ->
    btn_elim = '<a class="delete-row" data-original-title="Delete" href="#"><img alt="trash" src="http://d9i0z8gxqnxp1.cloudfront.net/img/trash-icon.png"></a>'
    horario = { "dia":$("#dia").val(), "hora" :$("#hora").val(), "btn_elim":btn_elim, "id":count}
    HorarioTable.fnAddData horario
    count++

  $("#servicio").hide()

  $('#registrar').click ->
    $("#servicio").toggle()


  $("#btnGuardar_Servicio").click (e) ->
    $.ajax
      url: "/configuracion/guardar_servicio"
      type: "POST"
      dataType: "JSON"
      data:
        formulario: $("#formServicio").serialize()
        otherdata: HorarioTable.fnGetData()
      success: (msj) ->
        console.log msj
        ServiciosTable.fnReloadAjax "/configuracion/recuperar_servicio"

  
    #act on result.
    false # prevents normal behaviour

        
