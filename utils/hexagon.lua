-- [[Util Lua Script hexagonal background Display]]

function create_hexagon_path(cr, x_center, y_center, radius)
	line_join = CAIRO_LINE_JOIN_ROUND -- Line Settings
	cairo_move_to(cr, x_center + radius, y_center)
	for i=1,6 do
		-- Calculate x, y Points for the hexagon
		x = x_center + radius * math.cos((i*math.pi)/3)
		y = y_center + radius * math.sin((i*math.pi)/3)
		cairo_line_to(cr, x, y)
	end
	cairo_set_line_join(cr, line_join)
	cairo_close_path(cr)
end

function draw_hexagon(cr, x, y, radius, color)
	cairo_set_line_width(cr, 1)
	-- draw outline
	dash_length = radius / 14
	create_hexagon_path(cr, x, y, radius)
	cairo_set_dash(cr, {dash_length, dash_length}, 2, dash_length/2)
	cairo_set_source_rgba(cr, 0, 0, 0, 1)
	cairo_stroke(cr)
	-- fill shape
	create_hexagon_path(cr, x, y, radius - 5)
	cairo_set_dash(cr, {dash_length, dash_length, dash_length, dash_length}, 4, dash_length/2)
	cairo_set_source_rgba(cr, color[1], color[2], color[3], 0.25)
	cairo_fill(cr)

	cairo_set_dash(cr, {}, 0, 0)
end

function draw_indicator(cr, x, y, radius, color, cw, percentage, start, stop)
	start_angle = -math.pi/2
	stop_angle = -math.pi/2
	
	if cw == nil then
		cw = true
	end
	
	if percentage ~= nil then
		if cw then
			stop_angle = math.pi * (percentage - 25) / 50
		else
			stop_angle = -math.pi * (percentage + 25) / 50
		end
	end
	
	if start ~= nil then
		start_angle = start
	end
	
	if stop ~= nil then
		stop_angle = stop
	end
	
	draw_hex_indicator(cr, x, y, radius, color, start_angle, stop_angle, cw)
end

function draw_hex_indicator(cr, x, y, radius, color_list, percentage_list)
	theta = -math.pi/2
	
	xi = x
	yi = y + radius
	for i, percentage in ipairs(percentage_list) do
		color = color_list[i]
		
		alpha = math.pi * percentage/50 + theta
		
		create_hexagon_path(cr, x, y, radius)
		cairo_clip (cr)
		
		cairo_new_path (cr);  -- current path is not consumed by cairo_clip()
		cairo_move_to(cr, x, y)
		
		cairo_line_to(cr, xi, yi)
		cairo_arc(cr, x, y, radius, theta, alpha)
		cairo_close_path(cr)
		xi, yi = cairo_get_current_point(cr)
		
		cairo_set_source_rgba(cr, color[1], color[2], color[3], 0.75)
		cairo_fill(cr)
		
		cairo_reset_clip(cr)
		
		theta = alpha
	end
	
	draw_hexagon(cr, x, y, radius, Colors.nord0)
end

