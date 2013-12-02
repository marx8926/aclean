# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this

jQuery ->
  count = 0;

 FormatoServiciosTable = [   { "sWidth": "30%","mDataProp": "var_servicio_nombre"},
                              { "sWidth": "20%","mDataProp": "int_servicio_tipo_desc"},
                              { "sWidth": "30%","mDataProp": "turnoshow"},
                              { "sWidth": "20%","mDataProp": "var_servicio_acciones"}
                              ]

  ServiciosRowCB = (  nRow, aData, iDisplayIndex ) ->
    index = $(ServiciosTable.fnGetData()).getIndexObj aData, 'int_servicio_id'
    acciones = getActionButtons "111"
    ServiciosTable.fnUpdate( acciones, index, 3 ); 

ServiciosTable = createDataTable "dataOfremdas", root.SourceTServicio, FormatoServiciosTable, null, ServiciosRowCB

# Proceso para enviar metodo Post

# 1. Preparar Datos

  # Datos para enviar en formato JSON
  PrepararDatos = ->
    root.DatosEnviar = $("#form_ofrenda").serialize()
# Proceso para enviar metodo Post


  # Funcion de respuesta CORRECTA
  # Los datos de respuesta se reciben en data
  SuccessFunction = ( data ) ->
    #recargar datos de tabla Servicios
    #ServiciosTable.fnReloadAjax "/configuracion/recuperar_servicio"
    #resetear formulario
    $("#fecha").reset()
    $("#monto").reset()

    #reniciar tabla
    #HorarioTable.fnClearTable()
    #mostrar datos de respuesta
    console.log(data)

# 2. Enviar Datos
  $("#btnGuardar_Ofrenda").click (e) ->
    console.log "ofrenda"
    #Llamada a preparar Datps
    PrepararDatos()
    #Llamada a envio Post
    enviar "/ofrendas_guardar",  root.DatosEnviar , SuccessFunction, null

# Fin Proceso enviar Formulario
      
    #act on result.
    false # prevents normal behaviour

$('#ofrenda_div').hide()

$('#registrar_ofrenda').click ->
  $("#ofrenda_div").toggle()


cargar_turno = ->
  turnos = getAjaxObject "/recuperar_turno_inicio/"+$("#_servicio").val()
  cargarSelect turnos, "turno", "turno", "inicio"

$("#_servicio").change ->
  cargar_turno()
  
