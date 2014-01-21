$(document).ready(function () {
	$(".datepicker").datepicker({
		format: "dd/mm/yyyy",
	    language: "es",
	    endDate: new Date(),
	    autoclose: true,
	    orientation: "top auto",
	    todayHighlight: true
	});
});
