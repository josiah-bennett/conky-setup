-- [[ Lua Script to update the JSON-File for the Weather ]]

-- city_id (Antonsthal) = 2955876

-- load the http socket module
http = require 'socket.http'

-- the lua-json module has to be installed
-- load the json module
json = require 'json'

function update_current_weather(city_id, api_key)
	api_url = 'http://api.openweathermap.org/data/2.5/weather?'
	unit = 'metric' -- unit default, metric, imperial
	
	current_time = os.date('!%Y%m%d%H%M%S')
	
	make_cache = function (data)
		data.timestamp = current_time
		save = json.encode(data)
		cache:write(save)
	end
	
	weather_file = '/home/josiah/.weather/data/current-weather.json'
	if file_exists(weather_file) then
		cache = io.open(weather_file, 'r+')
		data = json.decode(cache:read("*a"))
		time_passed = os.difftime(current_time, data.timestamp)
	else
		cache = io.open(weather_file, 'w')
		cache:write('')
		time_passed = 6000
	end
	
	response = data
	if time_passed > 3000 then
		local full_url = string.format("%sid=%s&units=%s&appid=%s", api_url, city_id, unit, api_key)
		weather, status = http.request(full_url)
		if weather then
			cache:close()
			cache = io.open(weather_file, 'w+')
			response = json.decode(weather)
			make_cache(response)
		end
	end
	--print(time_passed)
	cache:close()
end



function file_exists(name)
	file = io.open(name, 'r')
	if not file then return false end
	io.close(file)
	return true
end

