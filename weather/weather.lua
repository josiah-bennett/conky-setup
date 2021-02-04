-- [[ Lua Script to update the JSON-File for the Weather ]]

-- the lua-json module has to be installed
-- load the json module
json = require 'json'
PI = math.pi

function draw_weather_data(cr, x, y, paint_tree)
	-- Path to the JSON-File that contains the current weather data
	weather_file = '/home/josiah/.weather/data/current-weather.json'
	if file_exists(weather_file) then
		cache = io.open(weather_file, 'r')
		data = json.decode(cache:read("*a"))
	end
	-- the weather tree still needs to be implemented as a second option
	-- this is the implementation for the compass configuration
	radius = draw_compass(cairo, grid_centers[i].x, grid_centers[i].y) * 1.4
	draw_wind_data(cr, x - 160, y - 125, data)
	draw_weather_condition(cr, x - 115, y - 195, data)
	draw_temp_data(cr, x - 220, y - 50, data)
	draw_other_data(cr, x - 235, y - 5, data)
	draw_precipitation_data(cr, x - 200, y + 55, data)
end

function draw_wind_data(cr, x, y, data)
	v = data.wind.speed
	v_max = data.wind.gust
	v_max_str = (v_max ~= v_max and '' or v_max)
	deg = data.wind.deg
	
	r = 25
	vec = {r * math.sin(deg * PI/180), r * math.cos(deg * PI/180)}
	
	wind_color = Colors.nord14
	cairo_set_line_width(cr, 2)
	cairo_move_to(cr, x + vec[1], y + vec[2])
	cairo_line_to(cr, x - vec[1], y - vec[2])
	cairo_move_to(cr, x - (r-10) * math.sin((deg-10)*PI/180), y - (r-10) * math.cos((deg-10)*PI/180))
	cairo_line_to(cr, x - vec[1], y - vec[2])
	cairo_line_to(cr, x - (r-10) * math.sin((deg+10)*PI/180), y - (r-10) * math.cos((deg+10)*PI/180))
	cairo_set_source_rgba(cr, wind_color[1], wind_color[2], wind_color[3], 1)
	cairo_stroke(cr)
	
	cairo_set_source_rgba(cr, Colors.nord0[1], Colors.nord0[2], Colors.nord0[3], 1)
	cairo_move_to(cr, x + 30, y)
	cairo_arc(cr, x, y, 30, 0, 2*PI)
	cairo_stroke_preserve(cr)
	cairo_set_source_rgba(cr, Colors.nord4[1], Colors.nord4[2], Colors.nord4[3], 0.25)
	cairo_fill(cr)
	
	draw_left_text(cr, x + 40, y - 15, v, nil, {color=Colors.nord14})
	draw_left_text(cr, x + 40, y + 15, v_max_str, nil, {color=Colors.nord12})
end

function draw_weather_condition(cr, x, y, data)
	icon = string.sub(data.weather[1].icon, 1, 2) .. 'd'
	-- Path to the folder where weather-condition icons are stored
	icon_url = string.format('/home/josiah/.weather/icons/%s@2x.png', icon)
	if file_exists(icon_url) then
		image_surface = cairo_image_surface_create_from_png(icon_url)
		w = cairo_image_surface_get_width(image_surface)
		h = cairo_image_surface_get_height(image_surface)
		
		cairo_set_source_surface(cr, image_surface, x - 50, y - 50)
		cairo_paint(cr)
		cairo_surface_destroy(image_surface)
	end
	
	radius = 35
	cairo_set_source_rgba(cr, Colors.nord0[1], Colors.nord0[2], Colors.nord0[3], 1)
	cairo_move_to(cr, x + radius, y)
	cairo_arc(cr, x, y, radius, 0, 2*PI)
	cairo_stroke_preserve(cr)
	cairo_set_source_rgba(cr, Colors.nord7[1], Colors.nord7[2], Colors.nord7[3], 0.25)
	cairo_fill(cr)
	
	desc = data.weather[1].description
	clouds = data.clouds.all
	visibility = data.visibility
	vis_unit = 'm'
	if data.visibility >= 1000 then
		visibility = visibility / 1000
		vis_unit = 'km'
	end
	
	aligned_text(cr, x + 70, y - 15, {text='V', style=Styles.KEYWORDS}, {text=visibility..vis_unit}, ':')
	draw_left_text(cr, x + radius + 10, y + 15, desc)
	aligned_text(cr, x + 110, y + 45, {text='C', style=Styles.KEYWORDS}, {text=clouds..'%'}, ':')
end

function draw_temp_data(cr, x, y, data)
	temp_avg = data.main.temp
	feels_like = data.main.feels_like
	
	temp_max = data.main.temp_max
	temp_min = data.main.temp_min
	
	temp = string.format('T: %s°C [%s°C]', temp_avg, feels_like)
	-- temp interval is not currently used
	temp_inv = string.format('Tₘₐₓ: %s°C, Tₘᵢₙ: %s°C', temp_max, temp_min)
	
	draw_left_text(cr, x, y - 15, temp_avg .. '°C')
	draw_left_text(cr, x - 20, y + 15, '[' .. feels_like .. ']')
end

-- this needs a better name
function draw_other_data(cr, x, y, data)
	humidity = data.main.humidity
	pressure = data.main.pressure
	
	draw_right_text(cr, x + 90, y, pressure .. 'hPa')
	aligned_text(cr, x + 15, y + 30, {text='H', style=Styles.KEYWORDS}, {text=humidity .. '%'}, ':')
end

function draw_precipitation_data(cr, x, y, data)
	types = {'Rain', 'Snow'}
	type_str, last_hour, last_3hour = '', '', ''
	for i=1, 2 do
		itype = string.lower(types[i])
		type_str = (data[itype] and types[i]..':' or type_str)
		last_hour = (data[itype] and data[itype]['1h']..'mm' or last_hour)
		last_3hour = (data[itype] and (data[itype]['3h'] and data[itype]['3h']..'mm' or '') or last_3hour)
	end
	
	draw_left_text(cr, x - 10, y, type_str, Styles.KEYWORDS)
	draw_left_text(cr, x + 5, y + 30, last_hour)
	draw_left_text(cr, x + 5, y + 60, last_3hour)
end

function draw_suncycle_data(cr, x, y)
	-- Path to the JSON-File that contains the current weather data
	weather_file = '/home/josiah/.weather/data/current-weather.json'
	if file_exists(weather_file) then
		cache = io.open(weather_file, 'r')
		data = json.decode(cache:read("*a"))
	end
	
	date_format = '%H:%M:%S'
	sunrise = os.date(date_format, data.sys.sunrise)
	sunset = os.date(date_format, data.sys.sunset)
	-- the icon is the clear icon from the weather conditions
	icon_url = '/home/josiah/.weather/icons/01d@2x.png'
	if file_exists(icon_url) then
		image_surface = cairo_image_surface_create_from_png(icon_url)
		w = cairo_image_surface_get_width(image_surface)
		h = cairo_image_surface_get_height(image_surface)
		
		cairo_set_source_surface(cr, image_surface, x - 50, y - 50)
		cairo_paint(cr)
		cairo_surface_destroy(image_surface)
	end
	
	draw_left_text(cr, x + 35, y - 15, sunrise)
	draw_left_text(cr, x + 35, y + 15, sunset)
end

function file_exists(name)
	file = io.open(name, 'r')
	if not file then return false end
	io.close(file)
	return true
end

