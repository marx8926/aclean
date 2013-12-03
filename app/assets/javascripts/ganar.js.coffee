# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this
root.SourceTServicio = "/recuperar_personas_inicio"
root.DatosEnviar = null

jQuery ->
  
  $(".wizard").bwizard({nextBtnText: "Siguiente &rarr;", backBtnText: "&larr; Anterior"})
	
  count = 200;
  ubigeos = getAjaxObject("https://s3.amazonaws.com/adminchurchs3/json/ubi.json")
  cargarUbigeo ubigeos, "distrito", "provincia", "departamento"

  $('#registrar_miembro').click (event) ->
    event.preventDefault()
    $("#miembro").show()
    $("#visitante").hide()

  $('#registrar_visitante').click (event) ->
    event.preventDefault()
    $("#visitante").show()
    $("#miembro").hide()

  $(".btncancelarform").click (event) ->
    event.preventDefault()
    $("#miembro").hide()
    $("#visitante").hide()

  #inizializar telefonotable

  TelefonoTable = $('#table_telefonos_miembro').dataTable
    "aoColumns": [{"mDataProp": "numero"},{"mDataProp": "tipo"},{"mDataProp": "btn_elim"}]
    "bPaginate": false
    "sDom": "<r>t<'row-fluid'>"
    "fnCreatedRow": (  nRow, aData, iDisplayIndex ) ->
      $(nRow).find('.delete-row').click (e) ->
        index = $(TelefonoTable.fnGetData()).getIndexObj aData, 'id'
        TelefonoTable.fnDeleteRow index

  FormatoPersonaTable = [   { "sWidth": "35%","mDataProp": "nombrecompleto"},
                            { "sWidth": "15%","mDataProp": "telefono"},
                            { "sWidth": "10%","mDataProp": "registro"},
                            { "sWidth": "10%","mDataProp": "convertido"},
                            { "sWidth": "10%","mDataProp": "nivel"},
                            { "sWidth": "20%","mDataProp": "var_persona_acciones"}
                            ]

  PersonaRowCB = (  nRow, aData, iDisplayIndex ) ->
    index = $(PersonaTable.fnGetData()).getIndexObj aData, 'int_servicio_id'
    acciones = getActionButtons "111"
    PersonaTable.fnUpdate( acciones, index, 5 );
    $(nRow).find('.edit_row').click (event) ->
      event.preventDefault()
      if("Visitante" == aData.nivel)
        console.log aData
        $("#nombrev").val aData.persona_data.var_persona_nombres
        $("#apellidov").val aData.persona_data.var_persona_apellidos
        $("#edadv").val aData.persona_data.int_persona_edad
        $(aData.telefono_data).each (index) ->
        showtipotel = ""
        if(this.int_telefono_tipo == 1)
          showtipotel = "Celular"
        else
          showtipotel = "Fijo"
        tel = { "numero": this.var_telefono_codigo + this.var_telefono, "tipo" : showtipotel, "btn_elim":getActionButtons "001", "id":this.int_telefono_id , "tipo_val": this.int_telefono_tipo, "codigo": this.var_telefono_codigo, "tel": this.var_telefono }
        TelefonoVTable.fnAddData tel        
        $("#invitadov").val aData.persona_data.var_persona_invitado

      else
        $("#nombre").val aData.persona_data.var_persona_nombres
        $("#apellido").val aData.persona_data.var_persona_apellidos
        $("#edad").val aData.persona_data.int_persona_edad
        $("#estado_civil").val aData.persona_data.var_persona_estado
        $("#sexo").val aData.persona_data.var_persona_sexo
        $("#dni").val aData.persona_data.var_persona_dni
        $("#ocupacion").val aData.persona_data.var_persona_ocupacion
        $("#profesion").val aData.persona_data.var_persona_profesion
        $(aData.telefono_data).each (index) ->
          showtipotel = ""
          if(this.int_telefono_tipo == 1)
            showtipotel = "Celular"
          else
            showtipotel = "Fijo"
          tel = { "numero": this.var_telefono_codigo + this.var_telefono, "tipo" : showtipotel, "btn_elim":getActionButtons "001", "id":this.int_telefono_id , "tipo_val": this.int_telefono_tipo, "codigo": this.var_telefono_codigo, "tel": this.var_telefono }
          TelefonoTable.fnAddData tel
        $("#_lugar").val aData.persona_data.lugar_id
        $("#email").val aData.persona_data.var_persona_email
        $("#invitado").val aData.persona_data.var_persona_invitado

  PersonaTable = createDataTable "table_registrados", root.SourceTServicio, FormatoPersonaTable, null, PersonaRowCB

  $('#add_numero').click (event) ->
    event.preventDefault()
    btn_elim = '<a class="delete-row" data-original-title="Delete" href="#"><img alt="trash" src="http://d9i0z8gxqnxp1.cloudfront.net/img/trash-icon.png"></a>'

    num = $("#codigo_tel").val()
    if num.length > 0
    	num = num + "-"+$("#telefono").val()
    else
    	num = $("#telefono").val()

    if $("#telefono").val().length > 0
      numero = { "numero": num, "tipo" : $("#tipo_tel option:selected").text(), "btn_elim":btn_elim, "id":count , "tipo_val": $("#tipo_tel").val(), "codigo": $("#codigo_tel").val(), "tel": $("#telefono").val() }
      TelefonoTable.fnAddData numero
      count++
      $("#codigo_tel").val("")
      $("#telefono").val("")


  # 1. Preparar Datos

  # Datos para enviar en formato JSON
  PrepararDatosRegistrar = ->
    root.DatosEnviar =
      "formulario" : $("#form_miembro").serializeObject()
      "tabla" : TelefonoTable.fnGetData()

  # Funcion de respuesta CORRECTA
  # Los datos de respuesta se reciben en data
  SuccessFunctionRegistrar = ( data ) ->
    #recargar datos de tabla Servicios
    # ServiciosTable.fnReloadAjax "/configuracion/recuperar_servicio"
    #resetear formulario
    #$("#form_miembro").reset()
    #cargarUbigeo ubigeos, "distrito", "provincia", "departamento"
    #reniciar tabla
    TelefonoTable.fnClearTable()
    #mostrar datos de respuesta
    console.log data

  # 2. Enviar Datos
  $("#btnGuardar_Miembro").click (event) ->
    event.preventDefault()
    #Llamada a preparar Datps
    PrepararDatosRegistrar()
    #Llamada a envio Post
    enviar "/persona_guardar", root.DatosEnviar, SuccessFunctionRegistrar, null

    # Fin Proceso enviar Formulario 

  #inizializar telefonotableV

  TelefonoVTable = $('#table_telefonos_visitante').dataTable
    "aoColumns": [{"mDataProp": "numero"},{"mDataProp": "tipo"},{"mDataProp": "btn_elim"}]
    "bPaginate": false
    "sDom": "<r>t<'row-fluid'>"
    "fnCreatedRow": (  nRow, aData, iDisplayIndex ) ->
      $(nRow).find('.delete-row').click (e) ->
        index = $(TelefonoVTable.fnGetData()).getIndexObj aData, 'id'
        TelefonoVTable.fnDeleteRow index

  $('#add_numerov').click ->
    btn_elim = '<a class="delete-row" data-original-title="Delete" href="#"><img alt="trash" src="http://d9i0z8gxqnxp1.cloudfront.net/img/trash-icon.png"></a>'

    num = $("#codigo_telv").val()
    count = 0
    if num.length > 0
    	num = num + "-"+$("#telefonov").val()
    else
    	num = $("#telefonov").val()

    if $("#telefonov").val().length > 0

      numero = { "numero": num, "tipo" : $("#tipo_telv option:selected").text(), "btn_elim":btn_elim, "id":count , "tipo_val": $("#tipo_telv").val(), "codigo": $("#codigo_telv").val(), "tel": $("#telefonov").val() }
      TelefonoVTable.fnAddData numero
      count++


   # 1. Preparar Datos

  # Datos para enviar en formato JSON
  PrepararDatosV = ->
    root.DatosEnviarV =
      "formulario" : $("#form_visita").serializeObject()
      "tabla" : TelefonoVTable.fnGetData()

  # Funcion de respuesta CORRECTA
  # Los datos de respuesta se reciben en data
  SuccessFunctionVisitante = ( data ) ->
    #recargar datos de tabla Servicios
    # ServiciosTable.fnReloadAjax "/configuracion/recuperar_servicio"
    #resetear formulario
    #$("#form_visita").reset()
    cargarUbigeo ubigeos, "distrito", "provincia", "departamento"
    #reniciar tabla
    TelefonoVTable.fnClearTable()
    #mostrar datos de respuesta
    console.log(data)

  # 2. Enviar Datos
  $("#btnguardarv").click (e) ->
    #Llamada a preparar Datps
    PrepararDatosV()
    #Llamada a envio Post
    enviar "/visita_guardar", root.DatosEnviarV, SuccessFunctionVisitante, null

    # Fin Proceso enviar Formulario
      
    #act on result.
    false # prevents normal behaviour