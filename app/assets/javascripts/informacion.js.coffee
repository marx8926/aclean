# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



root = exports ? this



jQuery ->

  

  PrepararDatos = ->
    root.DatosEnviar =
      "formulario" : $("#form_diezmo").serializeObject()

    console.log "preparar"

  SuccessFunction = ( data ) ->
    console.log data
    

  $("#btnGenerar_diezmo").click (event) ->
    event.preventDefault()
    
    PrepararDatos()
    enviar "/recuperar_data_diezmo", root.DatosEnviar, SuccessFunction, null



