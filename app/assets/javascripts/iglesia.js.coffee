jQuery ->


  ubigeos = getAjaxObject("https://s3.amazonaws.com/adminchurchs3/json/ubi.json")
  cargarUbigeo ubigeos, "distrito", "provincia", "departamento"

  
#guardar iglesia

# Proceso para enviar metodo Post

# 1. Preparar Datos

  # Datos para enviar en formato JSON
  PrepararDatosI = ->
    root.DatosEnviar = $("#form_iglesia").serialize()
      
  # Funcion de respuesta CORRECTA
  # Los datos de respuesta se reciben en data
  SuccessFunctionI = ( data ) ->
    #recargar datos de tabla Servicios
    #ServiciosTable.fnReloadAjax "/configuracion/recuperar_servicio"
    #resetear formulario
    $("#form_iglesia").reset()
    cargarUbigeo ubigeos, "distrito", "provincia", "departamento"
    #reniciar tabla
    #HorarioTable.fnClearTable()
    #mostrar datos de respuesta
    console.log(data)

# 2. Enviar Datos
  $("#btnGuardar_iglesia").click (e) ->
    #Llamada a preparar Datps
    PrepararDatosI()
    #Llamada a envio Post
    enviar "/configuracion/guardar_datos_generales", root.DatosEnviar, SuccessFunctionI, null

# Fin Proceso enviar Formulario
      
    #act on result.
    false # prevents normal behaviour


#recuperar datos json de personas

personas = getAjaxObject("/persona_servicio_complete")

$ ->
  $("#psn1").autocomplete(
    source: personas
    select: (event, ui) ->
      $("#psn_val1").val ui.item.int_persona_id
      $("#psn1").val ui.item.label
      false
  )

$ ->
  $("#psn2").autocomplete(
    source: personas
    select: (event, ui) ->
      $("#psn_val2").val ui.item.int_persona_id
      $("#psn2").val ui.item.label
      false
  )