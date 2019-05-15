require('Modes')
require('Gui')

function setup()
	AccuracyMode = M{['description']='Accuracy Mode', 'Normal', 'Mid', 'High'}
	
	WeaponMode = M{['description']='Weapon', 'Dojikiri Yasutsuna', 'Shining One'}
	
	EngagedMode = M{['description']='Engaged Mode', 'Normal', 'Hybrid', 'DT'}
	IdleMode = M{['description']='Idle Mode', 'Normal', 'Meva'}
	
	Obi_WS = T{ -- Any weaponskills we want to check weather/day and use the obi
		--'Cloudsplitter',
	}
	
	WeaponTable = {
		['Dojikiri Yasutsuna'] = {main="Dojikiri Yasutsuna", type='Greatkatana', img='SAM/Doji.png'},
		['Shining One'] = {main="Shining One", type='Polearm', img='SAM/Bismarck.png'}
	}
	
	selfCommandMaps = {
		['set']		= function(arg) _G[arg[1]]:set(table.concat(table.slice(arg, 2, -1)," ")); update_gear() end, 
		['toggle']	= function(arg) _G[arg[1]]:toggle(); update_gear() end,
		['cycle']	= function(arg) _G[arg[1]]:cycle(); update_gear() end,
		['cycleback']	= function(arg) _G[arg[1]]:cycleback(); update_gear() end,
		['update']	= update_gear,
		['cursna']	= function() equip(sets.Cursna) end,
		['cure']	= function() equip(sets.Cure) end,
		}
		
	build_GUI()
	bind_keys()
end

