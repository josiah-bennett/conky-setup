-- [[Lua Script for the Clock]]

function draw_clock(cr, x, y, radius)
	hour = os.date('%H')
	min = os.date('%M')
	sec = os.date('%S')
	-- Crazy Maths to calculate the angles -- 0 * pi is at the right of the circle !!
	hour_angle = math.pi * ((hour - math.floor(hour / 12) * 12 - 3) / 6 + min / 360)
	min_angle = math.pi * (min - 15) / 30
	start_angle = -math.pi/2
	
	-- Define Colors
	border_color = Colors.nord0
	text_color = Colors.nord4
	indicator_color = Colors.nord5
	
	-- Draw Background
	cairo_set_source_rgba(cr, border_color[1], border_color[2], border_color[3], 1)
	cairo_set_line_width(cr, 3)
	
	cairo_move_to(cr, x, y - radius)
	cairo_arc(cr, x, y, radius, start_angle, 2 * math.pi)
	cairo_stroke_preserve(cr)
	cairo_set_source_rgba(cr, border_color[1], border_color[2], border_color[3], 0.5)
	cairo_fill(cr)
	
	-- Draw Indicators
	indicator_width = 15
	cairo_set_source_rgba(cr, indicator_color[1], indicator_color[2], indicator_color[3], 1)
	cairo_set_line_width(cr, indicator_width)

	-- Minutes
	cairo_move_to(cr, x, y - radius + indicator_width / 2 + 3)
	cairo_arc(cr, x, y, radius - indicator_width / 2 - 3, start_angle, min_angle)
	cairo_stroke(cr)

	-- Hours
	cairo_move_to(cr, x, y - radius + 2 * indicator_width)
	cairo_arc(cr, x, y, radius - 2 * indicator_width, start_angle, hour_angle)
	cairo_stroke(cr)
	
	-- Draw Time
	cairo_set_line_width(cr, 10)
	time_left = {text=hour, style=Styles.TIME} 
	time_right = {text=min, style=Styles.TIME}
	aligned_text(cr, x + 10, y - 15, time_left, time_right, ':')
	draw_left_text(cr, x + 85, y + 50, sec, Styles.TIME, {font_size=40})
	
	timezone = os.date('%Z')
	draw_left_text(cr, x - 130, y + 50, timezone)
end

