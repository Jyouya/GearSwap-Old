
--Global Variables:
-- defense_mode -- Turtle, hybrid, or DD
-- ws_mode
-- accuracy_mode


function get_sets()
	-- Hotkeys for setting gearswap parameters
	send_command('bind !f9 gs c reequip')
	
	send_command('bind f9 gs c cycle Acc')
	send_command('bind ^f9 gs c cycle WS')
	send_command('bind f10 gs c switch Turtle')
	send_command('bind ^f10 gs c cycle Turtle')
	send_command('bind f11 gs c switch Hybrid')
	send_command('bind ^f11 gs c cycle Hybrid')
	send_command('bind f12 gs c switch DD')
	send_command('bind ^f12 gs c cycle DD')
	send_command('bind ^!f9 rm shoot') -- target and ra
	send_command('bind ^!f10 rm ws')
	
	send_command('bind ^!f11 send Jyouyaya //gs rh clear')
	
	-- Hotkeys for JAs
	send_command('bind !` input /ja "Vivacious Pulse" <me>')
	if player.sub_job == 'WAR' then
		send_command('bind ^` input /ja "Provoke" <t>')
	elseif player.sub_job == 'DRK' then
		send_command('bind ^` input /ja "Last Resort" <me>')
	elseif player.sub_job == 'SAM' then
		send_command('bind ^` input /ja "Hasso" <me>') 
	elseif player.sub_job == 'BLU' then
		send_command('bind ^` input /ma "Blank Gaze" <t>')
	end -- consider something for blu/dnc.  Shadows for nin, implement waltz/shadow stepdown
	
	-- initialize globals
	local f = io.open('E:/Apps/Windower4/Addons/GearSwap/data/vars.RUN.txt','r')
	--local f = io.open('data/vars.RUN.txt','r')
	default_weapon = {
		main=f:read('*line'),
		sub=f:read('*line')}
	f:close()
	
	if player.sub_job == 'BLU' then
		send_command('input /macro book 4;wait .1;input /macro set 1')
	elseif player.sub_job == 'SAM' then
		send_command('input /macro book 7;wait .1;input /macro set 1')
	elseif player.sub_job == 'DRK' then
		send_command('input /macro book 6;wait .1;input /macro set 1')
	end
	
	gear_shortcuts = {
		['utu']='Utu Grip',
		['refined']='Refined Grip +1',
		['mensch']='Mensch Strap +1',
		['mencsh']='Mensch Strap +1',
		['lion']='Lionheart',
		['epeo']='Epeolatry',
		['aetir']='Aettir'}
	
	defense_mode =	'Turtle'
	ws_mode =		'Full Attack'
	accuracy_mode =	'Normal'

	subset_table = {Turtle	= 'Balanced', --Edit these values to change your default subsets
					Hybrid	= 'Inqartata',
					DD		= 'Full DD'}
					
	cycle_table =  {Turtle	= {'Balanced', 'MaxHP'},
					Hybrid	= {'Inqartata'},
					DD		= {'Full DD', 'DD DT'},
					WS		= {'Full Attack', 'Balanced', 'Tanky'},
					Acc		= {'Normal', 'Mid', 'High'}}
		
	selfCommandMaps =  {['switch']	= handle_switch,
						['cycle']	= handle_cycle,
						['cure']	= handle_cure,
						['cursna'] 	= handle_cursna,
						['shell']	= handle_shell,
						['refresh']	= handle_refresh,
						['update']	= handle_update,
						['reequip']	= handle_reequip,
						['main'] 	= handle_main,
						['sub']		= handle_sub}
	
	-- Shortcuts for augmented gear
	Ogma = {}
	Ogma.Tank	= 	{ name="Ogma's cape", augments={'HP+60' ,'Eva.+20 /Mag. Eva.+20','Mag. Evasion+10','Enmity+10','Phys. dmg. taken -10%'}}
	Ogma.Reso	= 	{ name="Ogma's cape", augments={'STR+20','Accuracy+20 Attack+20','"Dbl. Atk."+10','STR+10','Phys. dmg. taken -10%'}}
	Ogma.Acc	= 	{ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','"Store TP"+10','Accuracy+10','Phys. dmg. taken -10%'}}
	Ogma.FC 	= 	{ name="Ogma's cape", augments={'HP+60' ,'Eva.+20 /Mag. Eva.+20','Fast Cast+10','HP+20','Phys. dmg. taken -10%'},priority=15}
	Ogma.Dimidi	= 	{ name="Ogma's cape", augments={'DEX+20','Accuracy+20 Attack+20','"Weapon skill damage"+10','DEX+10','Phys. dmg. taken -10%'}}
	Ogma.Enmity =	{ name="Ogma's cape", augments={'HP+60' ,'Eva.+20 /Mag. Eva.+20','Enmity+10','HP+20','Phys. dmg. taken -10%'},priority=15}
	Ogma.Lunge 	=	{ name="Ogma's cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Phys. dmg. taken-10%'}}
	
	Herc = {}
	Herc.Head = {}
	Herc.Head.Dimi = { name="Herculean Helm", augments={'Accuracy+29','Weapon skill damage +3%','DEX+13',}}
	Herc.Body = {}
	Herc.Body.WSD = { name="Herculean Vest", augments={'Accuracy+30','Weapon skill damage +4%','AGI+3','Attack+12',}}
	Herc.Body.Dimi=	{ name="Herculean Vest", augments={'Accuracy+24 Attack+24','Weapon skill damage +4%','DEX+4','Accuracy+15',}}
	Herc.Hands = {}
	Herc.Hands.TA = { name="Herculean Gloves", augments={'Accuracy+19 Attack+19','"Triple Atk."+3','Accuracy+11',}}
	Herc.Legs = {}
	Herc.Legs.WSD = { name="Herculean Trousers", augments={'Attack+26','Weapon skill damage +3%','DEX+5',}}
	Herc.Feet = {}
	Herc.Feet.TA = 	{ name="Herculean Boots", augments={'Attack+24','"Triple Atk."+4','Accuracy+13',}}
	
	Adhemar = {}
	Adhemar.Body = {}
	Adhemar.Body.PathB = { name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}}
	Adhemar.Hands = {}
	Adhemar.Hands.PathA ={ name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}}
	Adhemar.Hands.PathB ={ name="Adhemar Wrist. +1", augments={'STR+12','DEX+12','Attack+20',}}
	
	Carmine = {}
	Carmine.Legs = {}
	Carmine.Legs.PathD = { name="Carmine Cuisses +1", augments={'HP+80','STR+12','INT+12',}}
	Carmine.Feet = {}
	Carmine.Feet.PathD = { name="Carmine Greaves +1", augments={'HP+80','MP+80','Phys. dmg. taken -4',}}
	
	---------------
	-- Idle Sets --
	---------------
	
	-- HP values for all sets are run/drk with a strap that doesn't give HP, as the grip is never swapped while casting
	
	sets.idle = {}
	
	sets.idle.Balanced = {
		ammo="Staunch Tathlum +1",
		head="Turms Cap +1",
		body="Runeist's Coat +3",
		hands="Turms Mittens +1",
		legs="Erilaz Leg Guards +1",
		feet="Erilaz Greaves +1",
		neck="Futhark Torque +1",
		waist="Flume Belt +1",
		left_ear="Ethereal Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring={name="Moonlight Ring",bag="wardrobe2"},
		back=Ogma.Tank,
		maxHP=2873}
	
	sets.idle.Balanced['Mensch Strap +1'] = {
		ammo="Staunch Tathlum +1",
		head="Turms Cap +1",
		body="Runeist's Coat +3",
		hands="Turms Mittens +1",
		legs="Erilaz Leg Guards +1",
		feet="Turms Leggings +1",
		neck="Futhark Torque +1",
		waist="Flume Belt +1",
		left_ear="Ethereal Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring={name="Moonlight Ring",bag="wardrobe2"},
		back=Ogma.Tank,
		maxHP=2931}
	
	sets.idle.MaxHP = { -- for utu grip
		ammo="Staunch Tathlum +1",
		head="Turms Cap +3",
		body="Futhark Coat +3",
		hands="Regal Gauntlets",
		legs="Erilaz Leg Guards +1",
		feet="Turms Leggings +1",
		neck="Futhark Torque +1",
		waist="Flume Belt +1",
		left_ear="Odnowa Earring",
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",bag="wardrobe2"},
		back=Ogma.Tank,
		maxHP=3158}
		
	sets.idle.MaxHP['Mensch Strap +1'] = { -- these sets could utilize the moonlight cape
		ammo="Staunch Tathlum +1",
		head="Futhark Bandeau +3",
		body="Runeist's Coat +3",
		hands="Regal Gauntlets",
		legs="Erilaz Leg Guards +1",
		feet="Turms Leggings +1",
		neck="Futhark Torque +1",
		waist="Flume Belt +1",
		left_ear = "Odnowa Earring",
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",bag="wardrobe2"},
		back=Ogma.Tank,
		maxHP=3219}
	
	------------------
	-- Engaged Sets --
	------------------
	
	sets.engaged = {} --sets.engaged.Hybrid.Inqartata.High.AM3['Utu Grip']
	
	sets.engaged.Turtle = {}
	
	-- Turtle sets
	sets.engaged.Turtle.Balanced = {
		ammo="Staunch Tathlum +1",
		head="Turms Cap +1",
		body="Runeist's Coat +3",
		hands="Turms Mittens +1",
		legs="Erilaz Leg Guards +1",
		feet="Turms Leggings +1",
		neck="Futhark Torque +1",
		waist="Flume Belt +1",
		left_ear="Ethereal Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring={name="Moonlight Ring",bag="wardrobe2"},
		back=Ogma.Tank,
		maxHP=2931}
		
	sets.engaged.Turtle.Balanced['Utu Grip'] = {
		ammo="Staunch Tathlum +1",
		head="Turms Cap +1", --Futhark Bandeau +3,
		body="Runeist's Coat +3",
		hands="Turms Mittens +1",
		legs="Erilaz Leg Guards +1",
		feet="Turms Leggings +1",
		neck="Futhark Torque +1",
		waist="Flume Belt +1",
		left_ear="Ethereal Earring",
		right_ear="Odnowa Earring +1",
		left_ring="Defending Ring",
		right_ring={name="Moonlight Ring",bag="wardrobe2"},
		back=Ogma.Tank,
		maxHP=2931}
		
	sets.engaged.Turtle.MaxHP = {
		ammo="Staunch Tathlum +1",
		head="Turms Cap +3",
		body="Futhark Coat +3",
		hands="Turms Mittens +1",
		legs="Erilaz Leg Guards +1",
		feet="Turms Leggings +1",
		neck="Futhark Torque +1",
		waist="Flume Belt +1",
		left_ear="Odnowa Earring",
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",bag="wardrobe2"},
		back=Ogma.Tank,
		maxHP=3027}
	
	sets.engaged.Turtle.MaxHP['Mensch Strap +1'] = {
		ammo="Staunch Tathlum +1",
		head="Futhark Bandeau +3",
		body="Runeist's Coat +3",
		hands="Turms Mittens +1",
		legs="Erilaz Leg Guards +1",
		feet="Turms Leggings +1",
		neck="Futhark Torque +1",
		waist="Flume Belt +1",
		left_ear = "Odnowa Earring",
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",bag="wardrobe2"},
		back=Ogma.Tank,
		maxHP=3088}
	
	-- Hybrid sets
	sets.engaged.Hybrid = {}
	
	sets.engaged.Hybrid.Inqartata = {
		ammo="Staunch Tathlum +1",
		head="Aya. Zucchetto +2",
		body="Ayanmo Corazza +2",
		hands="Turms Mittens +1",
		legs="Meg. Chausses +2",
		feet="Turms Leggings +1",
		neck="Futhark Torque +1",
		waist="Ioskeha Belt +1",
		left_ear="Telos Earring",
		right_ear={name="Sherida Earring", priority=15},
		left_ring="Defending Ring",
		right_ring={name="Moonlight Ring",bag="wardrobe2"},
		back=Ogma.Acc,
		maxHP=2491}
		
	sets.engaged.Hybrid.Inqartata.AM3 = {
		ammo="Yamarang",
		head="Aya. Zucchetto +2",
		body="Futhark Coat +3",
		hands="Turms Mittens +1",
		legs="Meg. Chausses +2",
		feet="Turms Leggings +1",
		neck="Futhark Torque +1",
		waist="Ioskeha Belt +1",
		left_ear="Telos Earring",
		right_ear={name="Sherida Earring", priority=15},
		left_ring="Defending Ring",
		right_ring={name="Moonlight Ring",bag="wardrobe2"},
		back=Ogma.Acc,
		maxHP=2553}
		
	-- Make a STP/Meva set here that doesn't cap DT
	
	-- DD Sets
	sets.engaged.DD = {}
	
	sets.engaged.DD['Full DD'] = {}
	
	sets.engaged.DD['Full DD'].Normal = {
		ammo="Yamarang",
		head="Dampening Tam",
		body="Turms Harness +1",
		hands=Adhemar.Hands.PathA, 
		legs="Samnuha Tights",
		feet=Herc.Feet.TA,
		neck="Ainia Collar",
		waist="Ioskeha Belt +1", -- Windbuffet +1
		left_ear="Dedition Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Acc,
		maxHP=2286}
		
	sets.engaged.DD['Full DD'].Mid = {
		ammo="Yamarang",
		head="Dampening Tam",
		body="Turms Harness +1",
		hands=Adhemar.Hands.PathA, 
		legs="Samnuha Tights",
		feet=Herc.Feet.TA,
		neck="Anu Torque",
		waist="Ioskeha Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Acc,
		maxHP=2286}
		
	sets.engaged.DD['Full DD'].High = {
		ammo="Yamarang",
		head="Dampening Tam",
		body="Turms Harness +1",
		hands=Adhemar.Hands.PathA, 
		legs="Meghanada Chausses +2",
		feet=Herc.Feet.TA,
		neck="Anu Torque",
		waist="Ioskeha Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring="Epona's Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Acc,
		maxHP=2280}
		
	sets.engaged.DD['Full DD'].Normal.AM3 = {
		ammo="Yamarang",
		head="Ayanmo Zucchetto +2",
		body="Turms Harness +1",
		hands=Adhemar.Hands.PathA, 
		legs="Samnuha Tights",
		feet=Carmine.Feet.PathD, -- if I ever get stp8 herc feet with some acc, they'll do better
		neck="Ainia Collar",
		waist="Kentarch Belt +1",
		left_ear="Dedition Earring",
		right_ear="Sherida Earring",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring="Niqmaddu Ring",
		back=Ogma.Acc,
		maxHP=2491}
		
	sets.engaged.DD['Full DD'].Mid.AM3 = {
		ammo="Yamarang",
		head="Ayanmo Zucchetto +2",
		body="Turms Harness +1",
		hands=Adhemar.Hands.PathA, 
		legs="Samnuha Tights",
		feet=Carmine.Feet.PathD, -- STP herc feet
		neck="Anu Torque",
		waist="Kentarch Belt +1",
		left_ear="Dedition Earring",
		right_ear="Sherida Earring",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring="Niqmaddu Ring",
		back=Ogma.Acc,
		maxHP=2491}
		
	sets.engaged.DD['Full DD'].High.AM3 = {
		ammo="Yamarang",
		head="Ayanmo Zucchetto +2",
		body="Turms Harness +1",
		hands=Adhemar.Hands.PathA, 
		legs="Samnuha Tights",
		feet=Carmine.Feet.PathD, -- STP herc feet
		neck="Anu Torque",
		waist="Kentarch Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring="Niqmaddu Ring",
		back=Ogma.Acc,
		maxHP=2491}
		
	sets.engaged.DD['DD DT'] = {
		ammo="Staunch Tathlum +1",
		head="Ayanmo Zucchetto +2", -- Adhemar bonnet Path D
		body="Turms Harness +1",
		hands=Adhemar.Hands.PathA, 
		legs="Meghanada Chausses +2",
		feet=Herc.Feet.TA,
		neck="Futhark Torque +1",
		waist="Ioskeha Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.Acc,
		maxHP=2554}
		
	sets.engaged.DD['DD DT'].AM3 = {
		ammo="Yamarang",
		head="Ayanmo Zucchetto +2",
		body="Turms Harness +1",
		hands=Adhemar.Hands.PathA, 
		legs="Samnuha Tights",
		feet=Carmine.Feet.PathD,
		neck="Futhark Torque +1",
		waist="Kentarch Belt +1",
		left_ear="Telos Earring",
		right_ear="Sherida Earring",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.Acc,
		maxHP=2646}
		
	------------------
	-- Precast Sets --
	------------------
	sets.precast = {}

	sets.precast[1] = { -- 38% FC
		ammo="Impatiens",
		head={name="Runeist's Bandeau +3", priority=14}, 
		body={name="Runeist's Coat +3",priority=15},
		hands="Leyline Gloves",
		legs="Ayanmo Cosciales +2",
		feet="Erilaz Greaves +1",
		neck={name="Futhark Torque +1",priority=15},
		waist="Flume Belt +1",
		left_ear="Loquac. Earring",
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2919}
		
	sets.precast[2] = { -- 36% FC
		ammo="Impatiens",
		head={name="Runeist's Bandeau +3", priority=14}, 
		body={name="Runeist's Coat +3",priority=15},
		hands="Leyline Gloves",
		legs="Ayanmo Cosciales +2",
		feet="Erilaz Greaves +1",
		neck={name="Futhark Torque +1",priority=15},
		waist="Flume Belt +1",
		left_ear={name="Odnowa Earring",priority=15},
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=3019}
	
	sets.precast[3] = { -- 40% FC
		ammo="Impatiens",
		head={name="Runeist's Bandeau +3", priority=14}, 
		body={name="Runeist's Coat +3",priority=15},
		hands="Leyline Gloves",
		legs="Ayanmo Cosciales +2",
		feet="Erilaz Greaves +1",
		neck={name="Futhark Torque +1",priority=15},
		waist="Flume Belt +1",
		left_ear="Loquac. Earring",
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring="Kishar Ring",
		back=Ogma.FC,
		maxHP=2809}
		
	sets.precast[4] = { -- 36% FC
		ammo="Impatiens",
		head={name="Runeist's Bandeau +3", priority=14}, 
		body={name="Runeist's Coat +3",priority=15},
		hands="Leyline Gloves",
		legs="Ayanmo Cosciales +2",
		feet={name="Turms Leggings +1",priority=14},
		neck={name="Futhark Torque +1",priority=15},
		waist={name="Kasiri Belt",priority=15},
		left_ear={name="Odnowa Earring",priority=15},
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=3107}
		
	sets.precast['Enhancing Magic'] = {}
	
	sets.precast['Enhancing Magic'].Inspiration = {}
	
	sets.precast['Enhancing Magic'].Inspiration[1] = { -- 46% FC
		ammo="Impatiens",
		head={name="Runeist's Bandeau +3", priority=14}, 
		body={name="Runeist's Coat +3",priority=15},
		hands="Leyline Gloves",
		legs={name="Futhark Trousers +3",priority=14},
		feet={name="Turms Leggings +1",priority=14},
		neck={name="Futhark Torque +1",priority=15},
		waist={name="Kasiri Belt",priority=15},
		left_ear={name="Odnowa Earring",priority=15},
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=3169}
		
	sets.precast['Enhancing Magic'].Inspiration[2] = { -- 48% FC
		ammo="Impatiens",
		head={name="Runeist's Bandeau +3", priority=14}, 
		body={name="Runeist's Coat +3",priority=15},
		hands="Leyline Gloves",
		legs={name="Futhark Trousers +3",priority=14},
		feet={name="Turms Leggings +1",priority=14},
		neck={name="Futhark Torque +1",priority=15},
		waist={name="Kasiri Belt",priority=15},
		left_ear="Loquac. Earring",
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=3069}
		
	sets.precast['Enhancing Magic'].Inspiration[3] = { -- 38% FC
		ammo="Impatiens",
		head={name="Runeist's Bandeau +3", priority=14}, 
		body={name="Runeist's Coat +3",priority=15},
		hands="Regal Gauntlets",
		legs={name="Futhark Trousers +3",priority=14},
		feet={name="Turms Leggings +1",priority=14},
		neck={name="Futhark Torque +1",priority=15},
		waist={name="Kasiri Belt",priority=15},
		left_ear={name="Odnowa Earring",priority=15},
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=3349}
		
	sets.precast['Enhancing Magic'][1] = { -- 58% FC
		ammo="Impatiens",
		head={name="Runeist's Bandeau +3", priority=14}, 
		body={name="Runeist's Coat +3",priority=15},
		hands="Leyline Gloves",
		legs={name="Futhark Trousers +3",priority=14},
		feet={name="Turms Leggings +1",priority=14},
		neck={name="Futhark Torque +1",priority=15},
		waist="Siegel Sash",
		left_ear="Loquac. Earring",
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring="Kishar Ring",
		back=Ogma.FC,
		maxHP=2929}
	
	sets.precast.waltz = {}
	
	sets.precast.step = {}
	
	------------------
	-- Midcast Sets --
	------------------
	
	sets.Enmity = {}

	sets.Enmity[1] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Erilaz Leg Guards +1",
		feet="Erilaz Greaves +1",
		neck="Moonlight Necklace",
		waist={name="Kasiri Belt",priority=15},
		left_ear={name="Cryptic Earring",priority=14}, 
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"}, 
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.Enmity,
		maxHP=2801}
		
	sets.Enmity[2] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Kurys Gloves",
		legs="Erilaz Leg Guards +1",
		feet="Erilaz Greaves +1",
		neck="Moonlight Necklace",
		waist={name="Kasiri Belt",priority=15},
		left_ear={name="Cryptic Earring",priority=14}, 
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring="Defending Ring",
		right_ring={name="Eihwaz Ring",priority=13}, 
		back=Ogma.Enmity,
		maxHP=2651}
		
	sets.SIRD = {} --Possibly add a regal gauntlets set

	sets.SIRD[1] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Rawhide Gloves",
		legs=Carmine.Legs.PathD,
		feet="Erilaz Greaves +1",
		neck="Moonlight Necklace",
		waist="Rumination Sash",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"}, 
		right_ring={name="Evanescence Ring",priority=0}, 
		back=Ogma.Enmity,
		maxHP=2821}
		
	sets.SIRD[2] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Rawhide Gloves",
		legs=Carmine.Legs.PathD,
		feet="Erilaz Greaves +1",
		neck="Moonlight Necklace",
		waist="Rumination Sash",
		left_ear={name="Cryptic Earring",priority=14}, 
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"}, 
		right_ring={name="Evanescence Ring",priority=0}, 
		back=Ogma.Enmity,
		maxHP=2761}
		
	sets.SIRD[3] = {
		ammo="Staunch Tathlum +1",
		head="Halitus Helm",
		body="Emet Harness +1",
		hands="Rawhide Gloves",
		legs=Carmine.Legs.PathD,
		feet="Erilaz Greaves +1",
		neck="Moonlight Necklace",
		waist="Rumination Sash",
		left_ear={name="Cryptic Earring",priority=14}, 
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Defending Ring",priority=0}, 
		right_ring={name="Evanescence Ring",priority=0}, 
		back=Ogma.Enmity,
		maxHP=2651}
	
	sets.midcast = {}
	
	sets.midcast[1] = { -- 44 DT, 38 FC
		ammo="Staunch Tathlum +1",
		head="Runeist's Bandeau +3", 
		body={name="Futhark Coat +3",priority=0}, 
		hands="Leyline Gloves",
		legs="Ayanmo Cosciales +2", 
		feet="Erilaz Greaves +1",
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15, bag="wardrobe3"}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2875}
		
	sets.midcast[2] = { -- 44 DT, 38 FC
		ammo="Staunch Tathlum +1",
		head="Runeist's Bandeau +3", 
		body={name="Futhark Coat +3",priority=0}, 
		hands="Regal Gauntlets",
		legs="Ayanmo Cosciales +2", 
		feet="Erilaz Greaves +1",
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15, bag="wardrobe3"}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=3055}
		
	sets.midcast['Mensch Strap +1'] = {}
		
	sets.midcast['Mensch Strap +1'][1] = { -- 49 DT, 38 FC
		ammo="Staunch Tathlum +1",
		head="Runeist's Bandeau +3", 
		body={name="Futhark Coat +3",priority=0}, 
		hands="Leyline Gloves",
		legs="Ayanmo Cosciales +2", 
		feet="Erilaz Greaves +1",
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15, bag="wardrobe3"}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2875}
		
	sets.midcast['Mensch Strap +1'][2] = { -- 44 DT, 38 FC
		ammo="Staunch Tathlum +1",
		head="Runeist's Bandeau +3", 
		body={name="Futhark Coat +3",priority=0}, 
		hands="Leyline Gloves",
		legs="Ayanmo Cosciales +2", 
		feet={name="Turms Leggings +1",priority=15},
		neck={name="Moonlight Necklace",priority=1},
		waist="Flume Belt +1",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15, bag="wardrobe3"}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC, -- will have 10 DT on it at some point.
		maxHP=2933}
		
	sets.midcast['Mensch Strap +1'][3] = { -- 49 DT, 38 FC
		ammo="Staunch Tathlum +1",
		head="Runeist's Bandeau +3", 
		body={name="Futhark Coat +3",priority=0}, 
		hands="Regal Gauntlets",
		legs="Ayanmo Cosciales +2", 
		feet="Erilaz Greaves +1",
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15, bag="wardrobe3"}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=3055}
	
	sets.midcast.Flash = sets.Enmity
	sets.midcast.Foil = sets.Enmity
	
	sets.midcast.Stun = sets.Enmity
	sets.midcast.Poisonga = sets.SIRD
	
	sets.midcast.Jettatura = sets.SIRD
	sets.midcast['Geist Wall'] = sets.SIRD
	sets.midcast['Sheep Song'] = sets.SIRD
	sets.midcast['Blank Gaze'] = sets.Enmity
	
	sets.midcast['Enhancing Magic'] = {} -- enhancing magic duration sets
	
	sets.midcast['Enhancing Magic'][1] = {
		ammo="Staunch Tathlum +1",
		head={name="Erilaz Galea +1",priority=0},
		body={name="Futhark Coat +3",priority=0}, 
		hands={name="Regal Gauntlets",priority=15},
		legs={name="Futhark Trousers +3",priority=15}, 
		feet="Erilaz Greaves +1",
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15, bag="wardrobe3"}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=3099}
		
	sets.midcast['Enhancing Magic'][2] = {
		ammo="Staunch Tathlum +1",
		head={name="Erilaz Galea +1",priority=0},
		body={name="Futhark Coat +3",priority=0}, 
		hands={name="Regal Gauntlets",priority=15},
		legs={name="Futhark Trousers +3",priority=15}, 
		feet="Erilaz Greaves +1",
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Defending Ring",priority=0,}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2989}
		
	sets.midcast['Enhancing Magic'][3] = {
		ammo="Staunch Tathlum +1",
		head={name="Erilaz Galea +1",priority=0},
		body={name="Futhark Coat +3",priority=0}, 
		hands={name="Regal Gauntlets",priority=15},
		legs={name="Futhark Trousers +3",priority=15}, 
		feet="Erilaz Greaves +1",
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear={name="Genmei Earring",priority=0}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Defending Ring",priority=0,}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2889}
		
	-- Do a set with stinkini and the delve earring whenever I get around to getting them
	
	sets.midcast.Stoneskin = {}
	
	sets.midcast.Stoneskin[1] = {
		ammo="Staunch Tathlum +1",
		head={name="Futhark Bandeau +3",priority=0},
		body={name="Futhark Coat +3",priority=0}, 
		hands={name="Runeist's Mitons +3",priority=15},
		legs={name="Futhark Trousers +3",priority=15}, 
		feet="Erilaz Greaves +1",
		neck={name="Moonlight Necklace", priority=1},
		waist="Siegel Sash",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15, bag="wardrobe3"}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2944}
		
	sets.midcast.Stoneskin[2] = {
		ammo="Staunch Tathlum +1",
		head={name="Futhark Bandeau +3",priority=0},
		body={name="Futhark Coat +3",priority=0}, 
		hands={name="Runeist's Mitons +3",priority=15},
		legs={name="Futhark Trousers +3",priority=15}, 
		feet="Erilaz Greaves +1",
		neck={name="Moonlight Necklace", priority=1},
		waist="Siegel Sash",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Defending Ring",priority=0,}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2834}
		
	sets.midcast.Stoneskin[3] = {
		ammo="Staunch Tathlum +1",
		head={name="Futhark Bandeau +3",priority=0},
		body={name="Futhark Coat +3",priority=0}, 
		hands={name="Regal Gauntlets",priority=15},
		legs={name="Futhark Trousers +3",priority=15}, 
		feet="Erilaz Greaves +1",
		neck={name="Moonlight Necklace", priority=1},
		waist="Siegel Sash",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15, bag="wardrobe3"}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=3064}
	
	sets.midcast['Divine Magic'] = {} -- Only divine magic RUN can cast is flash unless you /whm or /pld, so this won't really come up very often
	
	sets.midcast['Divine Magic'][1] = { -- Mostly a magic accuracy set
		ammo="Staunch Tathlum +1",
		head={name="Runeist's Bandeau +3",priority=15},
		body={name="Runeist's Coat +3",priority=15}, 
		hands={name="Runeist's Mitons +3",priority=15},
		legs={name="Runeist Trousers +1",priority=13}, 
		feet="Runeist's Bottes +3", -- use AF feet if +2/3
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear="Dignitary's Earring", 
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Defending Ring",priority=0,}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2882}
		
	sets.midcast['Divine Magic'][2] = { -- Mostly a magic accuracy set
		ammo="Staunch Tathlum +1",
		head={name="Runeist's Bandeau +3",priority=15},
		body={name="Runeist's Coat +3",priority=15}, 
		hands={name="Runeist's Mitons +3",priority=15},
		legs={name="Runeist Trousers +1",priority=13}, 
		feet="Runeist's Bottes +3", -- use AF feet if +2/3
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear="Dignitary's Earring", 
		right_ear={name="Odnowa Earring +1",priority=15},
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2992}
		
	sets.midcast['Phalanx'] = {}
	
	sets.midcast['Phalanx'][1] = {
		ammo="Staunch Tathlum +1",
		head={name="Futhark Bandeau +3",priority=0},
		body={name="Taeon Tabard",priority=0}, 
		hands="Taeon Gloves",
		legs="Taeon Tights", 
		feet="Taeon Boots",
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15, bag="wardrobe3"}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2759}
		
	sets.midcast['Phalanx'][2] = {
		ammo="Staunch Tathlum +1",
		head={name="Futhark Bandeau +3",priority=0},
		body={name="Taeon Tabard",priority=0}, 
		hands="Taeon Gloves",
		legs="Taeon Tights", 
		feet="Taeon Boots",
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Defending Ring",priority=0,}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2649}
		
	--[[sets.midcast['Phalanx']['Mensch Strap +1'] = {}

	sets.midcast['Phalanx']['Mensch Strap +1'][1]= {
		ammo="Staunch Tathlum +1",
		head={name="Futhark Bandeau +1",priority=0},
		body={name="Futhark Coat +1",priority=0}, 
		hands={name="Runeist's Mitons +2",priority=15},
		legs={name="Futhark Trousers+2",priority=15}, 
		feet="Turms Leggings +1",
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Moonlight Ring",priority=15, bag="wardrobe3"}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2942}
		
	sets.midcast['Phalanx']['Mensch Strap +1'][2] = {
		ammo="Staunch Tathlum +1",
		head={name="Futhark Bandeau +1",priority=0},
		body={name="Futhark Coat +1",priority=0}, 
		hands={name="Runeist's Mitons +2",priority=15},
		legs={name="Futhark Trousers+2",priority=15}, 
		feet="Turms Leggings +1",
		neck={name="Moonlight Necklace", priority=1},
		waist="Flume Belt +1",
		left_ear={name="Odnowa Earring",priority=15}, 
		right_ear="Odnowa Earring +1",
		left_ring={name="Defending Ring",priority=0,}, 
		right_ring={name="Moonlight Ring",priority=14, bag="wardrobe2"},
		back=Ogma.FC,
		maxHP=2832}]]
		
	----------------------
	-- Weaponskill sets --
	----------------------
	
	sets.WS = {}
	
	sets.WS['Full Attack'] = { -- The fallback sets are just gunna be reso sets since I don't really have any special STR WSD sets
		ammo="Knobkierrie",
		head="Lustratio Cap +1",
		body="Lustratio Harness +1",
		hands="Meghanada Gloves +2", -- Adhemar Path B
		legs="Samnuha Tights", -- Samnuha Tights (perfect augments)
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS['Full Attack'].Mid = {
		ammo="Knobkierrie",
		head="Lustratio Cap +1",
		body="Lustratio Harness +1",
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS['Full Attack'].High = {
		ammo="Seething Bomblet +1",
		head="Lustratio Cap +1",
		body="Lustratio Harness +1",
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS['Balanced'] = {
		ammo="Knobkierrie",
		head="Lustratio Cap +1",
		body=Adhemar.Body.PathB,
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2", 
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS['Balanced'].Mid = {
		ammo="Knobkierrie",
		head="Lustratio Cap +1",
		body=Adhemar.Body.PathB,
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS['Balanced'].High = {
		ammo="Seething Bomblet +1",
		head="Lustratio Cap +1",
		body="Lustratio Harness +1",
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS['Tanky'] = {
		ammo="Knobkierrie",
		head="Meghanada Visor +2",
		body="Meghanada Cuirie +2",
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2", 
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS['Tanky'].Mid = {
		ammo="Knobkierrie",
		head="Meghanada Visor +2",
		body="Meghanada Cuirie +2",
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2", 
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.Reso}
		
	sets.WS['Tanky'].High = {
		ammo="Seething Bomblet +1",
		head="Meghanada Visor +2",
		body="Meghanada Cuirie +2",
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2", 
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.Reso}
		
	sets.WS.Resolution = {}
	
	sets.WS.Resolution['Full Attack'] = { 
		ammo="Knobkierrie",
		head="Lustratio Cap +1",
		body="Lustratio Harness +1",
		hands=Adhemar.Hands.PathB, 
		legs="Samnuha Tights", 
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS.Resolution['Full Attack'].Mid = {
		ammo="Knobkierrie",
		head="Lustratio Cap +1",
		body="Lustratio Harness +1",
		hands=Adhemar.Hands.PathB, 
		legs="Meghanada Chausses +2",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",	
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS.Resolution['Full Attack'].High = {
		ammo="Seething Bomblet +1",
		head="Lustratio Cap +1",
		body="Lustratio Harness +1",
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS.Resolution['Balanced'] = {
		ammo="Knobkierrie",
		head="Lustratio Cap +1",
		body=Adhemar.Body.PathB,
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2", 
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS.Resolution['Balanced'].Mid = {
		ammo="Knobkierrie",
		head="Lustratio Cap +1",
		body=Adhemar.Body.PathB,
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS.Resolution['Balanced'].High = {
		ammo="Seething Bomblet +1",
		head="Lustratio Cap +1",
		body=Adhemar.Body.PathB,
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS.Resolution['Tanky'] = {
		ammo="Knobkierrie",
		head="Meghanada Visor +2",
		body="Meghanada Cuirie +2",
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2", 
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring="Niqmaddu Ring",
		back=Ogma.Reso}
		
	sets.WS.Resolution['Tanky'].Mid = {
		ammo="Knobkierrie",
		head="Meghanada Visor +2",
		body="Meghanada Cuirie +2",
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2", 
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.Reso}
		
	sets.WS.Resolution['Tanky'].High = {
		ammo="Seething Bomblet +1",
		head="Meghanada Visor +2",
		body="Meghanada Cuirie +2",
		hands="Meghanada Gloves +2", 
		legs="Meghanada Chausses +2", 
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring={name="Moonlight Ring",priority=15,bag="wardrobe3"},
		right_ring={name="Moonlight Ring",priority=15,bag="wardrobe2"},
		back=Ogma.Reso}
		
	sets.WS.Dimidiation = {}
		
	sets.WS.Dimidiation['Full Attack'] = { 
		ammo="Knobkierrie",
		head=Herc.Head.Dimi,
		body=Herc.Body.Dimi,
		hands="Meghanada Gloves +2", 
		legs="Lustratio Subligar +1",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Ilabrat Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Dimidi}
		
	sets.WS.Dimidiation['Full Attack'].Mid = { 
		ammo="Knobkierrie",
		head=Herc.Head.Dimi,
		body=Herc.Body.Dimi,
		hands="Meghanada Gloves +2", 
		legs="Lustratio Subligar +1",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Ilabrat Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Dimidi}
		
	sets.WS.Dimidiation['Full Attack'].High = { 
		ammo="Knobkierrie",
		head="Runeist's Bandeau +3",
		body="Meghanada Cuirie +2",
		hands="Meghanada Gloves +2", 
		legs="Lustratio Subligar +1",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Regal Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Dimidi}
		
	sets.WS.Dimidiation['Balanced'] = {
		ammo="Knobkierrie",
		head="Lustratio Cap +1", -- get more atk from the 46 str
		body=Herc.Body.Dimi,
		hands="Meghanada Gloves +2", 
		legs="Lustratio Subligar +1",
		feet="Lustratio Leggings +1",
		neck="Caro Necklace",
		waist="Grunfeld Rope",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Ilabrat Ring",
		right_ring="Niqmaddu Ring",
		back=Ogma.Dimidi}
		
	sets.WS.Dimidiation['Tanky'] = {
		ammo="Knobkierrie",
		head="Meghanada Visor +2",
		body="Meghanada Cuirie +2",
		hands="Meghanada Gloves +2", 
		legs="Lustratio Subligar +1",
		feet="Lustratio Leggings +1",
		neck="Fotia Gorget",
		waist="Fotia Belt",
		left_ear="Moonshade Earring",
		right_ear="Sherida Earring",
		left_ring="Ilabrat Ring",
		right_ring="Regal Ring",
		back=Ogma.Dimidi}
		
	sets.WS.Resolution.maxTP = {}
	
	sets.WS.Resolution.maxTP.day = {
		left_ear="Ishvara Earring"}
	sets.WS.Resolution.maxTP.night = {
		left_ear="Lugra Earring +1"}
		
	sets.WS.Dimidiation.maxTP = {}
	
	sets.WS.Dimidiation.maxTP.day = {
		left_ear="Ishvara Earring"}
	sets.WS.Dimidiation.maxTP.night = {
		left_ear="Ishvara Earring"}
		
	------------------
	-- Dancing sets --
	------------------
	
	sets.precast.waltz = {
		ammo="Yamarang",
		body="Passion Jacket"}
		
	sets.precast.step = {}
	
	-------------
	-- JA Sets --
	-------------
	sets.JA = {}
	sets.JA['Lunge'] = {} -- I don't have a lunge set :(
	sets.JA['Swipe'] = sets.JA['Lunge']
	sets.JA['Gambit'] = set_combine(sets.Enmity[1], {hands="Runeist's Mitons +3"})
	sets.JA['Rayke'] = set_combine(sets.Enmity[1], {feet="Futhark Boots +1"})
	
	sets.JA['Vallation'] = set_combine(sets.Enmity[1], {
		body="Runeist's Coat +3",
		legs="Futhark Trousers +3"})
	sets.JA['Valiance'] = set_combine(sets.Enmity[1], {
		body="Runeist's Coat +3",
		legs="Futhark Trousers +3"})
	sets.JA['One for All'] = sets.Enmity[1]
	sets.JA['Liement'] = set_combine(sets.Enmity[1], {body="Futhark Coat +3"})
	sets.JA['Battuta'] = set_combine(sets.Enmity[1], {head="Futhark Bandeau +3"})
	sets.JA['Pflug'] = set_combine(sets.Enmity[1], {feet="Runeist Bottes +3"})
	
	sets.JA['Swordplay'] = {hands="Futhark Mitons"}
	sets.JA['Elemental Sforzo'] = {body="Futhark Coat +3"}
	sets.JA['Vivacious Pulse'] = {head="Erilaz Galea +1"}
	sets.JA['Embolden'] = {back="Evasionist's Cape"}
	

	sets.JA['Provoke'] = sets.Enmity[1]
	sets.JA['Warcry'] = sets.Enmity[1]
	sets.JA['Animated Flourish'] = sets.Enmity[1]
	
	sets.JA['Lunge'] = {
		ammo="Seething Bomblet +1",
		--head=Herc.Head.Lunge,
		body="Samnuha Coat",
		hands="Leyline Gloves", 
		--legs=Herc.Legs.Lunge,
		--feet=Herc.Feet.Lunge,
		neck="Eddy Necklace",
		waist="Eschan Stone",
		left_ear="Crematio Earring",
		right_ear="Friomisi Earring",
		left_ring="Locus Ring",
		right_ring="Mujin Band",
		back=Ogma.Lunge}
		
	sets.JA['Swipe'] = sets.JA['Lunge']
		
	sets.Obi = {waist="Hachirin-no-obi"}
		
	-------------------
	-- Reactive Sets --
	-------------------
	
	sets.Shell = {
		left_ring="Sheltered Ring"}
		
	sets.CureReceived = {
		waist="Gishdubar Sash",
		left_ring="Vocane Ring",}
		
	sets.Cursna = {
		--neck="Nicander's Necklace -- Don't have one yet.
		waist="Gishdubar Sash",
		left_ring="Purity Ring",}
	
	sets.Refresh = {
		waist="Gishdubar Sash"}
		
end

function file_unload(filename)
	send_command('unbind !f9')
	send_command('unbind f9')
	send_command('unbind ^f9')
	send_command('unbind f10')
	send_command('unbind ^f10')
	send_command('unbind f11')
	send_command('unbind ^f11')
	send_command('unbind f12')
	send_command('unbind ^f12')
	
	send_command('unbind ^`')
	send_command('unbind !`')
	
	send_command('unbind ^!f9') -- target and ra
	send_command('unbind ^!f10')
	send_command('unbind ^!f11')
	
end		
				
function self_command(commandArgs)
	local commandArgs = commandArgs
	if type(commandArgs) == 'string' then
		commandArgs = T(commandArgs:split(' '))
		if #commandArgs == 0 then
			return
		end
	end
	
	-- Of the original command message passed in, remove the first word from
	-- the list (it will be used to determine which function to call), and
	-- send the remaining words as parameters for the function.
	local handleCmd = table.remove(commandArgs, 1)
	if selfCommandMaps[handleCmd] then
		selfCommandMaps[handleCmd](commandArgs)
	end
end

function handle_switch(cmdParams) -- 'gs c switch DD'
	if #cmdParams == 0 then
		add_to_chat(123,'Switch failure: defense_mode not specified.')
		return
	end
	defense_mode = cmdParams[1]
	add_to_chat(123,'Defense Mode set to '..defense_mode)
	update_gear()
end

function handle_cycle(cmdParams) -- 'gs c cycle Turtle'
	if #cmdParams == 0 then
		add_to_chat(123,'Cycle failure: field not specified.')
		return
	end
	field = cmdParams[1]
	if subset_table[field] then
		current = subset_table[field] -- our current 
	elseif field == 'WS' then
		current = ws_mode
	elseif field == 'Acc' then
		current = accuracy_mode
	end
	
	--Find the index of what we're cycling
	index = 1
	for i,mode in ipairs(cycle_table[field]) do -- I think i will still exist outside that scope
		if mode == current then index = i; break end -- i is our current index
	end
	i = index + 1
	if cycle_table[field][i] then 
		new = cycle_table[field][i]
	else
		new = cycle_table[field][1]
	end
	if subset_table[field] then
		subset_table[field] = new
		add_to_chat(123,field..' subset set to '..new)
	elseif field == 'WS' then
		ws_mode = new
		add_to_chat(123,'WeaponSkill Mode set to '..new)
	elseif field == 'Acc' then
		accuracy_mode = new
		add_to_chat(123,'Accuracy Mode set to '..new)
	end
	update_gear()
end

function handle_cure(cmdParams) -- 'gs c cure'
	if player.hpp <= 75 then
		equip(sets.CureReceived)
	end
end

function handle_cursna(cmdParams) -- 'gs c cursna'
	equip(sets.Cursna)
end

function handle_shell(cmdParams) -- 'gs c shell' for equipping sheltered ring and shit
	equip(sets.Shell)
end

function handle_refresh(cmdParams) -- 'gs c refresh'
	equip(sets.Refresh)
end

function handle_update(cmdParams) -- 'gs c update' will happen on cast completion of incoming cure/cursna
	update_gear()
end

function handle_reequip(cmdParams)
	equip(default_weapon)
	update_gear()
end

function handle_main(cmdParams)
	if #cmdParams == 0 then
		add_to_chat(123,'No weapon specified')
		return
	end
	local name = table.remove(cmdParams, 1)
	if #cmdParams ~= 0 then
		for word in cmdParams do
			name = name..' '..word
		end
	end
	name = name:lower()
	if gear_shortcuts[name] then
		default_weapon.main=gear_shortcuts[name]
	else
		default_weapon.main=name
	end
	add_to_chat(123,'Default main set to '..default_weapon.main)
	
	local f = io.open('E:/Apps/Windower4/Addons/GearSwap/data/vars.RUN.txt','w+')
	f:write(default_weapon.main..'\n')
	f:write(default_weapon.sub)
	f:close()
end

function handle_sub(cmdParams)
	if #cmdParams == 0 then
		add_to_chat(123,'No grip specified')
		return
	end
	local name = table.remove(cmdParams, 1)
	if #cmdParams ~= 0 then
		for word in cmdParams do
			name = name..' '..word
		end
	end
	name = name:lower()
	if gear_shortcuts[name] then
		default_weapon.sub=gear_shortcuts[name]
	else
		default_weapon.sub=name
	end
	add_to_chat(123,'Default sub set to '..default_weapon.sub)
	
	local f = io.open('E:/Apps/Windower4/Addons/GearSwap/data/vars.RUN.txt','w+')
	f:write(default_weapon.main..'\n')
	f:write(default_weapon.sub)
	f:close()
end

function get_subset() -- get the current subset of the current defense_mode
	return subset_table[defense_mode]
end

function get_idle_set()
	--add_to_chat(123,player.equipment.sub) -- debug
	if sets.idle[subset_table.Turtle][player.equipment.sub] then
		--add_to_chat(123,"Using Grip set") -- debug
		s = sets.idle[subset_table.Turtle][player.equipment.sub]
	else
		s = sets.idle[subset_table.Turtle]
	end
	return s
end

function get_engaged_set() --example set with every possible specification: sets.engaged.Hybrid.Inqartata.HighAcc.AM3['Utu Grip']
	if sets.engaged[defense_mode][get_subset()][accuracy_mode] then
		s = sets.engaged[defense_mode][get_subset()][accuracy_mode]
	else
		s = sets.engaged[defense_mode][get_subset()] -- fall back to the basic set if no accuracy sets are defined
	end
	if player.equipment.main == 'Epeolatry' and s.AM3 and buffactive['Aftermath: Lv.3'] then
		s = s.AM3
	end
	if s[player.equipment.sub] then -- if a set is specified for the grip we're using, switch to it.  Should only apply to turtle builds, since utu is god for hybrid/dd, but it would support grip sets for DD and hybrid modes if you specified sets for them.
		s = s[player.equipment.sub]
	end
	return s
end

function update_gear() -- will put on the appropriate engaged or idle set
	if player.status == 'Engaged' then
		equip(get_engaged_set())
	else -- if we are idle
		--town sets would go here, but I want to idle in tank gear no matter where I am
		equip(get_idle_set())
	end
	if buffactive.Sleep or buffactive.Lullaby then
		--equip(sets.idle[subset_table.Turtle]) -- wear our current tank set if we're asleep
		equip(get_idle_set())
	end
end

function buff_change(buff,gain)
	if buff == 'Aftermath: Lv.3' then update_gear() end --This might be unnecessary, but we want to make sure to switch from a multi-hit to an STP build when we gain Epeo AM3
	-- Not sure if the sleep buff is case sensitive
	if buff == 'Sleep' or buff == 'Lullaby' then update_gear() end
end

function get_eTP() -- going to do this the easy way since RUN only has two pieces of relevant TP bonus gear
	etp = player.tp + 250 -- assume moonshade is on for any set where we care about TP
	if player.equipment.main == 'Lionheart' then
		etp = etp + 500
	end
	return etp
end

function get_runes()
	return {
		fire	= buffactive['Ignis'],
		earth	= buffactive['Tellus'],
		water	= buffactive['Unda'],
		wind	= buffactive['Flabra'],
		ice		= buffactive['Gelus'],
		thunder	= buffactive['Sulpor'],
		light	= buffactive['Lux'],
		dark	= buffactive['Tenebrae']}
end

function precast(spell,action)
	if spell.action_type == 'Magic' then
		--Step 1: Get our current HP value
		if player.status == 'Engaged' then
			current_max_hp = get_engaged_set().maxHP
		else
			current_max_hp = get_idle_set().maxHP -- we always idle in the current turtle set
		end
		
		--Step 2: get our array of sets for this particular spell
		set = sets.precast -- Need to copy if this is a pass by reference and not value
		
		if sets.precast[spell.name] then -- check if there's a spell-specific set
			set = sets.precast[spell.name]
		elseif sets.precast[spell.skill] then --check if there's a set for the skill
			set = sets.precast[spell.skill]
		end -- will default to the base precast sets if nothing is specified
		
		--inspiration = false
		if buffactive['Fast Cast'] and set['Inspiration'] then --if we're in inspiration and have an inspiration set for this skill, we'll use it
			set = set.Inspiration
			--inspiration = true
		end
		
		-- Step 3: Choose the set with the appropriate amount of HP
		-- HP rules:  find the set with the lowest HP >= our HP if it exists, else find the highest HP set < our HP
		-- At this point, set is not a gearset, but a list of gearsets sets.precast.name.skill.number
		max_value = 0
		max_index = 1
		min_acceptable = 4500
		min_index = 0
		for i,s in ipairs(set) do
			if s.maxHP then -- in case where we cast magic that has an inspiration set while not in inspiration, set will contain set.Inspiration, and this check excludes it
				if s.maxHP > max_value then --track the highest HP set
					max_value = s.maxHP
					max_index = i
				end
				if s.maxHP >= current_max_hp and s.maxHP < min_acceptable then
					min_acceptable = s.maxHP
					min_index = i
				end
			end
		end
		
		if min_index > 0 then
			equip(set[min_index]) -- equip the lowest HP set >= our current set
		else
			equip(set[max_index]) -- if no set is > our current, equip the set with the most HP
		end
	elseif spell.type == 'WeaponSkill' then
		if player.tp < 1000 or buffactive['Stun'] or buffactive['Terror'] or buffactive['Amnesia'] or buffactive['Sleep'] or buffactive['Petrification'] then -- add checks for stun and petrify, maybe even distance
			-- Don't flash the WS set if we can't WS
		elseif ws_mode ~= 'Tanky' then
			if sets.WS[spell.name] then
				if sets.WS[spell.name][ws_mode] then
					if sets.WS[spell.name][ws_mode][accuracy_mode] then
						equip(sets.WS[spell.name][ws_mode][accuracy_mode])
					else --sets.WS[spell.name][ws_mode] then
						equip(sets.WS[spell.name][ws_mode])
					end
				else
					equip(sets.WS[spell.name])
				end
			else
				equip(sets.WS[ws_mode])
			end
			--Check current eTP
			if (get_eTP() >= 3100 and sets.WS[spell.name]) and sets.WS[spell.name].maxTP then -- if we're overcapped a non moonshade set exists
				-- Add day/night logic here, since the best alternative will vary
				if world.time >= 1020 or world.time < 420 then
					equip(sets.WS[spell.name].maxTP.night) -- will contain an alternate earring only
				else
					equip(sets.WS[spell.name].maxTP.day)
				end
			end
		else
			if sets.WS[spell.name] and sets.WS[spell.name].Tanky[accuracy_mode] then
				equip(sets.WS[spell.name].Tanky[accuracy_mode])
			elseif sets.WS[spell.name] and sets.WS[spell.name].Tanky then
				equip(sets.WS[spell.name].Tanky)
			else
				equip(sets.WS.Tanky[accuracy_mode])
			end			
			if (get_eTP() >= 3100 and sets.WS[spell.name]) and sets.WS[spell.name].maxTP then
				if world.time >= 1020 or world.time < 420 then
					equip(sets.WS[spell.name].maxTP.night) -- will contain an alternate earring only
				else
					equip(sets.WS[spell.name].maxTP.day)
				end
			end
		end
	elseif spell.name:contains('Waltz') then -- Add auto step-down here
		equip(sets.precast.Waltz)
	elseif spell.name:contains('Step') then
		equip(sets.precast.Step)
	elseif spell.type == 'JobAbility' or spell.action_type == 'Ability' then
		if sets.JA[spell.name] then
			equip(sets.JA[spell.name])
		end
		if spell.name == 'Lunge' or spell.name == 'Swipe' then
			if get_runes()[world.weather_element] or get_runes()[world.day_element] then
				equip(sets.Obi)
			end
		end
	end
end

function midcast(spell,action)
	if spell.name == 'Sneak' or spell.name == 'Spectral Jig' or spell.name:startswith('Monomi') and spell.target.type == 'SELF' then --click off buffs if needed
		send_command('cancel 71')
	end
	if spell.action_type == 'Magic' then -- non magic actions can have the same midcast as precast.  
		--Step 1: Get our current HP value
		if player.status == 'Engaged' then
			current_max_hp = get_engaged_set().maxHP
		else
			current_max_hp = get_idle_set().maxHP
		end
	
		--Step 2: get our array of sets for this particular spell
		set = sets.midcast -- Need to copy if this is a pass by reference and not value
		
		if sets.midcast[spell.name] then -- check if there's a spell-specific set
			set = sets.midcast[spell.name]
		--elseif spell.name:startswith('Regen') then
		--	set = sets.midcast.Regen
		elseif sets.midcast[spell.skill] then --check if there's a set for the skill
			set = sets.midcast[spell.skill]
		end -- will default to the base midcast sets if nothing is specified
		
		
		--inspiration = false
		if buffactive['Fast Cast'] and set['Inspiration'] then --if we're in inspiration and have an inspiration set for this skill, we'll use it
			set = set.Inspiration
			--inspiration = true
		end
		
		-- Adding grips to midcast because why not?
		if set[player.equipment.sub] then
			set = set[player.equipment.sub]
		end
	
		-- Step 3: Choose the set with the appropriate amount of HP
		-- HP rules:  find the set with the lowest HP >= our HP if it exists, else find the highest HP set < our HP
		-- At this point, set is not a gearset, but a list of gearsets
		max_value = 0
		max_index = 1
		min_acceptable = 4500
		min_index = 0
		for i,s in ipairs(set) do
			if s.maxHP then -- in case where we cast magic that has an inspiration set while not in inspiration, set will contain set.Inspiration, and this check excludes it
				if s.maxHP > max_value then --track the highest HP set
					max_value = s.maxHP
					max_index = i
				end
				if s.maxHP >= current_max_hp and s.maxHP < min_acceptable then
					min_acceptable = s.maxHP
					min_index = i
				end
			end
		end
		
		if min_index > 0 then
			equip(set[min_index]) -- equip the lowest HP set >= our current set
		else
			equip(set[max_index]) -- if no set is > our current, equip the set with the most HP
		end		
		if spell.name:startswith('Shell') then -- simpler and more flexible than using midcast shell sets
			equip(sets.Shell)
		elseif spell.name:startswith('Refresh') then
			equip(sets.Refresh)
		end
	end
end

function aftercast(spell,action)
	update_gear() -- will return to the appropriate engaged/idle set
end

function status_change(new,action)
	update_gear()
end



--[[Known Issues:

- Does not unbind/rebind hotkeys or change macro books when changing subjobs
- Does not detect Protectra/shellra or scholar AoE protect/shell
- May not swap lugra earring at night (Needs Testing)
- Doesn't have a lunge set
- Need a Drain set

]]

