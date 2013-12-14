function accidentSeverity() {
	d3.csv("data/roadEventClean.csv", function(events) {
		var data = [];
		var input_datum;
		var output_datum;
		
		var events_slice = events.splice(0,20);
		
		var surfaces = _.pluck(_.uniq(events_slice, "Road Surface"), "Road Surface").sort();
		$("#accident_predicter").append(createDropDown(surfaces, "surface"));
		
		var roadTypes = _.pluck(_.uniq(events_slice, "RoadwayType"), "RoadwayType").sort();
		$("#accident_predicter").append(createDropDown(roadTypes, "type"));
		
		var temps = _.pluck(_.uniq(events_slice, "Temperature"), "Temperature").sort();
		$("#accident_predicter").append(createDropDown(temps, "temp"));
		
		var trafficStates = _.pluck(_.uniq(events_slice, "TrafficState"), "TrafficState").sort();
		$("#accident_predicter").append(createDropDown(trafficStates, "states"));
		
		var weather = _.pluck(_.uniq(events_slice, "Weather"), "Weather").sort();
		$("#accident_predicter").append(createDropDown(trafficStates, "weather"));
				
		function createDropDown(array, prefix) {
			var p = document.createElement("p");
			var label = document.createElement("label");
			var selectBox = document.createElement("select");
			
			$(p).append(label);
			$(label).html(prefix);
			$(p).append(selectBox);
			for(i in array) {
				var value = i
				$(selectBox).append("<option value="+prefix+"_"+i+">"+array[i]+"</option");
			}
			return $(p);
		}
		events_slice.forEach(function(event) {
			input_datum = {};
			output_datum = {};
			output_datum["severity_" + event["Severity"]] = 1;
			// "Severity"
			
			input_datum["surface_" + surfaces.indexOf(event["Road Surface"])] = 1;
			input_datum["type_" + roadTypes.indexOf(event["RoadwayType"])] = 1;
			input_datum["temp_" + temps.indexOf(event["Temperature"])] = 1;
			input_datum["states_" + trafficStates.indexOf(event["TrafficState"])] = 1;
			input_datum["weather_" + weather.indexOf(event["Weather"])] = 1;
			
			//input_datum.time = event[""];
			//input_datum.duration = event["duration"];
			
			data.push({
				input: input_datum,
				output: output_datum
			});
		});
		
		var net = new brain.NeuralNetwork();
		
		net.train(data);
		
		$("#results").html("");
		var button = $("#results").append("<button>Predict</button>");
		
		button.on("click", function(e) {
			var input = {};
			$("#accident_predicter select").each(function(i,v,f) {
				input[$(v).val()] = 1;
			});
			var output = net.run(input);
			
			var a = 0, b = 0;
			var result = null;
			for(i in output) {
				b = output[i];
				if(b > a) {
					a = b;
					result = i;
				}
			}
			alert("Predicted Accident Severity: " + result.split("_")[1]);
		});
	});
}
