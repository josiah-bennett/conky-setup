-- [[Lua Script for the Systeminfo]]
require 'io'

function draw_system_info (cr, x, y, vertical)
	name = conky_parse('${execi 86400 whoami}') .. '@' .. conky_parse('$nodename')

	kernel = conky_parse('$kernel')
	kernel_left = {text='Kernel', style=Styles.KEYWORDS}
	kernel_right = {text=kernel}

	system = conky_parse('${sysname}') .. ' ' .. conky_parse('$machine')
	system_left = {text='System', style=Styles.KEYWORDS}
	system_right = {text=system}

	uptime = conky_parse('$uptime')
	uptime_left = {text='Uptime', style=Styles.KEYWORDS}
	uptime_right = {text=uptime}

	-- monitor = conky_parse('$monitor') .. '/' .. conky_parse('$monitor_number')
	-- draw_centered_text(cr, x, y + 120, 30, Colors.nord4, monitor)

	desktop = '(' .. conky_parse('$desktop') .. '/' .. conky_parse('$desktop_number') .. ')'
	desktop_name = conky_parse('$desktop_name') .. ' '
	desktop_left = {text=desktop_name, color=Colors.nord4}
	desktop_right = {text=desktop, color=Colors.nord4}

	if vertical == V_Alignment.top then
		i = 1
	elseif vertical == V_Alignment.bottom then
		i = -1
	else
		i = 0
	end
	
	draw_centered_text(cr, x, y + i * 15/140*RADIUS, name, Styles.HEADER)
	aligned_text(cr, x - 5/28*RADIUS, y + i * 32/140*RADIUS, kernel_left, kernel_right, ':')
	aligned_text(cr, x - 5/28*RADIUS, y + i * 48/140*RADIUS, system_left, system_right, ':')
	aligned_text(cr, x - 5/28*RADIUS, y + i * 27/56*RADIUS, uptime_left, uptime_right, ':')
	aligned_text(cr, x + 7/28*RADIUS, y + i * 35/56*RADIUS, desktop_left, desktop_right, ':')
end

-- check the special Characters
function draw_battery_info (cr, x, y)
	percentage = conky_parse('$battery_percent')

	time = string.gsub(conky_parse('$battery_time'), '%d+s', '')
	status = conky_parse('$battery_short')
	status = string.gsub(status, 'D', '↓')
	status = string.gsub(status, 'C', '↑')
	
	p = tonumber(percentage)
	if p <= 10 then color = Colors.nord11
	elseif p <= 20 then color = Colors.nord12
	elseif p <= 30 then color = Colors.nord13
	else color = Colors.nord14
	end
	
	radius = 5/28 * RADIUS
	
	draw_hex_indicator(cr, x, y, radius, {color}, {percentage})
	
	draw_centered_text(cr, x + 5/14*RADIUS, y - 11/56*RADIUS, 'Battery', Styles.KEYWORDS)
	draw_left_text(cr, x + radius + 1/28*RADIUS, y - 1/14*RADIUS, time)
	draw_left_text(cr, x + radius + 1/28*RADIUS, y + 1/14*RADIUS, status)
end

