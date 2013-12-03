# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this
root.SourceTServicio = "/recuperar_personas_inicio"
root.DatosEnviar = null
root.count = 0

jQuery ->

  PrepararDatosVisitante = ->
    root.DatosEnviarV =
      "formulario" : $("#form_visita").serializeObject()
      "tabla" : TelefonoVTable.fnGetData()

  PrepararDatosMiembro = ->
    root.DatosEnviar =
      "formulario" : $("#form_miembro").serializeObject()
      "tabla" : TelefonoTable.fnGetData()

  SuccessFunction = ( data ) ->
    PersonaTable.fnReloadAjax "/recuperar_personas_inicio"
    HideForms()

  HideForms = ->    
    $("#visitante").hide()
    $("#miembro").hide()    
    $("form").reset()
    cargarUbigeo ubigeos, "distrito", "provincia", "departamento"
    TelefonoTable.fnClearTable()    
    TelefonoVTable.fnClearTable()
    $(".wizard").bwizard 'show', '0'

  PersonaRowCB = (  nRow, aData, iDisplayIndex ) ->
    index = $(PersonaTable.fnGetData()).getIndexObj aData, 'int_servicio_id'
    acciones = getActionButtons "111"
    PersonaTable.fnUpdate( acciones, index, 5 );
    $(nRow).find('a').tooltip('hide');
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

  FormatoPersonaTable = [   { "sWidth": "35%","mDataProp": "nombrecompleto"},
                            { "sWidth": "15%","mDataProp": "telefono"},
                            { "sWidth": "10%","mDataProp": "registro"},
                            { "sWidth": "10%","mDataProp": "convertido"},
                            { "sWidth": "10%","mDataProp": "nivel"},
                            { "sWidth": "20%","mDataProp": "var_persona_acciones"}
                            ]

  PersonaTable = createDataTable "table_registrados", root.SourceTServicio, FormatoPersonaTable, null, PersonaRowCB


  TelefonoTable = $('#table_telefonos_miembro').dataTable
    "aoColumns": [{"mDataProp": "numero"},{"mDataProp": "tipo"},{"mDataProp": "btn_elim"}]
    "bPaginate": false
    "sDom": "<r>t<'row-fluid'>"
    "fnCreatedRow": (  nRow, aData, iDisplayIndex ) ->
      $(nRow).find('a').tooltip('hide');
      $(nRow).find('.delete-row').click (e) ->
        index = $(TelefonoTable.fnGetData()).getIndexObj aData, 'id'
        TelefonoTable.fnDeleteRow index

  TelefonoVTable = $('#table_telefonos_visitante').dataTable
    "aoColumns": [{"mDataProp": "numero"},{"mDataProp": "tipo"},{"mDataProp": "btn_elim"}]
    "bPaginate": false
    "sDom": "<r>t<'row-fluid'>"
    "fnCreatedRow": (  nRow, aData, iDisplayIndex ) ->
      $(nRow).find('a').tooltip('hide');
      $(nRow).find('.delete-row').click (e) ->
        index = $(TelefonoVTable.fnGetData()).getIndexObj aData, 'id'
        TelefonoVTable.fnDeleteRow index

  $(".wizard").bwizard({nextBtnText: "Siguiente &rarr;", backBtnText: "&larr; Anterior"})

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
    HideForms()

  $('#add_numero').click (event) ->
    event.preventDefault()
    num = $("#codigo_tel").val()
    if num.length > 0
    	num = num + "-"+$("#telefono").val()
    else
    	num = $("#telefono").val()
    if $("#telefono").val().length > 0
      numero = 
        "numero": num
        "tipo" : $("#tipo_tel option:selected").text()
        "btn_elim":getActionButtons "001"
        "id":root.count
        "tipo_val": $("#tipo_tel").val()
        "codigo": $("#codigo_tel").val()
        "tel": $("#telefono").val()

      TelefonoTable.fnAddData numero
      root.count--

      $("#codigo_tel").val("")
      $("#telefono").val("")  

  $('#add_numerov').click ->
    num = $("#codigo_telv").val()
    if num.length > 0
    	num = num + "-"+$("#telefonov").val()
    else
    	num = $("#telefonov").val()
    if $("#telefonov").val().length > 0
      numero =
        "numero": num
        "tipo" : $("#tipo_telv option:selected").text()
        "btn_elim":getActionButtons "001"
        "id":root.count
        "tipo_val": $("#tipo_telv").val()
        "codigo": $("#codigo_telv").val()
        "tel": $("#telefonov").val()
      TelefonoVTable.fnAddData numero
      root.count--

  $("#btnGuardar_Miembro").click (event) ->
    event.preventDefault()
    PrepararDatosMiembro()
    enviar "/persona_guardar", root.DatosEnviar, SuccessFunction, null

  $("#btnguardarv").click (e) ->
    #Llamada a preparar Datps
    PrepararDatosVisitante()
    #Llamada a envio Post
    enviar "/visita_guardar", root.DatosEnviarV, SuccessFunction, null
  
  ubigeos = getAjaxObject("https://s3.amazonaws.com/adminchurchs3/json/ubi.json")
  cargarUbigeo ubigeos, "distrito", "provincia", "departamento"