-- [[Lua Script for Hexagonal Design Structures]]
dofile(PATH .. '/utils/hexagon.lua')
dofile(PATH .. '/clock.lua')
dofile(PATH .. '/system-info.lua')
dofile(PATH .. '/process.lua')

--dofile(PATH .. '/weather/weather.lua')
--dofile(PATH .. '/weather/update_weather.lua')
--dofile(PATH .. '/weather/weather_compass.lua')
-- this next line is also not really needed
--dofile(PATH .. '/private.lua')

-- Alignments
V_Alignment = {
	top = {1, 0},
	bottom = {-1, 1},
	center = {0, 0},
}
H_Alignment = {
	right = {1, 0},
	left = {-1, 1},
	center = {0, 0},
}

-- Layout
Layout = {
	grid = 'grid',
	
}

function draw_design(cr, layout, size, alignment)
	if layout == Layout.grid then
		grid_centers = draw_hex_grid(cr, size, alignment)
		configure_hex_grid(cr, grid_centers, V_Alignment[alignment.v])
	else
		
	end
end

function draw_hex_grid(cr, size, alignment)
	grid_centers = {}
	y_distance = math.sqrt(3) * RADIUS
	v_align = V_Alignment[alignment.v]
	h_align = H_Alignment[alignment.h]
	bg_color = Colors.nord0

	i = 1
	for x_i=1,4,1.5 do
		start_index = x_i - math.floor(x_i)
		stop_index = start_index + math.floor(x_i / 3) + 2
		
		for y_i=start_index,stop_index do
			-- Calculate center Coords
			x = h_align[1] * x_i * RADIUS + h_align[2] * size.w
			y = v_align[1] * y_i * y_distance + v_align[2] * size.h
			center = {x=x, y=y}
			
			draw_hexagon(cairo, x, y, RADIUS, bg_color)
			grid_centers[i] = center
			i = i + 1
		end
	end
	return grid_centers
end

function configure_hex_grid(cr, grid_centers, vertical)
	config = {}
	if vertical == V_Alignment.top then
		config = {1, 2, 3, 4, 5, 6}
	elseif vertical == V_Alignment.bottom then
		config = {1, 2, 4, 6, 5, 3}
	else
		
	end
	draw_configured_grid(cr, grid_centers, config, vertical)
end

function draw_configured_grid(cr, grid_centers, config, vertical)
	rq = RADIUS / 140
	
	i = config[1];
	draw_system_info(cairo, grid_centers[i].x, grid_centers[i].y, vertical)
	
	i = config[2]; 
	draw_battery_info(cairo, grid_centers[i].x - 50*rq, grid_centers[i].y - 75*rq)
	draw_ram_info(cairo, grid_centers[i].x + 90*rq, grid_centers[i].y - 12*rq)
	draw_cpu_info(cairo, grid_centers[i].x, grid_centers[i].y + 50*rq)

	i = config[3];
	draw_storage_info(cairo, grid_centers[i].x - 50*rq, grid_centers[i].y - 75*rq)
	--draw_graphics_info(cairo, grid_centers[i].x, grid_centers[i].y)
	draw_network_info(cairo, grid_centers[i].x + 10*rq, grid_centers[i].y + 30*rq)
	
	i = config[4];
	clock_radius = RADIUS * 5/7
	draw_clock(cairo, grid_centers[i].x, grid_centers[i].y, clock_radius)
	--draw_suncycle_data(cairo, grid_centers[i].x - 80, grid_centers[i].y + 100)
	
	--name, pid, cpu, mem, mem_res, mem_vsize, time, uid, user, io_perc, io_read, io_write
	conf_options = {1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0}
	i = config[5]; 
	draw_process_list(cairo, grid_centers[i].x, grid_centers[i].y - 75*rq, 'top', conf_options)
	draw_process_list(cairo, grid_centers[i].x, grid_centers[i].y - 20*rq, 'top_mem', conf_options)
	draw_network_info(cairo, grid_centers[i].x + 10*rq, grid_centers[i].y + 50*rq)
	
	i = config[6];
	-- uncomment next line and insert your City ID and API Key
	-- update_current_weather('city-ID', 'API-Key')
	-- You can delete this line for your conky setup
	--private_data()
	--draw_weather_data(cairo, grid_centers[i].x, grid_centers[i].y, false)
	
	-- print(grid_centers[i].x)
	-- print(grid_centers[i].y)
end