function draw_ram_info (cr, x, y)
	pattern = '%d+[,]?%d*'
	
	memory = conky_parse('$mem')
	memory_size = string.gsub(memory, pattern, '')
	memory = string.gsub(memory, memory_size, '')
	memory_num = memory_to_number(memory, memory_size)
	
	memory_free = conky_parse('$memfree')
	memory_free_size = string.gsub(memory_free, pattern, '')
	memory_free = string.gsub(memory_free, memory_free_size, '')
	memory_free_num = memory_to_number(memory_free, memory_free_size)
	
	memory_easy = conky_parse('$memeasyfree')
	memory_easy_size = string.gsub(memory_easy, pattern, '')
	memory_easy = string.gsub(memory_easy, memory_easy_size, '')
	memory_easy_num = memory_to_number(memory_easy, memory_easy_size) - memory_free_num
	memory_easy_str = memory_easy_num / 1000 
	
	memory_max = conky_parse('$memmax')
	memory_max_size = string.gsub(memory_max, pattern, '')
	memory_max = string.gsub(memory_max, memory_max_size, '')
	memory_max_num = memory_to_number(memory_max, memory_max_size)
	
	memory_percent = memory_num / memory_max_num * 100
	memory_percent_free = memory_free_num / memory_max_num * 100
	memory_percent_easy = memory_easy_num / memory_max_num * 100
	
	radius = 5/28 * RADIUS
	
	percentage_list = {memory_percent, memory_percent_easy, memory_percent_free}
	color_list = {Colors.nord11, Colors.nord13, Colors.nord14}
	
	if memory_percent == memory_percent then
		draw_hex_indicator(cr, x, y, radius, color_list, percentage_list)
	end
	
	draw_centered_text(cr, x - 15/56*RADIUS, y - 6/28*RADIUS, 'RAM', Styles.KEYWORDS)
	draw_right_text(cr, x - radius - 1/14*RADIUS, y - 1/10*RADIUS, 'Free : ' .. memory_free)
	draw_right_text(cr, x - radius - 1/14*RADIUS, y, 'Easy : ' .. memory_easy_str)
	draw_right_text(cr, x - radius - 1/14*RADIUS, y + 1/10*RADIUS, 'Used : ' .. memory)
	draw_centered_text(cr, x, y, memory_max)
end

function memory_to_number (memory_string, memory_size)
	if memory_size == 'GiB' then
		int = string.gsub(memory_string, '%,%d*', '')
		real = string.gsub(memory_string, '%d+,', '')
		number = tonumber(int) * 1000 + tonumber(real) * 10 ^ (3 - string.len(real))
	else
		number = tonumber(memory_string)
	end
	if number == nil then
		number = 1
	end
	return number
end

function draw_cpu_info (cr, x, y)
	radius_s = 5/56 * RADIUS
	radius = 5/28 * RADIUS
	
	cpu = conky_parse('${cpu cpu0}')
	
	-- get the info for the CPU Core Load and store it in a list
	cpu_cores = {}
	core_count = 8
	for i=1, core_count do
		cpu_i = conky_parse('${cpu cpu' .. i .. '}')
		cpu_cores[i] = cpu_i
	end
	
	ind_color = Colors.nord14
	
	draw_centered_text(cr, x - 2/14*RADIUS, y - 13/56*RADIUS, 'CPU', Styles.KEYWORDS)
	
	draw_centered_text(cr, x - 15/28*RADIUS, y - 1/14*RADIUS, cpu .. '%')
	draw_hex_indicator(cr, x - 15/28*RADIUS, y - 1/14*RADIUS, radius, {ind_color}, {cpu})
	
	temperature = string.gsub(conky_parse('${execi 10 sensors | grep \'Core 0\' | awk {\'print $3\'}}'), '+', '')
	aligned_text(cr, x + 5/56*RADIUS, y - 3/28*RADIUS, {text='Temp.'}, {text=temperature}, ':')
	
	freq_avg = 0
	for i=1, core_count do
		frequency = conky_parse('${freq ' .. i .. '}')
		freq_avg = freq_avg + tonumber(frequency)
	end
	freq_avg = math.ceil(freq_avg / core_count)
	aligned_text(cr, x + 5/56*RADIUS, y, {text='Freq.'}, {text=freq_avg .. 'MHz'}, ':')
	
	draw_right_text(cr, x - 2/7*RADIUS, y + 5/28*RADIUS, 'Cores:')
	row_n = 4
	for i=1, row_n do
		xi = x - 11/28*RADIUS + (i * 3/14*RADIUS)
		draw_hex_indicator(cr, xi, y + 5/28*RADIUS, radius_s, {ind_color}, {cpu_cores[i]})
		draw_centered_text(cr, xi, y + 5/28*RADIUS, i, nil, {font_size=10})
		xi = xi - radius_s
		draw_hex_indicator(cr, xi, y + 5/14*RADIUS, radius_s, {ind_color}, {cpu_cores[i+row_n]})
		draw_centered_text(cr, xi, y + 5/14*RADIUS, i + row_n, nil, {font_size=10})
	end
end

