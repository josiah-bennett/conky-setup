-- [[Lua Script for Processes List]]

function draw_process_list (cr, x, y, cmd, conf_list)
	-- options that can displayed
	list_options = {'name', 'pid', 'cpu', 'mem', 'mem_res', 'mem_vsize', 'time', 'uid', 'user', 'io_perc', 'io_read', 'io_write'}
	rq = RADIUS / 140
	
	n = 1
	opts = {}
	for i, _ in ipairs(conf_list) do
		-- conf_list determines which options are displayed
		if conf_list[i] == 1 then
			opts[n] = list_options[i]
			n = n + 1
		end
	end
	
	-- you might need to tweak these if options are different from default
	draw_centered_text(cr, x - 62.5*rq, y - 2.5*rq, opts[1], Styles.KEYWORDS, {font_size=10})
	draw_centered_text(cr, x, y - 2.5*rq, opts[2], Styles.KEYWORDS, {font_size=10})
	draw_centered_text(cr, x + 37.5*rq, y - 2.5*rq, opts[3], Styles.KEYWORDS, {font_size=10})
	draw_centered_text(cr, x + 75*rq, y - 2.5*rq, opts[4], Styles.KEYWORDS, {font_size=10})
	
	for i=1, 5 do
		line = create_process_string(cmd, i, opts)
		draw_centered_text(cr, x, y + i*8*rq, line, nil, {font_size=7.5})
	end
end

function create_process_string(cmd, number, list_opts)
	option_list = {}
	for i, _ in ipairs(list_opts) do
		option = conky_parse('${' .. cmd .. ' ' .. list_opts[i] .. ' ' .. number .. '}')
		option_list[i] = option
	end
	option_string = option_list[1]
	for i, _ in ipairs(option_list) do
		if i ~= 1 then
			option_string = option_string .. ', ' .. tostring(option_list[i])
		end
	end
	return option_string
end

-- top  processes are ranked from highest to lowest in terms of cpu usage
-- top_mem  sorted by mem usage instead of cpu
-- top_time  sorted by total CPU time instead of current CPU usage 
