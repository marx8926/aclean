# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this
root.SourceOfrendas = "/recuperar_ofrendas_init"

jQuery ->

  SuccessFunction = ( data ) ->
    OfrendaTable.fnReloadAjax root.SourceOfrendas    
    $("form").reset()
    MessageSucces()

  MessageSucces = ->
    setTimeout (->
      $.unblockUI onUnblock: ->
        $.growlUI "Operacion Exitosa"

    ), 1000

  FormatoOfrenda = [  { "sWidth": "25%","mDataProp": "int_ofrenda_id"},
                      { "sWidth": "35%","mDataProp": "servicio"},
                      { "sWidth": "15%","mDataProp": "registro"},
                      { "sWidth": "15%","mDataProp": "monto"},
                      { "sWidth": "10%","mDataProp": "acciones"}
                      ]

  OfrendaRowCB = (  nRow, aData, iDisplayIndex ) ->
    index = $(OfrendaTable.fnGetData()).getIndexObj aData, 'int_ofrenda_id'
    acciones = getActionButtons "011"
    OfrendaTable.fnUpdate( acciones, index, 4 ); 



  OfrendaTable = createDataTable "dataOfremdas", root.SourceOfrendas, FormatoOfrenda, null, OfrendaRowCB


  # Proceso para enviar metodo Post

  # 1. Preparar Datos

    # Datos para enviar en formato JSON
  PrepararDatos = ->
    root.DatosEnviar = $("#form_ofrenda").serialize()
  # Proceso para enviar metodo Post

  # 2. Enviar Datos
  $("#btnGuardar_Ofrenda").click (event) ->
    event.preventDefault()
    DisplayBlockUI "loader"
    PrepararDatos()
    enviar "/ofrendas_guardar",  root.DatosEnviar , SuccessFunction, null

  cargar_turno = ->
    turnos = getAjaxObject "/recuperar_turno_inicio/"+$("#_servicio").val()
    cargarSelect turnos, "turno", "turno", "inicio"

  $("#_servicio").change ->
    console.log "holas"
    cargar_turno()
  
