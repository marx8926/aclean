# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

  $(".wizard").bwizard()
	
  count = 0;
  ubigeos = getAjaxObject("https://s3.amazonaws.com/adminchurchs3/json/ubi.json")
  cargarUbigeo ubigeos, "distrito", "provincia", "departamento"


  $('#miembro').hide()
  $('#visitante').hide()

  $('#registrar_miembro').click ->
    $("#miembro").toggle()

  $('#registrar_visitante').click ->
    $("#visitante").toggle()

  #inizializar telefonotable

  TelefonoTable = $('#table_telefonos_miembro').dataTable
    "aoColumns": [{"mDataProp": "numero"},{"mDataProp": "tipo"},{"mDataProp": "btn_elim"}]
    "bPaginate": false
    "sDom": "<r>t<'row-fluid'>"
    "fnCreatedRow": (  nRow, aData, iDisplayIndex ) ->
      $(nRow).find('.delete-row').click (e) ->
        index = $(TelefonoTable.fnGetData()).getIndexObj aData, 'id'
        TelefonoTable.fnDeleteRow index

  $('#add_numero').click ->
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
      $("#tipo_tel").val("")


  $("#btnGuardar_Miembro").click (e) ->
    $.ajax
      url: "/persona_guardar"
      type: "POST"
      dataType: "JSON"
      data:
      	formulario: $('#form_miembro').serializeObject()
      	tabla: TelefonoTable.fnGetData()
      success: (msj) ->
        console.log msj
  

  

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

