function loadHighwayViz() {
	var forEach = Array.prototype.forEach;
			
	var lineFunction = d3.svg.line()
						.x(function(d) { return d.x; })
						.y(function(d) { return d.y; })
						.interpolate("linear");
	
	var g = svg.append("g").attr("id", "highway-map");
	
	d3.xml("data/pair_routes.xml", function(xml) {
			var pairDataNodes = xml.documentElement.getElementsByTagName("PAIRDATA");
			var lineData;
			
			forEach.call(pairDataNodes, function(node) {
				lineData = [];
				var routes = node.getElementsByTagName("Route");
				
				forEach.call(routes, function(route) {
					var lat = route.getElementsByTagName("lat")[0].childNodes[0].nodeValue;
					var lng = route.getElementsByTagName("lon")[0].childNodes[0].nodeValue;
					var road_projection = projection([lng,lat]);
					lineData.push({ 
						"x": road_projection[0],
						"y": road_projection[1]
					});
				});
				
				g.append("path")
					.attr("d", lineFunction(lineData))
					.attr("stroke", "#333")
					.attr("stroke-width", 4)
					.attr("fill", "none");
			});
		});
}
