# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->  
  
  ubigeos = getAjaxObject "https://s3.amazonaws.com/adminchurchs3/json/ubi.json"
  cargarUbigeo ubigeos, "distrito", "provincia", "departamento"