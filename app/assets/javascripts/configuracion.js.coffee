# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this

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
                              { "sWidth": "15%","mDataProp": "int_servicio_tipo_desc"},
                              { "sWidth": "15%","mDataProp": "int_servicio_tipo"},
                              { "sWidth": "10%","mDataProp": "int_servicio_tipo"}
                              ]

  ServiciosTable = $('#tablaservicios').dataTable
    "bProcessing": true
    "bServerSide": false
    "bDestroy": true
    "sAjaxSource": "/configuracion/recuperar_servicio"
    "aoColumns": FormatoServiciosTable
    "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span12'i><'span12 center'p>>"

  $('#addhorario').click ->
    btn_elim = '<a class="delete-row" data-original-title="Delete" href="#"><img alt="trash" src="http://d9i0z8gxqnxp1.cloudfront.net/img/trash-icon.png"></a>'
    horario = { "dia":$("#dia").val(), "hora" :$("#hora").val(), "btn_elim":btn_elim, "id":count}
    HorarioTable.fnAddData horario
    count++

  $("#servicio").hide()

  $('#registrar').click ->
    $("#servicio").toggle()

# Proceso para enviar metodo Post

# 1. Preparar Datos

  # Datos para enviar en formato JSON
  PrepararDatos = ->
    root.DatosEnviar =
      "formulario" : $("#formServicio").serializeObject()
      "otherdata" : HorarioTable.fnGetData()

  # Funcion de respuesta CORRECTA
  # Los datos de respuesta se reciben en data
  SuccessFunction = ( data ) ->
    #recargar datos de tabla Servicios
    ServiciosTable.fnReloadAjax "/configuracion/recuperar_servicio"
    #resetear formulario
    $("#formServicio").reset()
    #reniciar tabla
    HorarioTable.fnClearTable()
    #mostrar datos de respuesta
    console.log(data)

# 2. Enviar Datos
  $("#btnGuardar_Servicio").click (e) ->
    #Llamada a preparar Datps
    PrepararDatos()
    #Llamada a envio Post
    enviar "/configuracion/guardar_servicio", root.DatosEnviar, SuccessFunction, null

# Fin Proceso enviar Formulario
      
    #act on result.
    false # prevents normal behaviour

        
