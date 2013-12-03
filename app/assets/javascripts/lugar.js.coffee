
root = exports ? this

jQuery ->
  root.DatosEnviar = null


  FormatoLugarTable = [   { "sWidth": "20%","mDataProp": "int_lugar_id"},
                              { "sWidth": "60%","mDataProp": "var_lugar_descripcion"},
                              { "sWidth": "20%","mDataProp": "acciones"}
                              ]

  LugarRowCB = (  nRow, aData, iDisplayIndex ) ->
    index = $(TablaLugar.fnGetData()).getIndexObj aData, 'int_servicio_id'
    acciones = getActionButtons "111"
    TablaLugar.fnUpdate( acciones, index, 2 );
    false

  TablaLugar = createDataTable "lugartable", "/configuracion/recuperar_lugar", FormatoLugarTable, null, LugarRowCB


	 # guardar lugar

	 # Proceso para enviar metodo Post

	 # 1. Preparar Datos

	 # Datos para enviar en formato JSON
  PrepararDatosL = ->
    root.DatosEnviar = 
      "formulario" : $("#form_lugar").serializeObject()

    false
	  
	 # Funcion de respuesta CORRECTA
	 # Los datos de respuesta se reciben en data

  SuccessFunctionL = ( data ) ->
    console.log "hola"
    TablaLugar.fnReloadAjax "/configuracion/recuperar_lugar"
    $("#form_lugar").reset()
    console.log data
    false

	 # 2. Enviar Datos
  $("#btnGuardar_Lugar").click (event) ->
    event.preventDefault()
    #Llamada a preparar Datps
    PrepararDatosL()
 	  #Llamada a envio Post
    enviar "/configuracion/guardar_lugar", root.DatosEnviar, SuccessFunctionL, null
    false
   

	 # Fin Proceso enviar Formulario
