_addon.name = 'Easy Spells'
_addon.version = '1.0'
_addon.author = 'Mynameisgonz'
_addon.commands = {'easyspells','es'}

local res = require('resources')
require 'luau'

function can_cast(spellName)
	local spell = res.spells:with('en',spellName)
	local spells = windower.ffxi.get_spells()
	if spell and spells then
		for spellId,bool in pairs(spells) do
			-- spell is learned
			if spell.id == spellId then
				local player = windower.ffxi.get_player()
				local mjob = player.main_job_id		
				local mlvl = player.main_job_level
				local sjob = player.sub_job_id
				local slvl = player.sub_job_level
				local jp = player.job_points[string.lower(player.main_job)].jp_spent
				if ((spell.levels[mjob] and mlvl >= spell.levels[mjob]) or (spell.levels[sjob] and slvl >= spell.levels[sjob])) or (spell.levels[mjob] and spell.levels[mjob] > 99 and jp and jp >= spell.levels[mjob]) then
					local recasts = windower.ffxi.get_spell_recasts()
					-- spell is not on cooldown
					if recasts and recasts[spellId] == 0 then
						-- player has mp to cost
						if windower.ffxi.get_player() and windower.ffxi.get_player().vitals.mp >= spell.mp_cost then
							return true
						end
					end
				end
			end
		end	
	end
	return false
end

spellbook = {}
-- elemental
spellbook["stone"] = {max=6,name="Stone"}
spellbook["stonega"] = {max=3,name="Stonega"}
spellbook["stonera"] = {max=3,name="Stonera"}
spellbook["geohelix"] = {max=2,name="Geohelix"}
spellbook["quake"] = {max=2,name="Quake"}
spellbook["water"] = {max=6,name="Water"}
spellbook["waterga"] = {max=3,name="Waterga"}
spellbook["watera"] = {max=3,name="Watera"}
spellbook["hydrohelix"] = {max=2,name="Hydrohelix"}
spellbook["flood"] = {max=2,name="Flood"}
spellbook["aero"] = {max=6,name="Aero"}
spellbook["aeroga"] = {max=3,name="Aeroga"}
spellbook["aerora"] = {max=3,name="Aerora"}
spellbook["anemohelix"] = {max=2,name="Anemohelix"}
spellbook["tornado"] = {max=2,name="Tornado"}
spellbook["fire"] = {max=6,name="Fire"}
spellbook["firaga"] = {max=3,name="Firaga"}
spellbook["fira"] = {max=3,name="Fira"}
spellbook["pyrohelix"] = {max=2,name="Pyrohelix"}
spellbook["flare"] = {max=2,name="Flare"}
spellbook["blizzard"] = {max=6,name="Blizzard"}
spellbook["blizzaga"] = {max=3,name="Blizzaga"}
spellbook["blizzara"] = {max=3,name="Blizzara"}
spellbook["cryohelix"] = {max=2,name="Cryohelix"}
spellbook["freeze"] = {max=2,name="Freeze"}
spellbook["thunder"] = {max=6,name="Thunder"}
spellbook["thundaga"] = {max=3,name="Thundaga"}
spellbook["thundara"] = {max=3,name="Thundara"}
spellbook["ionohelix"] = {max=2,name="Ionohelix"}
spellbook["burst"] = {max=2,name="Burst"}
spellbook["luminohelix"] = {max=2,name="Luminohelix"}
spellbook["noctohelix"] = {max=2,name="Noctohelix"}
-- healing (cures excluded)
spellbook["raise"] = {max=3,name="Raise"}
spellbook["reraise"] = {max=4,name="Reraise"}
-- enfeebling
spellbook["addle"] = {max=2,name="Addle"}
spellbook["blind"] = {max=3,name="Blind"}
spellbook["dia"] = {max=3,name="Dia"}
spellbook["distract"] = {max=3,name="Distract"}
spellbook["frazzle"] = {max=3,name="frazzle"}
spellbook["gravity"] = {max=2,name="Gravity"}
spellbook["paralyze"] = {max=2,name="Paralyze"}
spellbook["poison"] = {max=2,name="Poison"}
spellbook["sleep"] = {max=2,name="Sleep"}
spellbook["sleepga"] = {max=2,name="Sleepga"}
spellbook["slow"] = {max=2,name="Slow"}
-- enhancing
spellbook["aurorastorm"] = {max=2,name="Aurorastorm"}
spellbook["firestorm"] = {max=2,name="Firestorm"}
spellbook["flurry"] = {max=2,name="Flurry"}
spellbook["hailstorm"] = {max=2,name="Hailstorm"}
spellbook["haste"] = {max=2,name="Haste"}
spellbook["protect"] = {max=5,name="Protect"}
spellbook["protectra"] = {max=5,name="Protectra"}
spellbook["rainstorm"] = {max=2,name="Rainstorm"}
spellbook["refresh"] = {max=3,name="Refresh"}
spellbook["regen"] = {max=5,name="Regen"}
spellbook["sandstorm"] = {max=2,name="Sandstorm"}
spellbook["shell"] = {max=5,name="Shell"}
spellbook["shellra"] = {max=5,name="Shellra"}
spellbook["temper"] = {max=2,name="Temper"}
spellbook["thunderstorm"] = {max=2,name="Thunderstorm"}
spellbook["voidstorm"] = {max=2,name="Voidstorm"}
spellbook["windstorm"] = {max=2,name="Windstorm"}
-- dark
spellbook["aspir"] = {max=3,name="Aspir"}
spellbook["bio"] = {max=3,name="Bio"}
spellbook["drain"] = {max=3,name="Drain"}
spellbook["endark"] = {max=2,name="Endark"}
-- divine
spellbook["banish"] = {max=3,name="Banish"}
spellbook["banishga"] = {max=2,name="Banishga"}
spellbook["enlight"] = {max=2,name="Enlight"}
spellbook["holy"] = {max=2,name="Holy"}

tiers = {""," II"," III"," IV"," V"," VI"," VII"," VIII"," IX"," X"}

windower.register_event('addon command', function(...)
	command = command and command:lower() or 'help'
    local args = {...}
	for cat,spell in pairs(spellbook) do
		if string.lower(args[1]) == cat then
			check_tier(spell.max,spell.name)
		end
	end
end)

function check_tier(cat,name)
	local potential = nil
	for i=1,cat do
		local spell = name .. tiers[i]
		if can_cast(spell) then
			potential = spell
		end
	end
	if potential then
		cast_spell(potential,'t')
		return
	end
	print('EASYSPELL: You have no available spell for ' .. name)
end

function cast_spell(spell,target)
	windower.send_command('input /ma "' .. spell .. '" <' .. target .. '>')
end