function draw_storage_info (cr, x, y)
	ind_color = Colors.nord14
	radius = 5/28 * RADIUS
	
	--diskio = conky_parse('$diskio')
	diskio_read = conky_parse('${diskio_read /dev/nvme0n1p3}')
	diskio_write = conky_parse('${diskio_write /dev/nvme0n1p3}')
	
	draw_left_text(cr, x + 15/56*RADIUS, y + 1/14*RADIUS, diskio_read)
	draw_left_text(cr, x + 15/56*RADIUS, y + 5/28*RADIUS, diskio_write)
	
	main_fs_used = string.gsub(conky_parse('${fs_used /}'), 'iB', '')
	main_fs_perc = tonumber(conky_parse('${fs_used_perc /}'))
	main_fs_size = string.gsub(conky_parse('${fs_size /}'), 'iB', '')
	
	draw_centered_text(cr, x + 10/28*RADIUS, y - radius, 'Storage', Styles.KEYWORDS)
	
	draw_hex_indicator(cr, x, y, radius, {ind_color}, {main_fs_perc})
	draw_left_text(cr, x + radius + 1/28*RADIUS, y - 3/56*RADIUS, main_fs_used .. '/' .. main_fs_size)
	
end

function draw_graphics_info(cr, x, y)
	-- I don't really know how to implement this method
	-- This method may not be even neccessary
end

function draw_network_info (cr, x, y)
	route_url = '/proc/net/route'
	status = 'connected'
	status_color = Colors.nord14
	if string.find(read_file('/proc/net/route'), 'wlp2s0') ~= nil then
		route = 'wlp2s0'
		address = conky_parse('${addr ' .. route .. '}')
	elseif string.find(read_file('/proc/net/route'), 'eth0') ~= nil then
		route = 'eth0'
		address = conky_parse('${addr ' .. route .. '}')
	else
		route = ''; address = ''
		status = 'disconnected'
		status_color = Colors.nord11
	end
	address = '0.0.0.0'
	
	internet = 'TRUE'
	--internet = check_connection(status)
	
	downspeed = conky_parse('${downspeed ' .. route .. '}')
	total_down = conky_parse('${totaldown ' .. route .. '}')
	text_down = downspeed .. '/' .. total_down
	
	upspeed = conky_parse('${upspeed ' .. route .. '}')
	total_up = conky_parse('${totalup ' .. route .. '}')
	text_up = upspeed .. '/' .. total_up
	
	draw_centered_text(cr, x, y - 13/56*RADIUS, 'Network', Styles.KEYWORDS)
	
	aligned_text(cr, x - 15/56*RADIUS, y - 3/28*RADIUS, {text='ip', style=Styles.KEYWORDS}, {text=address}, ':')
	aligned_text(cr, x - 15/56*RADIUS, y, {text='down ↓', style=Styles.KEYWORDS}, {text=text_down}, ':')
	aligned_text(cr, x - 15/56*RADIUS, y + 3/28*RADIUS, {text='up ↑', style=Styles.KEYWORDS}, {text=text_up}, ':')
	aligned_text(cr, x - 15/56*RADIUS, y + 13/56*RADIUS, {text='status', style=Styles.KEYWORDS}, {text=status, color=status_color}, ':')
	draw_left_text(cr, x - 13/56*RADIUS, y + 19/56*RADIUS, internet, nil, {color=access_color})
	
	-- somehow get an image to display different for Wlan and Ethernet use
	-- path for both is : /usr/share/icons/Zafiro-icons/panel/22/nm-signal-100.svg
	--              and : /usr/share/icons/Zafiro-icons/panel/22/network-transmit-receive.svg
	-- image = conky_parse('${image /usr/share/icons/Zafiro-icons/panel/16/nm-signal-100.svg -p ' .. x .. ',' .. y .. ' -s 16x16}')
end

-- run this function in its own thread !!!
function check_connection(status)
	internet = 'No Internet'
	access_color = Colors.nord11
	if status == 'connected' then
		local handler = io.popen("ping -c 3 -i 0.5 www.youtube.com")
		local response = handler:read('*a')
		-- print(response)
		local i_1, i_2 = string.find(response, '%d received')
		if i_1 ~= nil and i_2 ~= nil then
			local search = string.sub(response, i_1, i_2)
			if string.sub(search, string.find(search, '%d')) ~= 0 then
				internet = 'Internet'
				access_color = Colors.nord14
			end
		end
	end
	return internet
end

open = io.open

function read_file (path)
    local file = open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

