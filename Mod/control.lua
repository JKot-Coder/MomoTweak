local debugmode = settings.startup["momo-is-debug-mode"].value
local factor = settings.startup["momo-evo-reduce-factor"].value

script.on_event(defines.events.on_player_created, function(event)
  if debugmode then
      for _, player in pairs(game.players) do
          player.color = {r = 0, g = 204/255, b = 153/255, a = 1}
      end
  end
 end)

script.on_event("momo-debug", function(e)
	if debugmode then
	-- check bar item
		local logging = ""
		for pi, p in pairs(game.players) do
			p.print("evolution decrease factor = " .. factor)
			p.print("||||| N player index " .. pi)
			local slot = 1
			for name, count in pairs(p.get_main_inventory().get_contents()) do
				p.print("["..slot.."]" .. name .. " " .. count)
				logging = logging .. " " .. name .. " "
				slot = slot + 1
			end
			p.print("QUICK-BAR loop complete!!!")
			log("MTKL " .. logging)
		end
	-- check bar item
	else
		for pi, p in pairs(game.players) do p.print("Someone try to cheat!!!!!!!!!!!!") end
	end
end)

local function printToAll(text)
	for i, p in pairs(game.players) do
		p.print(text)
	end
end

local function buildVariable()
	if not (global.momoTweak) then
		global.momoTweak = {}
	end
	if not (global.momoTweak.last_evo) then
		global.momoTweak.last_evo = 0
	end
	if not (global.momoTweak.counter) then
		global.momoTweak.counter = 0
	end
end

local function addition_reduce_cal(current_evo, factor, progress)
	local counter = global.momoTweak.counter
	counter = counter + 1
	local result = progress * 0.000005 * counter
	if (counter >= 10) then
		counter = 0
	end
	
	global.momoTweak.counter = counter
	return result
end

local function evolution_nulifier(current_evo, last_evo, factor)
	local rand = (current_evo * 100101477) * (last_evo * 100045587)
	local chance = (1 + (factor - 0.7)) * (last_evo * 50)
	local null = 0
	if ((rand % 100) <= chance) then null = current_evo - last_evo end
	if (debugmode) then
		local function fixed(number, fix) 
			fix = fix or "%.0f"
			return string.format(fix, number) 
		end
		local text = "Random: " ..fixed(rand % 100).. " - " ..fixed(chance).. " | null => " .. null
		printToAll(text)
	end
	return null
end

local rate = 3600

script.on_nth_tick(rate, function(e)
	if factor ~= 0 then
		buildVariable()
		
		local current_evo = game.forces.enemy.evolution_factor
		local progress = 1
		if current_evo >= 0.8 then
			progress = factor * 18
		elseif current_evo >= 0.6 then
			progress = factor * 6
		elseif current_evo >= 0.3 then
			progress = factor * 2
		end
		
		local addition_reduce = 0
		if (current_evo >= 0.4) then
			addition_reduce = addition_reduce_cal(current_evo, factor, progress)
		end
		
		local null = 0
		if (current_evo >= 0.5) then
			null = evolution_nulifier(current_evo, global.momoTweak.last_evo, factor)
		end
		
		local reduceByRate = math.max(0, (current_evo - global.momoTweak.last_evo) * progress * 0.01)
		
		local reduce = (0.00005 * progress) + reduceByRate + addition_reduce + null
		
		game.forces.enemy.evolution_factor = current_evo - reduce
		global.momoTweak.last_evo = game.forces.enemy.evolution_factor
		if (debugmode) then
			local logtext = "Evolution reduce by " .. string.format("%.5f", reduce) .. " | Rate: " .. string.format("%.5f", reduceByRate) 
				  .. " | Counter: " .. global.momoTweak.counter .. "=>" .. string.format("%.5f", addition_reduce)
			printToAll(logtext)
			log(logtext)
		end
	end
end)
