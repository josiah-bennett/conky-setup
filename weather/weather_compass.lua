--[[Script to show the Compass Hexagon]]

function draw_compass(cr, x, y)
	line_color = Colors.nord0
	cairo_set_source_rgba(cr, line_color[1], line_color[2], line_color[3], 1)
	line_widths = {5, 3, 2, 2, 2, 4, 4, 2}
	
	radius_0 = 100
	radii = {1, 0.925, 0.75, 0.69, 0.575, 0.5, 0.12, 0.06}
	extras = {1.1, 0.88, 1.4}
	needle_points = {0.79, 1.4}
	
	theta = math.pi/12
	
	main_color = Colors.nord4
	main_compl_color = Colors.nord0
	
	for i=1, 6 do
		radius = radius_0 * radii[i]
		-- draw circle
		cairo_set_line_width(cr, line_widths[i])
		cairo_move_to(cr, x, y - radius)
		cairo_arc(cr, x, y, radius, -math.pi/2, 2*math.pi)
		cairo_stroke(cr)
	end
	
	for i=1, 24 do
		x0 = math.sin(i*theta) * radius_0
		y0 = math.cos(i*theta) * radius_0
		
		-- indicator lines
		cairo_set_line_width(cr, line_widths[3])
		cairo_move_to(cr, x + x0 * radii[5], y + y0 * radii[5])
		cairo_line_to(cr, x + x0 * radii[3], y + y0 * radii[3])
		cairo_stroke(cr)
		
		if (i % 3) ~= 0 then
			-- outer dots
			cairo_move_to(cr, x + x0 * extras[1], y + y0 * extras[1])
			cairo_arc(cr, x + x0 * extras[1], y + y0 * extras[1], line_widths[1] - 1, 0, 2*math.pi)
			cairo_fill(cr)
			
		elseif (i % 2) ~= 0 then
			-- diagonal lines
			cairo_set_line_width(cr, line_widths[2])
			cairo_move_to(cr, x + x0 * extras[2], y + y0 * extras[2])
			cairo_line_to(cr, x + x0 * extras[3], y + y0 * extras[3])
			cairo_stroke(cr)
			
			width = 0.1
			-- diagonal triangles
			cairo_move_to(cr, x + x0 * needle_points[1], y + y0 * needle_points[1])
			cairo_line_to(cr, x + x0 * width, y - y0 * width)
			cairo_line_to(cr, x - x0 * width, y + y0 * width)
			cairo_close_path(cr)
			cairo_fill(cr)
		end
	end
	
	width = 0.18
	theta = math.pi/2
	for i=1, 4 do
		x0 = math.sin(i*theta) * radius_0
		y0 = math.cos(i*theta) * radius_0
		
		cairo_move_to(cr, x + x0 * needle_points[2], y + y0 * needle_points[2])
		cairo_line_to(cr, x + math.sin((i+0.5)*theta) * radius_0 * width, y + math.cos((i+0.5)*theta) * radius_0 * width)
		cairo_line_to(cr, x, y)
		cairo_close_path(cr)
		
		cairo_set_line_width(cr, 1)
		cairo_set_source_rgba(cr, line_color[1], line_color[2], line_color[3], 1)
		cairo_stroke_preserve(cr)
		cairo_set_source_rgba(cr, main_color[1], main_color[2], main_color[3], 1)
		cairo_fill(cr)
		
		cairo_move_to(cr, x + x0 * needle_points[2], y + y0 * needle_points[2])
		cairo_line_to(cr, x + math.sin((i-0.5)*theta) * radius_0 * width, y + math.cos((i-0.5)*theta) * radius_0 * width)
		cairo_line_to(cr, x, y)
		cairo_close_path(cr)
		
		cairo_set_source_rgba(cr, main_compl_color[1], main_compl_color[2], main_compl_color[3], 1)
		cairo_fill(cr)
	end
	
	radius = radius_0 * radii[7]
	cairo_move_to(cr, x + radius, y)
	cairo_arc(cr, x, y, radius, 0, 2*math.pi)
	
	cairo_set_line_width(cr, line_widths[7])
	cairo_set_source_rgba(cr, main_color[1], main_color[2], main_color[3], 1)
	cairo_fill_preserve(cr)
	cairo_set_source_rgba(cr, line_color[1], line_color[2], line_color[3], 1)
	cairo_stroke(cr)
	
	radius = radius_0 * radii[8]
	cairo_move_to(cr, x + radius, y)
	cairo_arc(cr, x, y, radius, 0, 2*math.pi)
	
	cairo_set_line_width(cr, line_widths[8])
	cairo_set_source_rgba(cr, line_color[1], line_color[2], line_color[3], 1)
	cairo_stroke(cr)
	
	return radius_0
end



