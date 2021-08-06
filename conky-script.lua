--[[Lua Script for a hexagonal conky setup]]
-- This script uses the Ticking Timebomb BB / SF Digital Readout Font
-- the right Font has to be installed !!!
RADIUS = 140 -- hexagon radius (hopefully the only pixel based constant value)
PATH = '/home/josiah/Documents/conky-setup-main'

require 'cairo'
dofile(PATH .. '/designs.lua')
dofile(PATH .. '/utils/nord.lua')
dofile(PATH .. '/utils/text.lua')

function conky_main ()
	-- check if the conky window is implemented
	if conky_window == nil then return end

	local cairo_surface = cairo_xlib_surface_create (conky_window.display,
			conky_window.drawable, conky_window.visual, conky_window.width,
			conky_window.height)
	
	cairo = cairo_create(cairo_surface)
	--------------------------------------
	alignment = {v = 'bottom', h = 'right'} -- conky alignment see config
	size = {w = conky_window.width, h = conky_window.height}

	-- draw your design choice (see design.lua, Layout for options)
	draw_design(cairo, Layout.grid, size, alignment) 
	---------------------------------------
	cairo_destroy(cairo)
	cairo_surface_destroy(cairo_surface)
	cairo = nil
end
