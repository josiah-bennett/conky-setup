-- [[Lua Script for the Clock]]
-- existing Designs
Clocks = {
	default = 'default',
	binary = 'binary',
	-- other Design Options
}

-- draw clock Interface function
function draw_clock(cr, x, y, radius, design)
	if design == Clocks.binary then
		binary_clock(cr, x, y, radius)
	-- insert new Designs here (elseif)
	else -- if design is not set/not available or default
		default_clock(cr, x, y, radius)
	end
end

-- Default Clock Design
function default_clock(cr, x, y, radius)
	PI = math.pi
	-- current Time
	hour = os.date('%H')
	min = os.date('%M')
	sec = os.date('%S')
	-- top of the clock (00:00) [0*pi is the right of the circle]
	phase = - PI/2
	-- [2pi*(hour - _24h_cor)/12 + 2pi*min/360) + phase] 
	_24h_cor = math.floor(hour/12) * 12
	hour_angle = PI * ((hour - _24h_cor)/6 + min/180) + phase 
	min_angle = PI * min/30 + phase -- [2pi*minutes/60 + phase]
	-- size Settings
	indicator_width = 0.075 * radius -- 7.5%
	border_size = 0.015 * radius
	
	-- Define Color Variables
	border_color = Colors.nord0
	text_color = Colors.nord4
	indicator_color = Colors.nord5
	
	-- Draw Clock Background
	cairo_set_source_rgba(cr, border_color[1], border_color[2], border_color[3], 1)
	cairo_set_line_width(cr, border_size)
	
	cairo_move_to(cr, x, y - radius)
	cairo_arc(cr, x, y, radius, phase, 2 * PI)
	cairo_stroke_preserve(cr)
	cairo_set_source_rgba(cr, border_color[1], border_color[2], border_color[3], 0.5)
	cairo_fill(cr)
	
	-- Draw Indicators
	cairo_set_source_rgba(cr, indicator_color[1], indicator_color[2], indicator_color[3], 1)
	cairo_set_line_width(cr, indicator_width)

	-- Minutes
	cairo_move_to(cr, x, y - radius + indicator_width / 2 + 3) -- 3 ??
	cairo_arc(cr, x, y, radius - indicator_width / 2 - 3, phase, min_angle)
	cairo_stroke(cr)

	-- Hours
	cairo_move_to(cr, x, y - radius + 2 * indicator_width)
	cairo_arc(cr, x, y, radius - 2 * indicator_width, phase, hour_angle)
	cairo_stroke(cr)
	
	-- Draw Digital Time Readout
	cairo_set_line_width(cr, 5) -- 10 ??
	time_left = {text=hour, style=Styles.TIME} 
	time_right = {text=min, style=Styles.TIME}
	aligned_text(cr, x + 0.05 * radius, y - 0.075 * radius, time_left, time_right, ':')
	draw_left_text(cr, x + 0.425 * radius, y + 0.25 * radius, sec, Styles.TIME_SMALL)
	
	timezone = os.date('%Z')
	draw_left_text(cr, x - 0.65 * radius, y + 0.25 * radius, timezone)
end

-- Binary Clock Design
function binary_clock(cr, x, y, radius)
	-- current Time
	hour = os.date('%H')
	min = os.date('%M')
	sec = os.date('%S')
	-- ...
end

