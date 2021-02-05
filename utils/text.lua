-- [[Lua Script for drawing Text]]

	-- other font : 'SF Digital Readout', CAIRO_FONT_WEIGHT_MEDIUM
Styles = {
	
	HEADER = {font_size=32, color=Colors.nord14},
	KEYWORDS = {font_size=32, color=Colors.nord0},
	TIME = {font='Ticking Timebomb BB', font_weight=CAIRO_FONT_WEIGHT_MEDIUM, font_size=140},
	DEFAULT = {font='Monospace', font_weight=CAIRO_FONT_WEIGHT_NORMAL, font_size=28, color=Colors.nord4}
	
}

function configure_text_settings(cr, style, custom_settings)
	settings = {'font', 'font_weight', 'font_size', 'color'}
	if custom_settings == nil then
		custom_settings = {font=nil, font_weight=nil, font_size=nil, color=nil}
	end
	if style == nil then
		style = Styles.DEFAULT
	end

	for i=1,4 do
		setting = settings[i]
		if custom_settings[setting] == nil then
			if style[setting] == nil then
				custom_settings[setting] = Styles.DEFAULT[setting]
			else
				custom_settings[setting] = style[setting]
			end
		end
	end
	
	cairo_select_font_face(cr, custom_settings.font, CAIRO_FONT_SLANT_NORMAL, custom_settings.font_weight)
	cairo_set_font_size(cr, custom_settings.font_size)
	color = custom_settings.color
	cairo_set_source_rgba(cr, color[1], color[2], color[3], 1)
end

function draw_centered_text(cr, x, y, text, style, custom)
	configure_text_settings(cr, style, custom)

	-- I don't know what the following two lines do !!
	local extents = cairo_text_extents_t:create()
	tolua.takeownership(extents)
	cairo_text_extents (cr, text, extents);

	cairo_move_to (cr, x-(extents.width / 2 + extents.x_bearing), y-(extents.height / 2 + extents.y_bearing))
	cairo_show_text (cr, text)
end

function draw_right_text(cr, x, y, text, style, custom)
	configure_text_settings(cr, style, custom)
	
	local extents = cairo_text_extents_t:create()
	tolua.takeownership(extents)
	cairo_text_extents (cr, text, extents);

	cairo_move_to (cr, x-(extents.width + extents.x_bearing), y-(extents.height / 2 + extents.y_bearing))
	cairo_show_text (cr, text)
end

function draw_left_text(cr, x, y, text, style, custom)
	configure_text_settings(cr, style, custom)
	
	local extents = cairo_text_extents_t:create()
	tolua.takeownership(extents)
	cairo_text_extents (cr, text, extents);

	cairo_move_to (cr, x-(extents.x_bearing), y-(extents.height / 2 + extents.y_bearing))
	cairo_show_text (cr, text)
end

function aligned_text(cr, x, y, left_side, right_side, char)
	left_text = left_side.text .. char
	draw_right_text(cr, x, y, left_text, left_side.style, {color=left_side.color})
	draw_left_text(cr, x + 10, y, right_side.text, right_side.style, {color=right_side.color})
end
