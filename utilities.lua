-- utilities.lua
-- Functions shared among plugins.

function get_word(s, i) -- get the indexed word in a string

	s = s or ''
	i = i or 1

	local t = {}
	for w in s:gmatch('%g+') do
		table.insert(t, w)
	end

	return t[i] or false

end

function string:input() -- Returns the string after the first space.
	if not self:find(' ') then
		return false
	end
	return self:sub(self:find(' ')+1)
end

function string:sec2() -- Returns the string after the first space.
	if not self:find(' ') then
		return false
	end
	t = self:sub(self:find(' ')+1)
	if not t:find(' ') then
		return nil
	end
	return t:sub(t:find(' ')+1)
end

function is_owner(msg)
	local var = false
  	local groups = load_data('groups.json')
  
    if groups[tostring(msg.chat.id)]['owner'] == tostring(msg.from.id) then
        var = true
    end
    
    if msg.from.id == config.admin then
		var = true
	end
  	
  	return var
end

function is_mod(msg)
	local var = false
  	local groups = load_data('groups.json')
  	
  	if groups[tostring(msg.chat.id)]['owner'] == tostring(msg.from.id) then
        var = true
    end
    
    if groups[tostring(msg.chat.id)]['mods'][tostring(msg.from.id)] then
    	var = true
    end
     
    if msg.from.id == config.admin then
		var = true
	end
  	
    return var
end

function is_locked(msg, cmd)
	local var = false
  	local data = load_data('groups.json')
  	if data[tostring(msg.chat.id)]['settings'][tostring(cmd)] == 'yes' then
  		var = true
  	end
  	return var
end

function mystat(cmd)
	stat = load_data('statsbot.json')
	n = stat[tostring(cmd)]
	n = n+1
	stat[tostring(cmd)] = tonumber(n)
	save_data('statsbot.json', stat)
	print('Stats saved', cmd)
end	

 -- I swear, I copied this from PIL, not yago! :)
function string:trim() -- Trims whitespace from a string.
	local s = self:gsub('^%s*(.-)%s*$', '%1')
	return s
end

local lc_list = {
-- Latin = 'Cyrillic'
	['A'] = 'А',
	['B'] = 'В',
	['C'] = 'С',
	['E'] = 'Е',
	['I'] = 'І',
	['J'] = 'Ј',
	['K'] = 'К',
	['M'] = 'М',
	['H'] = 'Н',
	['O'] = 'О',
	['P'] = 'Р',
	['S'] = 'Ѕ',
	['T'] = 'Т',
	['X'] = 'Х',
	['Y'] = 'Ү',
	['a'] = 'а',
	['c'] = 'с',
	['e'] = 'е',
	['i'] = 'і',
	['j'] = 'ј',
	['o'] = 'о',
	['s'] = 'ѕ',
	['x'] = 'х',
	['y'] = 'у',
	['!'] = 'ǃ'
}

function latcyr(str) -- Replaces letters with corresponding Cyrillic characters.
	for k,v in pairs(lc_list) do
		str = string.gsub(str, k, v)
	end
	return str
end

function load_data(filename) -- Loads a JSON file as a table.

	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)

	return data

end

function save_data(filename, data) -- Saves a table to a JSON file.

	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()

end

 -- Gets coordinates for a location. Used by gMaps.lua, time.lua, weather.lua.
function get_coords(input)

	local url = 'http://maps.googleapis.com/maps/api/geocode/json?address=' .. URL.escape(input)

	local jstr, res = HTTP.request(url)
	if res ~= 200 then
		return config.errors.connection
	end

	local jdat = JSON.decode(jstr)
	if jdat.status == 'ZERO_RESULTS' then
		return config.errors.results
	end

	return {
		lat = jdat.results[1].geometry.location.lat,
		lon = jdat.results[1].geometry.location.lng
	}

end
