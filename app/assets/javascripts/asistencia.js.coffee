# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this


$(document).ready ->
  $(".data-table").dataTable sPaginationType: "full_numbers"

count = 0

#inizializar asistenciatable

AsistenciaTable = $('#table_categoria_asistencia').dataTable
  "aoColumns": [{"mDataProp": "servicio"},{"mDataProp": "categoria"},{"mDataProp": "asistente"},{"mDataProp": "accion"}]
  "bPaginate": false
  "sDom": "<r>t<'row-fluid'>"
  "fnCreatedRow": (  nRow, aData, iDisplayIndex ) ->
    $(nRow).find('.delete-row').click (e) ->
      index = $(AsistenciaTable.fnGetData()).getIndexObj aData, 'id'
      AsistenciaTable.fnDeleteRow index


$('#agregar_asistentes').click ->
  btn_elim = '<a class="delete-row" data-original-title="Delete" href="#"><img alt="trash" src="http://d9i0z8gxqnxp1.cloudfront.net/img/trash-icon.png"></a>'

  fecha = $("#fecha").val()
  servicio = $("#_servicio option:selected").text()
  categoria = $("#categoria option:selected").text()
  asistente = $("#asistentes").val()

  numero = { "servicio": servicio, "categoria" : categoria , "asistente": asistente , "accion":btn_elim, "id":count, "servicioid": $("#_servicio").val(), "categoriaid": $("#categoria").val() }
  AsistenciaTable.fnAddData numero
  count++


 # 1. Preparar Datos

  # Datos para enviar en formato JSON
  PrepararDatosRegistrar = ->
    root.DatosEnviar =
      "formulario" : $("#form_asistencia").serializeObject()
      "tabla" : AsistenciaTable.fnGetData()

  # Funcion de respuesta CORRECTA
  # Los datos de respuesta se reciben en data
  SuccessFunctionRegistrar = ( data ) ->
    #recargar datos de tabla Servicios
    # ServiciosTable.fnReloadAjax "/configuracion/recuperar_servicio"
    #resetear formulario
    #$("#form_miembro").reset()
    #reniciar tabla
    #AsistenciaTable.fnClearTable()
    #mostrar datos de respuesta
    console.log(data)

  # 2. Enviar Datos
  $("#btnGuardar_Asistencia").click (event) ->
    event.preventDefault()
    #Llamada a preparar Datps
    PrepararDatosRegistrar()
    #Llamada a envio Post
    enviar "/asistencia_guardar", root.DatosEnviar, SuccessFunctionRegistrar, null

    # Fin Proceso enviar Formulario 