$(document).ready(function($) {
	$("#commuter-rail").on("change", function(e) {
		if($(this).prop("checked")) {
			$("#commuter-rail-map").show();
		} else {
			$("#commuter-rail-map").hide();
		}
	});
	
	$("#highway").on("change", function(e) {
		if($(this).prop("checked")) {
			$("#highway-map").show();
		} else {
			$("#highway-map").hide();
		}
	});
});
