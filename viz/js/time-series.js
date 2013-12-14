function loadTimeSeries() {
	var branch_map = {};
	branch_map["Attleboro"] = "Providence/Stoughton Line";
	branch_map["Dorchester Branch"] = "Fairmount Line";
	branch_map["Eastern Route Main Line"] = "Newburyport/Rockport Line";
	branch_map["Fitchburg Main Line"] = "Fitchburg/South Acton Line";
	branch_map["Franklin Br.Via Fairmount"] = "Fairmount Line";
	branch_map["Franklin Branch"] = "Franklin Line";
	branch_map["Gloucester Branch"] = "Newburyport/Rockport Line";
	branch_map["Greenbush Branch"] = "Greenbush Line";
	branch_map["Kingston Branch"] = "Kingston/Plymouth Line";
	branch_map["Middleboro Main Line"] = "Middleboro Line";
	branch_map["Needham Branch"] = "Needham Line";
	branch_map["New Hampshire Main Line"] = "Lowell Line";
	branch_map["Plymouth Branch"] = "Kingston/Plymouth Line";
	branch_map["Stoughton Branch"] = "Providence/Stoughton Line";
	branch_map["Western Route Main Line"] = "Haverhill Line";
	branch_map["Western Route Via Wildcat"] = "Lowell Line";
	branch_map["Worcester Main Line"] = "Worcester Line";
	
	
	d3.csv("data/passengers.lines.csv", function(csv) {		
		$("#time-slider").on("change", function(e) {
			var value = $(this).val();
			
			var data = csv[_.findIndex(csv, function(timestamp) {
				return timestamp.unix_time == value; 
			})];
			
			var line_congestion = {};
			
			// seed line_congestion
			for(i in branch_map) {
				var key = branch_map[i];
				
				if(!line_congestion[key]) {
					line_congestion[key] = 0;
				}
			}
			
			for(i in branch_map) {
				var key = branch_map[i];
				line_congestion[key] += parseInt(data[i]);
			}
			
			for(i in line_congestion) {
				d3.selectAll("line").style("stroke-width", function(d) {
					return (line_congestion[d.start.route] / 500) + 1;
				});
			}
			
			var date = new Date(data.unix_time*1000);
			
			function timeConverter(UNIX_timestamp){
				var a = new Date(UNIX_timestamp*1000);
				var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
				var year = a.getFullYear();
				var month = months[a.getMonth()];
				var date = a.getDate();
				var hour = a.getHours();
				var min = a.getMinutes();
				var sec = a.getSeconds();
				var time = date+' '+month+' '+year+' '+hour+':'+min+"0";
				return time;
			}

			$(".date").html(timeConverter(data.unix_time));
		});
	});
}
