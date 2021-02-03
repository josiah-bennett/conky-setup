-- [[Lua Script for Processes List]]

function draw_process_list (cr, x, y, cmd, conf_list)
	list_options = {'name', 'pid', 'cpu', 'mem', 'mem_res', 'mem_vsize', 'time', 'uid', 'user', 'io_perc', 'io_read', 'io_write'}
	
	n = 1
	opts = {}
	for i=1, table.getn(conf_list) do
		if conf_list[i] == 1 then
			opts[n] = list_options[i]
			n = n + 1
		end
	end
	
	-- you might need to tweak these if options are different from default
	draw_centered_text(cr, x - 125, y - 5, opts[1], Styles.KEYWORDS, {font_size=20})
	draw_centered_text(cr, x, y - 5, opts[2], Styles.KEYWORDS, {font_size=20})
	draw_centered_text(cr, x + 75, y - 5, opts[3], Styles.KEYWORDS, {font_size=20})
	draw_centered_text(cr, x + 150, y - 5, opts[4], Styles.KEYWORDS, {font_size=20})
	
	for i=1, 5 do
		line = create_process_string(cmd, i, opts)
		draw_centered_text(cr, x, y + i*16, line, nil, {font_size=15})
	end
end

function create_process_string(cmd, number, list_opts)
	option_list = {}
	for i=1, table.getn(list_opts) do
		option = conky_parse('${' .. cmd .. ' ' .. list_opts[i] .. ' ' .. number .. '}')
		option_list[i] = option
	end
	option_string = option_list[1]
	for i=2, table.getn(option_list) do
		option_string = option_string .. ', ' .. tostring(option_list[i])
	end
	return option_string
end

-- top  processes are ranked from highest to lowest in terms of cpu usage
-- top_mem  sorted by mem usage instead of cpu
-- top_time  sorted by total CPU time instead of current CPU usage 
