root = exports ? this

jQuery ->
  
  PrepararDatos = ->
    root.DatosEnviar =
      "formulario" : $("#form_diezmo").serializeObject()

  SuccessFunction = ( data ) ->
    if data != null
    	$("#dash_diezmo").highcharts data

  $("#btnGenerar_diezmo").click (event) ->
    event.preventDefault()
    PrepararDatos()
    enviar "recuperar_data_diezmo", root.DatosEnviar, SuccessFunction, null
    
