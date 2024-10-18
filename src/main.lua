---@meta _
-- grabbing our dependencies,
-- these funky (---@) comments are just there
--	 to help VS Code find the definitions of things

---@diagnostic disable-next-line: undefined-global
local mods = rom.mods

---@module 'SGG_Modding-ENVY-auto'
mods['SGG_Modding-ENVY'].auto()
-- ^ this gives us `public` and `import`, among others
--	and makes all globals we define private to this plugin.
---@diagnostic disable: lowercase-global

---@diagnostic disable-next-line: undefined-global
rom = rom
---@diagnostic disable-next-line: undefined-global
_PLUGIN = _PLUGIN

-- get definitions for the game's globals
---@module 'game'
game = rom.game

---@module 'SGG_Modding-SJSON'
sjson = mods['SGG_Modding-SJSON']
---@module 'SGG_Modding-ModUtil'
modutil = mods['SGG_Modding-ModUtil']

---@module 'SGG_Modding-ReLoad'
reload = mods['SGG_Modding-ReLoad']

data = nil

rarities = {}
traits = {}
public.rarities = {}

function set_rarity(name,rarity)
	if restore ~= nil then
		data.rarities[name] = rarity
	end
	rarities[name] = rarity
	table.insert(public.rarities,rarity)
end

function set_trait(name,rarity)
	if restore ~= nil then
		data.traits[name] = rarity
	end
	traits[name] = rarity
end

function public.define_rarity(data)
	local name = data
	if type(data) == 'string' then
		data = {name = name}
	else
		name = data.name
	end
	if data.plugin == nil then
		local env = getfenv(2)
		if env ~= nil and env._PLUGIN then
			data.plugin = env._PLUGIN.guid
		end
	end
	set_rarity(name, data)
	if restore ~= nil then
		restore()
	end
end

local function on_ready()
	-- what to do when we are ready, but not re-do on reload.
	import 'ready.lua'
end

local function on_reload()
	-- what to do when we are ready, but also again on every reload.
	-- only do things that are safe to run over and over.
	
	import 'test.lua'
end

-- this allows us to limit certain functions to not be reloaded.
local loader = reload.auto_single()

-- this runs only when the game first loads a save per profile
modutil.once_loaded.save(function()
	loader.load(on_ready, on_reload)
end)