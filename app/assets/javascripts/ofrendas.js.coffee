# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this

jQuery ->
  count = 0;


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



