$(document).ready(function () {
	$(".wizard").bwizard({nextBtnText: "Siguiente &rarr;", backBtnText: "&larr; Anterior"})
	$(".datepicker").datepicker({
		format:"dd/mm/yyyy"
	});
});