function get_sets()
	setup()
	
	Smertrio = {}
	Smertrio.Acc = {name="Smertrio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken -10%'}}
	Smertrio.WSD = {name="Smertrio's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken -10%'}}
		
	Valorous = {}
	Valorous.Body = {}
	Valorous.Body.STP = {name="Valorous Mail", augments={'INT+10','MND+4','"Store TP"+9','Mag. Acc.+1 "Mag.Atk.Bns."+1'}}
	Valorous.Body.MAB = {name="Valorous Mail", augments={'"Mag.Atk.Bns."+22','Weapon skill damage +3%','Accuracy+14 Attack+14','Mag. Acc.+17 "Mag.Atk.Bns."+17'}}

	sets.Obi = {waist="Hachirin-No-Obi"}
	
	sets.enmity = {
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		neck="Moonlight Necklace",
		waist="Kasiri Belt",
		ear1="Friomisi Earring",
		ear2="Cryptic Earring",
		ring1="Eihwaz Ring",
		ring2="Petrov Ring"
	}
	
	sets.precast = {}
	
	sets.JA = {}
	
	sets.JA['Hasso'] = {}
	sets.JA['Meditate'] = {}
	sets.JA['Warcry'] = {}
	sets.JA['Berserk'] = {}
	sets.JA['Tomahawk'] = {}
	sets.JA['Provoke'] = sets.enmity
	sets.JA['Aggressor'] = {}
	
	sets.precast = {
		ammo="Impatiens",
		body="Odyssean Chestplate",
		hands="Leyline Gloves",
		legs="Eschite Cuisses",
		feet="Odyssean Greaves",
		ear1="Loquacious Earring",
		ring1="Moonlight Ring",
		ring2="Prolix Ring"
	}
		
	sets.precast.Utsusemi = set_combine(sets.precast, {neck="Magoraga Beads"})
	
	sets.midcast = set_combine(sets.precast, {})
	
	sets.midcast.Utsusemi = set_combine(sets.precast.Utsusemi, {})
	
	-- Weaponskill Sets --
	-- format is sets.WS['Savage Blade']['Mighty Strikes']['Brazen Rush'].Fencer.TP[2000].Mid.Day
	-- Any value may be omitted, but they must be in order
	-- Buffs are calculated into TP.  Fencer is not
	
	sets.WS = {
		ammo="Seething Bomblet +1",
		head="Flamma Zucchetto +2",
		body="Flamma Korazin +2",
		--hands="Sulevia's Gauntlets +2",
		--legs="Sulevia's Cuisses +2",
		feet="Flamma Gambieras +2",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		ear1="Ishvara Earring",
		ear2="Moonshade Earring",
		ring1="Niqmaddu Ring",
		ring2="Regal Ring",
		back=Smertrio.WSD
	}
	
	sets.WS.Mid = set_combine(sets.WS, {
	})
	
	sets.WS.Acc = set_combine(sets.WS.Mid, {
	})
	
	-- Great Katana Weaponskills --
	
	sets.WS['Tachi: Jinpu'] = {
		ammo="Knobkierrie",
		head="Flamma Zucchetto +2",
		body=Valorous.Body.MAB,
		hands="Founder's Gauntlets",
		--legs=Odyssean.Legs.WS,
		feet="Founder's Greaves",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		ear1="Friomisi Earring",
		ear2="Moonshade Earring",
		ring1="Niqmaddu Ring",
		ring2="Regal Ring",
		back=Smertrio.WSD
	}
	
	
	-- Polearm Weaponskills --
	
	--sets.WS.Stardiver = {}
	
	--sets.WS['Impulse Drive'] = {} -- low TP set
	--sets.WS['Impulse Drive'].TP = {} -- leave blank
	--sets.WS['Impulse Drive'].TP[2000] = {} -- High TP set
	--sets.WS['Impulse Drive'].TP[2800] = {} -- Full TP set
	
	-- Idle Sets --
	
	sets.idle = {}
	sets.idle.Normal = {
		ammo="Staunch Tathlum +1",
		head="Valorous Mask",
		body="Souveran Cuirass +1",
		hands="Sulevia's Gauntlets +2",
		legs="Pummeler's Cuisses +3",
		feet="Pummeler's Calligae +3",
		neck="Sanctity Necklace",
		waist="Flume Belt +1",
		--ear1="Etoilation Earring",
		ear2="Infused Earring",
		ring1="Moonlight Ring",
		ring2="Defending Ring",
		back=Smertrio.Acc, -- Moonlight Cape		
	}
	
	sets.idle['Meva'] = set_combine(sets.idle.Normal, {
		
	})
	
	-- Engaged Sets --
	
	sets.engaged = {
		ammo="Ginsen",
		head="Flamma Zucchetto +2",
		body=Valorous.Body.STP,
		hands="Founder's Gauntlets",
		legs="Valorous Greaves",
		feet="Flamma Gambieras +2",
		neck="Ainia Collar",
		waist="Ioskeha Belt +1",
		ear1="Dedition Earring",
		ear2="Telos Earring",
		ring1="Niqmaddu Ring",
		ring2="Flamma Ring",
		back=Smertrio.Acc
	}
	
	sets.engaged.Mid = set_combine(sets.engaged, {
		body="Flamma Korazin +2",
	})
	
	sets.engaged.High = set_combine(sets.engaged.Mid, {
		ring2="Moonlight Ring" --"Regal Ring"
	})
	
	sets.engaged.Hybrid = {
		ammo="Staunch Tathlum +1",
		head="Flamma Zucchetto +2",
		body="Souveran Cuirass +1",
		hands="Sulevia's Gauntlets +2",
		legs="Pummeler's Cuisses +3",
		feet="Pummeler's Calligae +3",
		neck="War. Beads +1",
		waist="Ioskeha Belt +1",
		ear1="Telos Earring",
		ear2="Cessance Earring",
		ring1="Moonlight Ring",
		ring2="Defending Ring",
		back=Smertrio.Acc
	}
	
	sets.engaged.DT = {
		ammo="Staunch Tathlum +1",
		head="Souveran Schaller +1",
		body="Souveran Cuirass +1",
		hands="Souveran Handschuhs +1",
		legs="Souveran Diechlings +1",
		feet="Souveran Schuhs +1",
		neck="War. Beads +1",
		waist="Ioskeha Belt +1",
		ear1="Telos Earring",
		ear2="Odnowa Earring +1",
		ring1={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		ring2={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Smertrio.Acc
	}
	
	-- Status Swaps --
	
	sets.Blind = {hands="Regal Captain's Gloves"}
	
end

function bind_keys()
	send_command('bind f9 gs c cycle AccuracyMode')
	send_command('bind f10 gs c set EngagedMode Hybrid')
	send_command('bind f11 gs c set EngagedMode DT')
	send_command('bind f12 gs c set EngagedMode Normal')
end

function file_unload()
	send_command('unbind f9')
	send_command('unbind f10')
	send_command('unbind f11')
	send_command('unbind f12')
end

function build_GUI()
	GUI_pos = {}
	GUI_pos.x = 1732
	GUI_pos.y = 80

	EM = IconButton{
		x = GUI_pos.x + 0,
		y = GUI_pos.y + 0,
		var = EngagedMode,
		icons = {
			{img = 'DD Normal.png', value = 'Normal'},
			{img = 'DD Hybrid.png', value = 'Hybrid'},
			{img = 'Emergancy DT.png', value = 'DT'}
		},
		command = 'gs c update'
	}
	EM:draw()
	
	local wi = {}
	for i,v in ipairs(WeaponMode) do
		wi[i] = {img=WeaponTable[v].img, value=v}
	end
	WM = IconButton{
		x = GUI_pos.x + 0,
		y = GUI_pos.y + 54,
		var = WeaponMode,
		icons = wi,
		command = 'gs c update'
	}
	WM:draw()
	
	AccDisplay = TextCycle{
		x = GUI_pos.x + 0,
		y = GUI_pos.y + 54 * 4,
		var = AccuracyMode,
		align = 'left',
		width = 112,
		command = 'gs c update'
	}
	AccDisplay:draw()
	IdleDisplay = TextCycle{
		x = GUI_pos.x + 0,
		y = GUI_pos.y + 54 * 4 + 32,
		var = IdleMode,
		align = 'left',
		width = 112,
		command = 'gs c update'
	}
	IdleDisplay:draw()
end

function self_command(commandArgs)
	local commandArgs = commandArgs
	if type(commandArgs) == 'string' then
		commandArgs = T(commandArgs:split(' '))
		if #commandArgs == 0 then
			return
		end
	end
	local handleCmd = table.remove(commandArgs, 1)
	if selfCommandMaps[handleCmd] then
		selfCommandMaps[handleCmd](commandArgs)
	end	
end

function get_idle_set()
	return set_combine(sets.idle[IdleMode.value], {main=WeaponTable[WeaponMode.value].main})
end

function get_engaged_set() -- sets.engaged[DefenseMode].(DW or WeaponMode).Accuracy.AM3
	local equipset = sets.engaged
	if equipset[EngagedMode.value] then
		equipset = equipset[EngagedMode.value]
	end
	if equipset[WeaponMode.value] then -- sets.engaged[DefenseMode]
		equipset = equipset[WeaponMode.value]
	elseif equipset[WeaponTable[WeaponMode.value].type] then -- type is greatkatana or polearm or whatever
		equipset = equipset[WeaponTable[WeaponMode.value].type]
	end
	if equipset[AccuracyMode.value] then
		equipset = equipset[AccuracyMode.value]
	end
	if equipset.AM3 and buffactive['Aftermath: Lv.3'] then
		equipset = equipset.AM3
	end
	
	if buffactive['Flash'] or buffactive['Blindness'] then
		equipset = set_combine(equipset, sets.Blind)
	end
	
	equipset = set_combine(equipset, {main=WeaponTable[WeaponMode.value].main})
	return equipset	
end

function update_gear() -- will put on the appropriate engaged or idle set
	if player.status == 'Engaged' then
		equip(get_engaged_set())
	else
		equip(get_idle_set())
	end
end

slotmap = T{'sub','range','ammo','head','body','hands','legs','feet','neck','waist',
    'left_ear', 'right_ear', 'left_ring', 'right_ring','back','ear1','ear2','ring1','ring2'}
	
function emptyset(set)
	for k, v in pairs(set) do
		if slotmap:contains(k) then
			return false
		end		
	end
	return true
end

function pretarget(spell) -- Would also check range here, if we wanted to avoid getting 'too far'
	if spell.type == 'WeaponSkill' then
		if player.tp < 1000 or buffactive['Stun'] or buffactive['Terror'] or buffactive['Amnesia'] or buffactive['Sleep'] or buffactive['Petrification'] then
			cancel_spell()
		end
	end
end

function precast(spell, action)
	if spell.action_type == 'Magic' then
		if spell.name:contains('Utsusemi') then
			equip(sets.precast.Utsusemi)
		elseif sets.precast[spell.name] then
			equip(sets.precast[spell.name])
		elseif sets.precast[spell.skill] then
			equip(sets.precast[spell.skill])
		else
			equip(sets.precast)
		end
	elseif spell.type == 'WeaponSkill' then
		--local path = 'sets.WS' -- for debugging
		path = T{'WS'}
		local equipset = sets.WS
		if equipset[spell.name] then
			equipset = equipset[spell.name]
			path:append(spell.name)
		end
		if equipset[WeaponMode.value] then
			equipset = equipset[WeaponMode.value]
			path:append(WeaponMode.value)
		end
		if equipset.TP then -- sets.WS['Impulse Drive'].TP[2000].Mid will be used when over 2000 TP
			local t = 1000
			local use_tp_set = false
			for tp, set in pairs(equipset.TP) do
				if tp > t and (player.tp + (buffactive['warcry'] and 500 or 0)) > tp then
					 t = tp
					 use_tp_set = true
				 end
			end
			if use_tp_set then
				equipset = equipset.TP[t]
				path:append('TP')
				path:append(t)
			end
		end
		if equipset.AM3 and buffactive['Aftermath: Lv.3'] then
				equipset = equipset.AM3
				path:append('AM3')
		elseif equipset.AM and buffactive['Aftermath'] then
				equipset = equipset.AM
				path:append('AM')
		end    
		for i=AccuracyMode.index, 1, -1 do -- start at currently selected mode, then step down until a set exists
			if equipset[AccuracyMode[i]] then
				equipset = equipset[AccuracyMode[i]]
				path:append(AccuracyMode[i])
				break
			end
		end
		if equipset.Day then
			if world.time < 1020 or world.time >= 420 then
				equipset = equipset.Day
				path:append('Day')
			end
		elseif equipset.Night then
			if world.time >= 1020 or world.time < 420 then
				equipset = equipset.Night
				path:append('Night')
			end
		end
		
		if emptyset(equipset) then -- Climb down the tree till we find a set with gear in it
			for i = #path - 1, 1, -1 do
				table.remove(path, i + 1)
				local s = sets
				for j = 1, i, 1 do
					s = s[path[j]]
				end
				if not emptyset(s) then
					equipset = s
					break
				end
			end
		end
		
		if _settings.debug_mode then
            windower.add_to_chat(200, 'sets['..table.concat(path, '][')..']')
        end
        if Obi_WS:contains(spell.name) and (world.weather_element == spell.element or
                                            world.day_element == spell.element ) then
            equipset = set_combine(equipset, sets.Obi)
        end
        equip(equipset)
	elseif spell.name:contains('Waltz') then
		equip(sets.precast.Waltz)
	elseif spell.name:contains('Step') then
		equip(sets.precast.Step)
	elseif spell.type == 'JobAbility' then
		if sets.JA[spell.name] then
			equip(sets.JA[spell.name])
		end
	end		
end

function midcast(spell, action)
	if spell.action_type == 'Magic' then
		if spell.name:contains('Utsusemi') then
			equip(sets.midcast.Utsusemi)
		elseif sets.midcast[spell.name] then
			equip(sets.midcast[spell.name])
		elseif sets.midcast[spell.skill] then
			equip(sets.midcast[spell.skill])
		else
			equip(sets.midcast)
		end
	end
end

function aftercast(spell, action)
	update_gear()
end

function status_change(new, action)
	update_gear()
end

function buff_change(buff, gain)
	if T{'Blindness', 'Flash', 'Aftermath', 'Aftermath: Lv.3'}:contains(buff) then -- only update if it's a buff that affects engaged/idle choices
		update_gear()
	end
end



