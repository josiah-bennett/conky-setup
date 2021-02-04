--[[Lua Script for a hexagonal conky setup]]
-- This script uses the Ticking Timebomb BB / SF Digital Readout Font
-- the right Font has to be installed !!!
PATH = '/home/josiah/.config/conky'

require 'cairo'
dofile(PATH .. '/utils/hexagon.lua')
dofile(PATH .. '/utils/nord.lua')
dofile(PATH .. '/utils/text.lua')

dofile(PATH .. '/clock.lua')
dofile(PATH .. '/system-info.lua')
dofile(PATH .. '/process.lua')

dofile(PATH .. '/weather/weather.lua')
dofile(PATH .. '/weather/update_weather.lua')
dofile(PATH .. '/weather/weather_compass.lua')
-- this next line is also not really needed
dofile(PATH .. '/private.lua')

function conky_main ()
	-- check if the conky window is implemented
	if conky_window == nil then return end

	local cairo_surface = cairo_xlib_surface_create (conky_window.display,
			conky_window.drawable, conky_window.visual, conky_window.width,
			conky_window.height)
	
	cairo = cairo_create(cairo_surface)
	---------------------------------------
	
	radius = 280
	bg_color = Colors.nord0

	grid_centers = draw_hex_grid(cairo, radius, bg_color)
	
	i = 1; draw_system_info(cairo, grid_centers[i].x, grid_centers[i].y)
	
	i = 4; 
	draw_clock(cairo, grid_centers[i].x, grid_centers[i].y, 200)
	draw_suncycle_data(cairo, grid_centers[i].x - 80, grid_centers[i].y + 100)
	
	i = 2; 
	draw_battery_info(cairo, grid_centers[i].x - 100, grid_centers[i].y - 150)
	draw_ram_info(cairo, grid_centers[i].x + 180, grid_centers[i].y - 25)
	draw_cpu_info(cairo, grid_centers[i].x, grid_centers[i].y + 100)
	
	i = 3;
	draw_storage_info(cairo, grid_centers[i].x - 100, grid_centers[i].y - 150)
	--draw_graphics_info(cairo, grid_centers[i].x, grid_centers[i].y)
	draw_network_info(cairo, grid_centers[i].x, grid_centers[i].y + 40)
	
	--name, pid, cpu, mem, mem_res, mem_vsize, time, uid, user, io_perc, io_read, io_write
	conf_options = {1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0}
	i = 5; 
	draw_process_list(cairo, grid_centers[i].x, grid_centers[i].y - 170, 'top', conf_options)
	draw_process_list(cairo, grid_centers[i].x, grid_centers[i].y - 60, 'top_mem', conf_options)
	
	i = 6;
	-- uncomment next line and insert your City ID and API Key
	-- update_current_weather('city-ID', 'API-Key')
	-- You can delete this line for your conky setup
	private_data()
	draw_weather_data(cairo, grid_centers[i].x, grid_centers[i].y, false)
	
	-- print(grid_centers[i].x)
	-- print(grid_centers[i].y)
	---------------------------------------
	cairo_destroy(cairo)
	cairo_surface_destroy(cairo_surface)
	cairo = nil
end

