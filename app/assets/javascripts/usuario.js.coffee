
root = exports ? this

jQuery ->


#guardar usuario

# Proceso para enviar metodo Post

# 1. Preparar Datos

  # Datos para enviar en formato JSON
  PrepararDatosU = ->
    root.DatosEnviar = $("#form_usuario").serialize()
      
  # Funcion de respuesta CORRECTA
  # Los datos de respuesta se reciben en data
  SuccessFunctionU = ( data ) ->
    #recargar datos de tabla Servicios
    #ServiciosTable.fnReloadAjax "/configuracion/recuperar_servicio"
    #resetear formulario
    #$("#form_usuario").reset()

    #reniciar tabla
    #HorarioTable.fnClearTable()
    #mostrar datos de respuesta
    console.log(data)

# 2. Enviar Datos
  $("#btnGuardar_Usuario").click (e) ->
    #Llamada a preparar Datps
    PrepararDatosU()
    #Llamada a envio Post
    enviar "/configuracion/guardar_usuario", root.DatosEnviar, SuccessFunctionU, null

# Fin Proceso enviar Formulario
      
    #act on result.
    false # prevents normal behaviour