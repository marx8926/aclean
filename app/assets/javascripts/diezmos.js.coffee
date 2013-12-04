# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this
root.SourceTServicio = "/recuperar_diezmos_inicio"
root.DatosEnviar = null

jQuery ->
  personas = getAjaxObject "/persona_servicio_complete"

  SuccessFunction = ( data ) ->
    DiezmoTable.fnReloadAjax root.SourceTServicio    
    $("form").reset()
    MessageSucces()

  MessageSucces = ->
    setTimeout (->
      $.unblockUI onUnblock: ->
        $.growlUI "Operacion Exitosa"

    ), 1000

  PrepararDatos = ->
    root.DatosEnviar = $("#form_diezmo").serialize()

  FormatoPersonaTable = [   { "sWidth": "40%","mDataProp": "persona"},
                            { "sWidth": "15%","mDataProp": "fecha"},
                            { "sWidth": "15%","mDataProp": "monto"},
                            { "sWidth": "30%","mDataProp": "peticion"}
                            ]

  DiezmoTable = createDataTable "table_diezmos", root.SourceTServicio, FormatoPersonaTable, null, null

  $('#registrar_diezmo').click (event) ->
    event.preventDefault()
    $("#diezmo_div").show()

  $("#persona").autocomplete
    source: personas
    select: (event, ui) ->
      $("#persona_hidden").val ui.item.int_persona_id
      $("#persona").val ui.item.label
      false

  $("#btnGuardar_Diezmo").click (event) ->
    event.preventDefault()
    DisplayBlockUI "loader"
    PrepararDatos()
    #Llamada a envio Post
    enviar "/diezmos_guardar", root.DatosEnviar, SuccessFunction, null

# Fin Proceso enviar Formulario
      
    #act on result.
    false # prevents normal behaviour