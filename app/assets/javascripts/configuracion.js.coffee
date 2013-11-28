# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $(".wizard").bwizard()
  
  ubigeos = getAjaxObject "https://s3.amazonaws.com/adminchurchs3/json/ubi.json"
  cargarUbigeo ubigeos, "distrito", "provincia", "departamento"

# guardar lugar

# Proceso para enviar metodo Post

# 1. Preparar Datos

  # Datos para enviar en formato JSON
  PrepararDatosL = ->
    root.DatosEnviar = $("#form_lugar").serialize()
      
  # Funcion de respuesta CORRECTA
  # Los datos de respuesta se reciben en data
  SuccessFunction = ( data ) ->
    #recargar datos de tabla Servicios
    #ServiciosTable.fnReloadAjax "/configuracion/recuperar_servicio"
    #resetear formulario
    $("#form_lugar").reset()
    #reniciar tabla
    #HorarioTable.fnClearTable()
    #mostrar datos de respuesta
    console.log(data)

# 2. Enviar Datos
  $("#btnGuardar_Lugar").click (e) ->
    #Llamada a preparar Datps
    PrepararDatosL()
    #Llamada a envio Post
    enviar "/configuracion/guardar_lugar", root.DatosEnviar, SuccessFunction, null

# Fin Proceso enviar Formulario
      
    #act on result.
    false # prevents normal behaviour
        
