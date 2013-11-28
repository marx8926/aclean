# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this

jQuery ->
  count = 0;


# Proceso para enviar metodo Post


  # Funcion de respuesta CORRECTA
  # Los datos de respuesta se reciben en data
  SuccessFunction = ( data ) ->
    #recargar datos de tabla Servicios
    #ServiciosTable.fnReloadAjax "/configuracion/recuperar_servicio"
    #resetear formulario
    $("#form_ofrenda").reset()
    #reniciar tabla
    #HorarioTable.fnClearTable()
    #mostrar datos de respuesta
    console.log(data)

# 2. Enviar Datos
  $("#btnGuardar_Ofrenda").click (e) ->
    #Llamada a preparar Datps
    #PrepararDatos()
    #Llamada a envio Post
    enviar "/configuracion/guardar_servicio", $("#form_ofrenda").serialize() , SuccessFunction, null

# Fin Proceso enviar Formulario
      
    #act on result.
    false # prevents normal behaviour
