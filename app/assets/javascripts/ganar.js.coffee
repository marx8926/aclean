# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this
root.SourceTServicio = "/recuperar_personas_inicio"
root.DatosEnviar = null
root.count = 0
root.SelectToDrop = null
root.TipoForm = null
root.actionPersonas = null

jQuery ->
  
  $(".wizard").bwizard({nextBtnText: "Siguiente &rarr;", backBtnText: "&larr; Anterior"})

  Actions = new DTActions
    'conf' : '111',
    'idtable': 'table_registrados',
    'ViewFunction': (nRow, aData, iDisplayIndex) ->      
      persona = getAjaxObject "recuperar_persona_id/"+aData.int_persona_id
      if(0 == persona.nivel)
        HideForms()
        $("#form_visita").disable()
        $("#visitante").show()
        $("#nombrev").focus()
      else 
        HideForms()
        cargarUbigeo ubigeos, "distrito", "provincia", "departamento",persona.distrito,persona.provincia,persona.departamento
        $("#form_miembro").disable()
        $("#miembro").show()
        $("#nombre").focus();      
      LoadMiembro persona

    'EditFunction': (nRow, aData, iDisplayIndex) ->
      $("#idPersona").val aData.int_persona_id
      persona = getAjaxObject "recuperar_persona_id/"+aData.int_persona_id
      if("Visitante" == persona.nivel)
        HideForms()
        $("#visitante").show()
        $("#btneditarv").show()
        $("#nombrev").focus()
      else 
        HideForms()
        cargarUbigeo ubigeos, "distrito", "provincia", "departamento",persona.distrito,persona.provincia,persona.departamento
        $("#miembro").show()
        $("#btneditar_Miembro").show()
        $("#nombre").focus();      
      LoadMiembro persona

    'DropFunction': (nRow, aData, iDisplayIndex) ->
      root.SelectToDrop = aData.int_persona_id
      DisplayBlockUISingle "dangermodal"

  LoadMiembro = (persona) ->
    if(0 == persona.nivel)
      $("#nombrev").val persona.var_persona_nombres
      $("#apellidov").val persona.var_persona_apellidos
      $("#edadv").val persona.int_persona_edad
      $("#invitadov").val persona.var_persona_invitado
    else
      $("#nombre").val persona.var_persona_nombres
      $("#apellido").val persona.var_persona_apellidos
      $("#edad").val persona.int_persona_edad
      $("#estado_civil").val persona.var_persona_estado
      $("#sexo").val persona.var_persona_sexo
      $("#fec_nac").val persona.fecnacimiento
      $("#dni").val persona.var_persona_dni
      $("#ocupacion").val persona.var_persona_ocupacion
      $("#profesion").val persona.var_persona_profesion
      $("#idpersona").val persona.int_persona_id
      $("#direccion").val persona.direccion
      $("#referencia").val persona.referencia
      $("#_lugar").val persona.lugar_id
      $("#fec_conversion").val persona.fecconvertido
      $("#email").val persona.var_persona_email
      $("#invitado").val persona.var_persona_invitado
    $(persona.telefonos).each (index) ->
        showtipotel = ""
        if(this.int_telefono_tipo == 1)
          showtipotel = "Celular"
        else
          showtipotel = "Fijo"
        tel =
          "numero": this.var_telefono_codigo + this.var_telefono
          "tipo" : showtipotel
          "btn_elim":""
          "id":this.int_telefono_id
          "tipo_val": this.int_telefono_tipo
          "codigo": this.var_telefono_codigo
          "tel": this.var_telefono
        TelefonoVTable.fnAddData tel        

  PrepararDatosVisitante = ->
    root.DatosEnviarV =
      "formulario" : $("#form_visita").serializeObject()
      "tabla" : TelefonoVTable.fnGetData()

  PrepararDatosMiembro = ->
    root.DatosEnviar =
      "formulario" : $("#form_miembro").serializeObject()
      "tabla" : TelefonoTable.fnGetData()

  SuccessFunction = ( data ) ->
    console.log data
    PersonaTable.fnReloadAjax root.SourceTServicio
    HideForms()
    MessageSucces()

  MessageSucces = ->
    setTimeout (->
      $.unblockUI onUnblock: ->
        $.growlUI "Operacion Exitosa"

    ), 1000

  SuccessFunctionDropServicio = (data) ->
    console.log data
    MessageSucces()
    PersonaTable.fnReloadAjax root.SourceTServicio

  HideForms = ->    
    $("#visitante").hide()
    $("#miembro").hide()    
    $("form").reset()
    cargarUbigeo ubigeos, "distrito", "provincia", "departamento"
    TelefonoTable.fnClearTable()    
    TelefonoVTable.fnClearTable()
    $(".wizard").bwizard 'show', '0'
    $("form").enable()
    $("#btneditarv").hide()
    $("#btneditar_Miembro").hide()
    $("#btnguardarv").hide()
    $("#btnGuardar_Miembro").hide()
    $(".idPersona").val ""

  root.actionPersonas = getActionButtons "111"

  PersonaRowCB = (  nRow, aData, iDisplayIndex ) ->
    Actions.RowCBFunction nRow, aData, iDisplayIndex

  FormatoPersonaTable = [   { "sWidth": "35%","mDataProp": "nombrecompleto"},
                            { "sWidth": "10%","mDataProp": "fecnacimiento"},
                            { "sWidth": "10%","mDataProp": "fecconvertido"},
                            { "sWidth": "10%","mDataProp": "nivel"}
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

  $('#registrar_miembro').click (event) ->
    event.preventDefault()
    HideForms()
    $("#miembro").show()
    $("#btnGuardar_Miembro").show()

  $('#registrar_visitante').click (event) ->
    event.preventDefault()
    HideForms()    
    $("#visitante").show()
    $("#btnguardarv").show()

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

  $('#add_numerov').click (event) ->
    event.preventDefault()
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

  $("#btnSiEliminar").click (event) ->
    event.preventDefault()
    DisplayBlockUI "loader"
    enviar "persona_eliminar_persona", {"id":root.SelectToDrop}, SuccessFunctionDropServicio, null

  $("#btnSiGuardar").click (event) ->
    event.preventDefault()    
    DisplayBlockUI "loader"
    #Llamada a preparar Datps
    if root.TipoForm == "M"
      PrepararDatosMiembro()
      SuccessFunction()
      enviar "/persona_editar_miembro", root.DatosEnviar, SuccessFunction, null
    else
      PrepararDatosVisitante()
      SuccessFunction()
      enviar "/persona_editar_visita", root.DatosEnviarV, SuccessFunction, null


  $(".btnNo").click (event) ->
    event.preventDefault()
    $.unblockUI()

  $("#btnGuardar_Miembro").click (event) ->
    event.preventDefault()
    if $('#form_miembro').validationEngine 'validate'
      DisplayBlockUI "loader"
      PrepararDatosMiembro()
      enviar "/persona_guardar", root.DatosEnviar, SuccessFunction, null

  $("#btnguardarv").click (event) ->
    event.preventDefault()    
    if $('#form_visita').validationEngine 'validate'
      DisplayBlockUI "loader"
      PrepararDatosVisitante()
      enviar "/visita_guardar", root.DatosEnviarV, SuccessFunction, null

  $("#btneditar_Miembro").click (event) ->
    event.preventDefault()
    if $('#form_miembro').validationEngine 'validate'
      root.TipoForm = "M"
      DisplayBlockUISingle "confirmmodal"


  $("#btneditarv").click (event) ->
    event.preventDefault()
    if $('#form_visita').validationEngine 'validate'
      root.TipoForm = "V"
      DisplayBlockUISingle "confirmmodal"
  
  ubigeos = getAjaxObject "https://s3.amazonaws.com/adminchurchs3/json/ubi.json"
  cargarUbigeo ubigeos, "distrito", "provincia", "departamento"


  $("#reload").click (event) ->
    event.preventDefault()
    PersonaTable.fnReloadAjax root.SourceTServicio
    console.log "hola"


  $("#form_miembro").validationEngine 'attach',{autoHidePrompt:true,autoHideDelay:3000}
  $("#form_visita").validationEngine 'attach',{autoHidePrompt:true,autoHideDelay:3000}