require('rnghelper')
--require('yayahelper')

function get_sets()
	require('cor.include')
	--require('cor.RA.v3')
	--require('cor.roller')
	res = require('resources')
	packets = require('packets')
	--setupRoller()
	--setupRA()
	
	-- set keybinds
	send_command('bind f9 gs c cycle Acc')
	send_command('bind ^f9 gs c cycle RAcc')
	send_command('bind !f9 gs c cycle MAcc')
	send_command('bind @f9 gs c cycle HAcc')
	
	send_command('bind f10 gs c switch DT')
	
	send_command('bind f11 gs c cycle QDele')
	send_command('bind ^f11 gs c cycle QDmode')
	
	send_command('bind f12 gs c switch DD')
	send_command('bind ^f12 gs c cycle DD')
	send_command('bind !f12 gs c save')
	
	send_command('bind numpad0 input /ra <t>')
	send_command('bind numpad. gs c QD')
	
	
	selfCommandMaps = {
		['switch']	= handle_switch,
		['cycle']	= handle_cycle,
		['update']	= update_gear,
		['cursna']	= handle_cursna,
		['cure']	= handle_cure,
		['save']	= save_weapons,
		['QD']		= handle_qd,
		['rollcall']= rollcall,
		['roll1']	= handle_roll1,
		['roll2']	= handle_roll2,
		
		['processQueue']	= processQueue,
		['timeout']			= timeout,
		['doPending']		= doPending,}
		
	-- save our current weapons
	save_weapons()
	-- need to fundamentally change how this works sometime
	-- have a MH toggle, rostam A, rostam B, savage sword, evisceration dagger
	
	cycle_table = {				-- {iterator, value, value, value}
		['Melee Accuracy'] 		= {2,'Normal','Mid','Acc'},
		['Ranged Accuracy'] 	= {2,'Normal','Mid','Acc'},
		['Magic Accuracy'] 		= {2,'Normal','Mid','Acc'},
		['Hotshot Accuracy']	= {2,'Normal','Mid','Acc'},
		['Quickdraw Element']	= {2,'Fire','Earth','Water','Wind','Ice','Thunder','Light','Dark'},
		['Quickdraw Mode']		= {2,'Damage / Accuracy','Store TP'},
		['DD Mode']				= {2,'Normal','Hybrid'}}
	cycle_shortcuts = {
		Acc = 'Melee Accuracy',
		RAcc = 'Ranged Accuracy',
		MAcc = 'Magic Accuracy',
		HAcc = 'Hotshot Accuracy',
		QDele = 'Quickdraw Element',
		QDmode = 'Quickdraw Mode',
		DD = 'DD Mode'}
	emergancy_DT = false
	
	DW_Needed = 11
	DW = true
	haste_sets = {
		[0]	 = 'SW',
		[11] = 'DW11',
		[74] = 'DW15',}	
	flurry = 1
	
	midroll = false
	
	autofacetarget = true
	moving = true
	
	herc = {}
	herc.feet = {}
	herc.feet.DT = { name="Herculean Boots", augments={ 'Pet: "Dbl. Atk."+3',
														'Phys. dmg. taken -2%',
														'Damage taken-3%',
														'Accuracy+11 Attack+11',
														'Mag. Acc.+3 "Mag.Atk.Bns."+3',}}
	herc.feet.WSDAGI = { name="Herculean Boots", augments={	'Accuracy+23 Attack+23',
															'Weapon skill damage +4%',
															'AGI+8',
															'Accuracy+6',
															'Attack+7',}}
	herc.feet.TA =  {name="Herculean Boots", augments={ 'Accuracy+29',
														'"Triple Atk."+4',
														'DEX+5',}}
	herc.legs = {}
	herc.legs.LastStand = { name="Herculean Trousers", augments={'Rng.Acc.+28','Weapon skill damage +4%','DEX+1','Rng.Atk.+2',}}
	herc.legs.Leaden = { name="Herculean Trousers", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Phys. dmg. taken -1%','MND+2','Mag. Acc.+7','"Mag.Atk.Bns."+13',}}
	herc.hands = {}
	herc.hands.Leaden = { name="Herculean Gloves", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','"Fast Cast"+3','Mag. Acc.+6','"Mag.Atk.Bns."+13',}}
	herc.head = {}
	herc.head.Savage =  { name="Herculean Helm", augments={'Rng.Acc.+12','Weapon skill damage +3%','STR+6','Accuracy+15','Attack+13',}}
	herc.head.Wildfire = { name="Herculean Helm", augments={'Mag. Acc.+16 "Mag.Atk.Bns."+16','Crit.hit rate+1','Mag. Acc.+15','"Mag.Atk.Bns."+15',}}
	
	Adhemar = {}
	Adhemar.Head = {}
	Adhemar.Head.PathD = { name="Adhemar Bonnet +1", augments={'HP+105','Attack+13','Phys. dmg. taken -4',}}
	Adhemar.Body = {}
	Adhemar.Body.PathA = { name="Adhemar Jacket +1", augments={'DEX+12','AGI+12','Accuracy+20',}}
	Adhemar.Legs = {}
	Adhemar.Legs.PathC = { name="Adhemar Kecks +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}}
	Adhemar.Hands = {}
	Adhemar.Hands.PathA = { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}}
														
	-- CAPES --
	Camulus = {}
	Camulus.DA = { name="Camulus's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Magic dmg. taken-10%',}}
	Camulus.rSTP = { name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','"Store TP"+10','Damage taken-5%',}}
	
	Camulus.Savage = { name="Camulus's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Damage taken-5%',}}
	Camulus.LastStand = { name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Weapon skill damage +10%','Damage taken-5%',}}
	Camulus.LeadenSalute = { name="Camulus's Mantle", augments={'AGI+20','Mag. Acc+20 /Mag. Dmg.+20','AGI+10','Weapon skill damage +10%','Damage taken-5%',}}
	
	Camulus.Snapshot = { name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','"Snapshot"+10','Damage taken-5%',}}
	Camulus.Fastcast = { name="Camulus's Mantle", augments={'HP+60','"Fast Cast"+10',}}
	
	-- JAs
	sets.JA= {}
	
	sets.JA['Snake Eye'] = {legs="Lanun Trews"}
	sets.JA['Wild Card'] = {feet="Lanun Bottes +3"}
	sets.JA['Random Deal'] = {body="Lunan Frac +3"}

	sets.JA['Phantom Roll'] = {
		range="Compensator",
		head="Lanun Tricorne",
		body="Meg. Cuirie +2", --8/0
		hands="Chasseur's Gants +1",
		legs="Desultor Tassets",
		feet=herc.feet.DT, --3/0
		neck="Regal Necklace", 
		ear1="Genmei Earring", --2/0
		ear2="Etiolation Earring", --0/3
		ring1="Barataria Ring",
		ring2="Luzaf's Ring", --10/10
		back=Camulus.Snapshot,
		waist="Flume Belt",} --4/0
		
	sets.JA['Double-Up'] = {
		--main=Rostam.PathC,
		ring2="Luzaf's Ring"}
		
	sets.JA["Caster's Roll"] = set_combine(sets.JA['Phantom Roll'], {legs="Chas. Culottes +1"})
	sets.JA["Courser's Roll"] = set_combine(sets.JA['Phantom Roll'], {feet="Chaseur's Bottes +1"})
	sets.JA["Blitzer's Roll"] = set_combine(sets.JA['Phantom Roll'], {head="Chasseur's Tricorne +1"})
	sets.JA["Tactician's Roll"] = set_combine(sets.JA['Phantom Roll'], {body="Chasseur's Frac +1"})
	sets.JA["Allies' Roll"] = set_combine(sets.JA['Phantom Roll'], {hands="Chasseur's Gants +1"})
	
	sets.JA.FoldDoubleBust = {hands="Lanun Gants +1"}
	
	sets.JA.Quickdraw = {}
	sets.JA.Quickdraw.Damage = {}
	sets.JA.Quickdraw.Accuracy = {}
	sets.JA.Quickdraw['Store TP'] = {
		ammo="Living Bullet",
		neck="Iskur Gorget",
		ear1="Enervating Earring",
		ear2="Dignitary's Earring",
		body="Mummu Jacket +2",
		hands=Adhemar.Hands.PathA,
		ring1="Chirich Ring +1",
		ring2="Ilabrat Ring",
		back=Camulus.Quickdraw,
		waist="Kentarch Belt +1",
		legs="Chas. Culottes +1",
		feet="Mummu Gamashes +2"}
	
	sets.precast = {
		head="Herculean Helm",
		hands="Leyline Gloves",
		ring2="Kishar Ring",
		back=Camulus.Fastcast}
		
	sets.precast.Waltz = {}
	
	sets.precast.Utsusemi = set_combine(sets.precast, {
		})
	
	sets.precast.RA = {
		ammo="Chrono Bullet",
		head="Taeon Chapeau",
		neck="Commodore Charm +2",
		body="Laksamana's Frac +3",
		hands="Carmine Fin. Ga. +1",
		legs="Laksamana's Trews +3",
		feet="Meg. Jam. +2",
		back=Camulus.Snapshot,
		waist="Impulse Belt",}
		
	sets.precast.RA.Flurry1 = {
		ammo="Chrono Bullet",
		head="Taeon Chapeau",
		neck="Commodore Charm +2",
		body="Laksamana's Frac +3",
		hands="Carmine Fin. Ga. +1",
		legs=Adhemar.Legs.PathC,
		feet="Meg. Jam. +2",
		back=Camulus.Snapshot,
		waist="Yameya Belt",}
		
	sets.precast.RA.Flurry2 = {
		ammo="Chrono Bullet",
		head="Chass. Tricorne +1",
		neck="Commodore Charm +2",
		body="Laksamana's Frac +3",
		hands="Carmine Fin. Ga. +1",
		legs=Adhemar.Legs.PathC,
		feet="Pursuer's Gaiters",
		back=Camulus.Snapshot,
		waist="Yameya Belt",}
		
	-- WS Sets	
	
	sets.WS = {}
	sets.WS.Physical = {}
	sets.WS.Magic = {}
	sets.WS.Ranged = {}
		
	sets.WS.Physical.Normal = {
		ammo="Chrono Bullet",
		head=herc.head.Savage,
		body="Laksa. Frac +3",
		hands="Meg. Gloves +2",
		legs="Meg. Chausses +2",
		feet="Lanun Bottes +3",
		neck="Commodore Charm +2",
		waist="Metalsinger Belt",
		left_ear="Moonshade Earring",
		right_ear="Ishvara Earring",
		left_ring="Shukuyu Ring",
		right_ring="Rufescent Ring",
		back=Camulus.Savage -- str wsd cape
		}
		
	sets.WS.Physical.Mid = set_combine(sets.WS.Physical.Normal, {
		head="Meghanada Visor +2"
		})
		
	sets.WS.Physical.Acc = set_combine(sets.WS.Physical.Mid, {
		--combatant's torque
		})
	
	sets.WS.Magic.Normal = {
		ammo="Living Bullet",
		head=herc.head.Savage,
		body="Lanun Frac +3",
		hands="Carmine Fin. Ga. +1",
		legs=herc.legs.Leaden,
		feet="Lanun Bottes +3",
		neck="Commodore Charm +2",
		left_ear="Moonshade Earring",
		right_ear="Friomisi Earring",
		left_ring="Ilabrat Ring",
		right_ring="Dingir Ring",
		back=Camulus.LeadenSalute,
		waist="Eschan Stone",
		}
		
	sets.WS.Magic.Mid = set_combine(sets.WS.Magic.Normal, {
		right_ear="Hermetic Earring",
		})
		
	sets.WS.Magic.Acc = set_combine(sets.WS.Magic.Mid, {
		})
		
	sets.WS.Ranged.Normal = {
		ammo="Chrono Bullet",
		head="Meghanada Visor +2",
		body="Laksa. Frac +3",
		hands="Meg. Gloves +2",
		legs=herc.legs.LastStand,
		feet="Lanun Bottes +3",
		neck="Fotia Gorget",
		waist="Light Belt",
		left_ear="Moonshade Earring",
		right_ear="Ishvara Earring",
		left_ring="Dingir Ring",
		right_ring="Ilabrat Ring",
		back=Camulus.LastStand,}	
		
	sets.WS.Ranged.Mid = set_combine(sets.WS.Ranged.Normal, {
		neck="Iskur Gorget",
		--ear2="Telos Earring",
	})
	
	sets.WS.Ranged.Acc = set_combine(sets.WS.Ranged.Mid, {
		--ring1="Hajduk Ring +1",
		--ring2="Hajduk Ring +1",
		--ear2="Telos Earring",
	})
	
	sets.WS['Last Stand'] = {
		ammo="Chrono Bullet",
		head="Meghanada Visor +2",
		body="Laksa. Frac +3",
		hands="Meg. Gloves +2",
		legs=herc.legs.LastStand,
		feet="Lanun Bottes +3",
		neck="Fotia Gorget",
		waist="Light Belt",
		left_ear="Moonshade Earring",
		right_ear="Ishvara Earring",
		left_ring="Dingir Ring",
		right_ring="Ilabrat Ring",
		back=Camulus.LastStand,}	
	
	sets.WS['Last Stand'].Mid = set_combine(sets.WS['Last Stand'], {
		neck="Iskur Gorget",
		--ear2="Telos Earring",
		})
	
	sets.WS['Last Stand'].Mid.fullTP = set_combine(sets.WS['Last Stand'].Mid, {
		--ear1="Ishvara Earring",
		})
	
	sets.WS['Last Stand'].Acc = set_combine(sets.WS['Last Stand'].Mid, {
		--ring1="Hajduk Ring +1",
		--ring2="Hajduk Ring +1",
		--waist="K. Kachina Belt",
		})
	
	sets.WS['Last Stand'].Acc.fullTP = set_combine(sets.WS['Last Stand'].Acc, {
		--ear1="Ishvara Earring",
		})
		
	sets.WS['Leaden Salute'] =  {
		ammo="Living Bullet",
		head="Pixie Hairpin +1",
		body="Lanun Frac +3",
		hands=herc.hands.Leaden,
		legs=herc.legs.Leaden,
		feet="Lanun Bottes +3",
		neck="Commodore Charm +2",
		ear1="Moonshade Earring",
		ear2="Friomisi Earring",
		ring1="Dingir Ring",
		ring2="Archon Ring",
		back=Camulus.LeadenSalute,
		waist="Eschan Stone",
		}
		
	sets.WS['Leaden Salute'].Mid = set_combine(sets.WS['Leaden Salute'], {
		ear2="Hermetic Earring",
		})
		
	sets.WS['Leaden Salute'].Mid.fullTP = set_combine(sets.WS['Leaden Salute'].Mid, {
		ear1="Friomisi Earring",
		})
		
	sets.WS['Leaden Salute'].Acc = sets.WS['Leaden Salute'].Mid -- should have the fullTP set too, since pass by reference
	
	sets.WS['Wildfire'] =  {
		ammo="Living Bullet",
		head=herc.head.Wildfire,
		body="Lanun Frac +3",
		hands=herc.hands.Leaden,
		legs=herc.legs.Leaden,
		feet="Lanun Bottes +3",
		neck="Commodore Charm +2",
		ear1="Moonshade Earring",
		ear2="Friomisi Earring",
		ring1="Dingir Ring",
		ring2="Ilabrat Ring", -- regal ring or WSD ring
		back=Camulus.LeadenSalute,
		waist="Eschan Stone",
		}
		
	sets.WS['Wildfire'].Mid = set_combine(sets.WS['Wildfire'], {
		ear2="Hermetic Earring",
		})
		
	sets.WS['Wildfire'].Mid.fullTP = set_combine(sets.WS['Wildfire'].Mid, {
		ear1="Friomisi Earring",
		})
		
	sets.WS['Wildfire'].Acc = sets.WS['Wildfire'].Mid
	
	sets.WS['Hot Shot'] =  {
		ammo="Living bullet",
		head="Herculean Helm",
		body="Lanun Frac +3",
		hands=herc.hands.Leaden,
		legs=herc.legs.Leaden,
		feet="Lanun Bottes +3",
		neck="Commodore Charm +2",
		ear1="Moonshade Earring",
		ear2="Friomisi Earring",
		ring1="Dingir Ring",
		ring2="Ilabrat Ring",
		back=Camulus.LastStand,
		waist="Light Belt",
		}
		
	sets.WS['Hot Shot'].Mid = set_combine(sets.WS['Hot Shot'], {
		--ammo="Devestating Bullet"
		ring2="Hajduk Ring +1",
		})
	
	sets.WS['Hot Shot'].Acc = set_combine(sets.WS['Hot Shot'].Mid, {
		ring1="Hajduk Ring +1",
		waist="K. Kachina Belt +1",
		})
		
	sets.WS['Evisceration'] = {
		head="Mummu Bonnet +1",
		body="Meg. Cuirie +2",
		hands="Mummu Wrists +2",
		legs="Mummu Kecks +2",
		feet="Mummu Gamash. +1",
		neck="Fotia Gorget",
		ear1="Moonshade Earring",
		ear2="Brutal Earring",
		ring1="Regal Ring",
		ring2="Ilabrat Ring",
		back=Camulus.DA,
		waist="Fotia Belt",}
	
	sets.WS['Savage Blade'] = {
		head=herc.head.Savage,
		body="Laksa. Frac +3",
		hands="Meg. Gloves +2",
		legs="Meg. Chausses +2",
		feet="Lanun Bottes +3",
		neck="Commodore Charm +2",
		waist="Metalsinger Belt",
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Shukuyu Ring",
		ring2="Rufescent Ring",
		back=Camulus.Savage}
		
	sets.WS['Savage Blade'].Mid = set_combine(sets.WS['Savage Blade'], {
		head="Meghanada Visor +2"
		})
		
	sets.WS['Savage Blade'].Acc = set_combine(sets.WS['Savage Blade'].Mid, {
		--combatant's torque
		})
		
	sets.WS['Requiescat'] = set_combine(sets.WS['Savage Blade'], {
        head="Meghanada Visor +2",
        neck="Fotia Gorget",
        ring2="Epona's Ring",
        waist="Soil Belt",
        }) --MND

    sets.WS['Requiescat'].Acc = set_combine(sets.WS['Requiescat'], {
        neck="Combatant's Torque",
        })
		
	-- Midcast sets
	
	sets.midcast = {}
	
	sets.midcast.Utsusemi = {}
	
	sets.midcast.RA = {
		ammo="Chrono Bullet",
		head="Meghanada Visor +2",
		body="Mummu Jacket +2",
		hands=Adhemar.Hands.PathA,
		legs=Adhemar.Legs.PathC,
		feet="Meg. Jam. +2",
		neck="Iskur Gorget",
		ear1="Enervating Earring",
		ear2="Dignitary's Earring",
		ring1="Dingir Ring",
		ring2="Ilabrat Ring",
		waist="Yemaya Belt",
		back=Camulus.rSTP}
		
	sets.midcast.RA.Mid = set_combine(sets.midcast.RA,{
		--ammo="Devestating Bullet",
		feet="Meg. Jam. +2",
		ring1="Hajduk Ring +1",
		waist="K. Kachina Belt +1",
		})
		
	sets.midcast.RA.Acc = set_combine(sets.midcast.RA.Mid,{
		--ammo="Devestating Bullet",
		body="Laksamana Frac +3",
		hands="Meghanada Gloves +2",
		legs="Laskamana Trews +3",
		feet="Meg. Jam. +2",
		--waist="K. Kachina Belt +1",
		ring1="Hajduk Ring +1",
		ring2="Hajduk Ring +1",--Regal Ring
		})
		
	sets.TripleShot = {
		head="Oshosi Mask +1",
		body="Chasseur's Frac +1",
		--hands="Lanun Gants +3",
		--legs="Oshosi Trousers +1",
		--feet="Oshosi Leggings +1",
		}
		
	sets.idle = {
		head="Meghanada Visor +2",
		body="Lanun Frac +3",
		hands="Volte Bracers",
		legs="Mummu Kecks +2",
		feet=herc.feet.DT,
		neck="Loricate Torque +1",
		ear1="Odnowa Earring", --2/0
		ear2="Etiolation Earring",
		ring1="Defending Ring",
		ring2="Dark Ring",
		--back="Moonbeam Cape",
		back=Camulus.Snapshot,
		waist="Flume Belt",
		}
	
	sets.idle.ShellV = {
		head="Meghanada Visor +2",
		body="Lanun Frac +3",
		hands="Volte Bracers",
		legs="Mummu Kecks +2",
		feet="Lanun Bottes +3",
		neck="Loricate Torque +1",
		ear1="Odnowa Earring", --2/0
		ear2="Etiolation Earring",
		ring1="Defending Ring",
		ring2="Dark Ring",
		--back="Moonbeam Cape",
		back=Camulus.Snapshot,
		waist="Flume Belt",
		}

	sets.engaged = {}
		
	sets.engaged.SW = {
		--head="Dampening Tam",
		head="Adhemar Bonnet +1",
		body=Adhemar.Body.PathA,
		hands=Adhemar.Hands.PathA,
		legs="Samnuha Tights",
		feet=herc.feet.TA,
		neck="Iskur Gorget",
		left_ear="Suppanomimi", -- brutal
		right_ear="Dignitary's Earring", --5 cessance
		ring1="Chirich Ring +1",
		ring2="Epona's Ring",
		back=Camulus.DA,
		waist="Kentarch Belt +1",
		}

	sets.engaged.DW11 = { --this is the default TP set
		--head="Dampening Tam",
		head="Adhemar Bonnet +1",
		body=Adhemar.Body.PathA,
		hands=Adhemar.Hands.PathA,
		legs="Samnuha Tights",
		feet=herc.feet.TA,
		neck="Iskur Gorget",
		left_ear="Suppanomimi",
		right_ear="Dignitary's Earring", --5 cessance
		ring1="Chirich Ring +1",
		ring2="Epona's Ring",
		back=Camulus.DA,
		waist="Kentarch Belt +1", -- quadbuffet
		}
		
	sets.engaged.DW11.Mid = {
		--head="Dampening Tam",
		head="Adhemar Bonnet +1",
		body=Adhemar.Body.PathA,
		hands=Adhemar.Hands.PathA,
		legs="Samnuha Tights",
		feet=herc.feet.TA,
		neck="Lissome Necklace",
		left_ear="Suppanomimi",
		right_ear="Dignitary's Earring", --5 telos
		ring1="Chirich Ring +1",
		ring2="Epona's Ring",
		back=Camulus.DA,
		waist="Kentarch Belt +1",
		}
		
	sets.engaged.DW11.Acc = set_combine( sets.engaged.DW11.Mid, {
		legs="Meghanada Chausses +2"
		})
		
	sets.engaged.DW15 = {
		--head="Dampening Tam",
		head="Adhemar Bonnet +1",
		body=Adhemar.Body.PathA,
		hands=Adhemar.Hands.PathA,
		legs="Samnuha Tights",
		feet=herc.feet.TA,
		neck="Iskur Gorget",
		left_ear="Suppanomimi",
		right_ear="Eabani Earring", 
		ring1="Chirich Ring +1",
		ring2="Epona's Ring",
		back=Camulus.DA,
		waist="Kentarch Belt +1", -- quadbuffet
		}
		
		sets.cursna = {}
		sets.CureReceived = {}
	
	sets.engaged.DW15.Mid = set_combine( sets.engaged.DW15, {
		neck="Lissome Necklace",
		legs="Meghanada Chausses +2",
		})
		
	sets.engaged.Hybrid = {
		head=Adhemar.Head.PathD,
		neck="Loricate Torque +1",
		feet=herc.feet.DT
		}
		
	sets.Obi = {waist="Hachirin-no-obi"}
		
	send_command('lua load gearinfo')
end

function file_unload() -- unbind hotkeys
	send_command('lua u gearinfo')
	send_command('unbind f9')
	send_command('unbind ^f9')
	send_command('unbind !f9')
	send_command('unbind @f9')
	
	send_command('unbind f10')
	
	send_command('unbind f11')
	send_command('unbind ^f11')
	
	send_command('unbind f12')
	send_command('unbind ^f12')
	send_command('unbind !f12')
	
	send_command('unbind numpad0')
	send_command('unbind numpad.')
end

function self_command(commandArgs)
	local commandArgs = commandArgs
	if type(commandArgs) == 'string' then
		commandArgs = T(commandArgs:split(' '))
		if #commandArgs == 0 then
			return
		end
	end
	
	gearinfo(commandArgs)
	
	-- Of the original command message passed in, remove the first word from
	-- the list (it will be used to determine which function to call), and
	-- send the remaining words as parameters for the function.
	local handleCmd = table.remove(commandArgs, 1)
	if selfCommandMaps[handleCmd] then
		selfCommandMaps[handleCmd](commandArgs)
	end
	
end

function handle_switch(cmdParams)
	if #cmdParams == 0 then
		return
	end
	if cmdParams[1] == 'DT' then
		emergancy_DT = true
		add_to_chat(123,'DT set on')
	elseif cmdParams[1] == 'DD' then
		emergancy_DT = false
		add_to_chat(123,'DT set off')
	end
	update_gear()
end

function handle_cycle(cmdParams)
	if #cmdParams == 0 then
		add_to_chat(123,'Cycle failure: field not specified.')
		return
	end
	field = cycle_shortcuts[cmdParams[1]]
	cycle_table[field][1] = cycle_table[field][1] + 1
	if cycle_table[field][1] > #cycle_table[field] then
		cycle_table[field][1] = 2
	end
	add_to_chat(123,field..' set to '..cycle_table[field][cycle_table[field][1]])
	update_gear()
end

function handle_roll1(cmdParams)
	local rollchange = false
	if cmd[2] == nil then windower.add_to_chat(7,'Roll 1: '..Rollindex[Roll_ind_1]..'') return
	elseif cmd[2]:lower():startswith("warlock") or cmd[2]:lower():startswith("macc") or cmd[2]:lower():startswith("magic ac") or cmd[2]:lower():startswith("rdm") then Roll_ind_1 = 5  rollchange = true
	elseif cmd[2]:lower():startswith("fight") or cmd[2]:lower():startswith("double") or cmd[2]:lower():startswith("dbl") or cmd[2]:lower():startswith("war") then Roll_ind_1 = 1  rollchange = true
	elseif cmd[2]:lower():startswith("monk") or cmd[2]:lower():startswith("subtle") or cmd[2]:lower():startswith("mnk") then Roll_ind_1 = 2  rollchange = true
	elseif cmd[2]:lower():startswith("heal") or cmd[2]:lower():startswith("cure") or cmd[2]:lower():startswith("whm") then Roll_ind_1 = 3  rollchange = true
	elseif cmd[2]:lower():startswith("wizard") or cmd[2]:lower():startswith("matk") or cmd[2]:lower():startswith("magic at") or cmd[2]:lower():startswith("blm") then Roll_ind_1 = 4  rollchange = true
	elseif cmd[2]:lower():startswith("rogue") or cmd[2]:lower():startswith("crit") or cmd[2]:lower():startswith("thf") then Roll_ind_1 = 6  rollchange = true
	elseif cmd[2]:lower():startswith("gallant") or cmd[2]:lower():startswith("def") or cmd[2]:lower():startswith("pld") then Roll_ind_1 = 7  rollchange = true
	elseif cmd[2]:lower():startswith("chaos") or cmd[2]:lower():startswith("attack") or cmd[2]:lower():startswith("atk") or cmd[2]:lower():startswith("drk") then Roll_ind_1 = 8  rollchange = true
	elseif cmd[2]:lower():startswith("beast") or cmd[2]:lower():startswith("pet at") or cmd[2]:lower():startswith("bst") then Roll_ind_1 = 9  rollchange = true
	elseif cmd[2]:lower():startswith("choral") or cmd[2]:lower():startswith("inter") or cmd[2]:lower():startswith("spell inter") or cmd[2]:lower():startswith("brd") then Roll_ind_1 = 10  rollchange = true
	elseif cmd[2]:lower():startswith("hunt") or cmd[2]:lower():startswith("acc") or  cmd[2]:lower():startswith("rng") then Roll_ind_1 = 11  rollchange = true
	elseif cmd[2]:lower():startswith("sam") or cmd[2]:lower():startswith("stp") or cmd[2]:lower():startswith("store") then Roll_ind_1 = 12  rollchange = true
	elseif cmd[2]:lower():startswith("nin") or cmd[2]:lower():startswith("eva") then Roll_ind_1 = 13  rollchange = true
	elseif cmd[2]:lower():startswith("drach") or cmd[2]:lower():startswith("pet ac") or cmd[2]:lower():startswith("drg") then Roll_ind_1 = 14  rollchange = true
	elseif cmd[2]:lower():startswith("evoke") or cmd[2]:lower():startswith("refresh") or cmd[2]:lower():startswith("smn") then Roll_ind_1 = 15  rollchange = true
	elseif cmd[2]:lower():startswith("magus") or cmd[2]:lower():startswith("mdb") or cmd[2]:lower():startswith("magic d") or cmd[2]:lower():startswith("blu") then Roll_ind_1 = 16  rollchange = true
	elseif cmd[2]:lower():startswith("cor") or cmd[2]:lower():startswith("exp") then Roll_ind_1 = 17  rollchange = true
	elseif cmd[2]:lower():startswith("pup") or cmd[2]:lower():startswith("pet m") then Roll_ind_1 = 18  rollchange = true
	elseif cmd[2]:lower():startswith("dance") or cmd[2]:lower():startswith("regen") or cmd[2]:lower():startswith("dnc") then Roll_ind_1 = 19  rollchange = true
	elseif cmd[2]:lower():startswith("sch") or cmd[2]:lower():startswith("conserve m") then Roll_ind_1 = 20  rollchange = true
	elseif cmd[2]:lower():startswith("bolt") or cmd[2]:lower():startswith("move") or cmd[2]:lower():startswith("flee") or cmd[2]:lower():startswith("speed") then Roll_ind_1 = 21  rollchange = true
	elseif cmd[2]:lower():startswith("cast") or cmd[2]:lower():startswith("fast") or cmd[2]:lower():startswith("fc") then Roll_ind_1 = 22  rollchange = true
	elseif cmd[2]:lower():startswith("course") or cmd[2]:lower():startswith("snap") then Roll_ind_1 = 23  rollchange = true
	elseif cmd[2]:lower():startswith("blitz") or cmd[2]:lower():startswith("delay") then Roll_ind_1 = 24  rollchange = true
	elseif cmd[2]:lower():startswith("tact") or cmd[2]:lower():startswith("regain") then Roll_ind_1 = 25  rollchange = true
	elseif cmd[2]:lower():startswith("all") or cmd[2]:lower():startswith("skillchain") then Roll_ind_1 = 26  rollchange = true
	elseif cmd[2]:lower():startswith("miser") or cmd[2]:lower():startswith("save tp") or cmd[2]:lower():startswith("conserve t") then Roll_ind_1 = 27  rollchange = true
	elseif cmd[2]:lower():startswith("companion") or cmd[2]:lower():startswith("pet r") then Roll_ind_1 = 28  rollchange = true
	elseif cmd[2]:lower():startswith("avenge") or cmd[2]:lower():startswith("counter") then Roll_ind_1 = 29  rollchange = true
	elseif cmd[2]:lower():startswith("natural") or cmd[2]:lower():startswith("enhance") or cmd[2]:lower():startswith("duration") then Roll_ind_1 = 30  rollchange = true
	elseif cmd[2]:lower():startswith("run") or cmd[2]:lower():startswith("meva") or cmd[2]:lower():startswith("magic e") then Roll_ind_1 = 31  rollchange = true
	end
	
	if rollchange == true then
		windower.add_to_chat(7,'Setting Roll 1 to: '..Rollindex[Roll_ind_1]..'')
	else
		windower.add_to_chat(7,'Invalid roll name, Roll 1 remains: '..Rollindex[Roll_ind_1]..'')
	end
end

function handle_roll2(cmdParams)
	local rollchange = false
	if cmd[2] == nil then windower.add_to_chat(7,'Roll 1: '..Rollindex[Roll_ind_2]..'') return
	elseif cmd[2]:lower():startswith("warlock") or cmd[2]:lower():startswith("macc") or cmd[2]:lower():startswith("magic ac") or cmd[2]:lower():startswith("rdm") then Roll_ind_2 = 5  rollchange = true
	elseif cmd[2]:lower():startswith("fight") or cmd[2]:lower():startswith("double") or cmd[2]:lower():startswith("dbl") or cmd[2]:lower():startswith("war") then Roll_ind_2 = 1  rollchange = true
	elseif cmd[2]:lower():startswith("monk") or cmd[2]:lower():startswith("subtle") or cmd[2]:lower():startswith("mnk") then Roll_ind_2 = 2  rollchange = true
	elseif cmd[2]:lower():startswith("heal") or cmd[2]:lower():startswith("cure") or cmd[2]:lower():startswith("whm") then Roll_ind_2 = 3  rollchange = true
	elseif cmd[2]:lower():startswith("wizard") or cmd[2]:lower():startswith("matk") or cmd[2]:lower():startswith("magic at") or cmd[2]:lower():startswith("blm") then Roll_ind_2 = 4  rollchange = true
	elseif cmd[2]:lower():startswith("rogue") or cmd[2]:lower():startswith("crit") or cmd[2]:lower():startswith("thf") then Roll_ind_2 = 6  rollchange = true
	elseif cmd[2]:lower():startswith("gallant") or cmd[2]:lower():startswith("def") or cmd[2]:lower():startswith("pld") then Roll_ind_2 = 7  rollchange = true
	elseif cmd[2]:lower():startswith("chaos") or cmd[2]:lower():startswith("attack") or cmd[2]:lower():startswith("atk") or cmd[2]:lower():startswith("drk") then Roll_ind_2 = 8  rollchange = true
	elseif cmd[2]:lower():startswith("beast") or cmd[2]:lower():startswith("pet at") or cmd[2]:lower():startswith("bst") then Roll_ind_2 = 9  rollchange = true
	elseif cmd[2]:lower():startswith("choral") or cmd[2]:lower():startswith("inter") or cmd[2]:lower():startswith("spell inter") or cmd[2]:lower():startswith("brd") then Roll_ind_2 = 10  rollchange = true
	elseif cmd[2]:lower():startswith("hunt") or cmd[2]:lower():startswith("acc") or  cmd[2]:lower():startswith("rng") then Roll_ind_2 = 11  rollchange = true
	elseif cmd[2]:lower():startswith("sam") or cmd[2]:lower():startswith("stp") or cmd[2]:lower():startswith("store") then Roll_ind_2 = 12  rollchange = true
	elseif cmd[2]:lower():startswith("nin") or cmd[2]:lower():startswith("eva") then Roll_ind_2 = 13  rollchange = true
	elseif cmd[2]:lower():startswith("drach") or cmd[2]:lower():startswith("pet ac") or cmd[2]:lower():startswith("drg") then Roll_ind_2 = 14  rollchange = true
	elseif cmd[2]:lower():startswith("evoke") or cmd[2]:lower():startswith("refresh") or cmd[2]:lower():startswith("smn") then Roll_ind_2 = 15  rollchange = true
	elseif cmd[2]:lower():startswith("magus") or cmd[2]:lower():startswith("mdb") or cmd[2]:lower():startswith("magic d") or cmd[2]:lower():startswith("blu") then Roll_ind_2 = 16  rollchange = true
	elseif cmd[2]:lower():startswith("cor") or cmd[2]:lower():startswith("exp") then Roll_ind_2 = 17  rollchange = true
	elseif cmd[2]:lower():startswith("pup") or cmd[2]:lower():startswith("pet m") then Roll_ind_2 = 18  rollchange = true
	elseif cmd[2]:lower():startswith("dance") or cmd[2]:lower():startswith("regen") or cmd[2]:lower():startswith("dnc") then Roll_ind_2 = 19  rollchange = true
	elseif cmd[2]:lower():startswith("sch") or cmd[2]:lower():startswith("conserve m") then Roll_ind_2 = 20  rollchange = true
	elseif cmd[2]:lower():startswith("bolt") or cmd[2]:lower():startswith("move") or cmd[2]:lower():startswith("flee") or cmd[2]:lower():startswith("speed") then Roll_ind_2 = 21  rollchange = true
	elseif cmd[2]:lower():startswith("cast") or cmd[2]:lower():startswith("fast") or cmd[2]:lower():startswith("fc") then Roll_ind_2 = 22  rollchange = true
	elseif cmd[2]:lower():startswith("course") or cmd[2]:lower():startswith("snap") then Roll_ind_2 = 23  rollchange = true
	elseif cmd[2]:lower():startswith("blitz") or cmd[2]:lower():startswith("delay") then Roll_ind_2 = 24  rollchange = true
	elseif cmd[2]:lower():startswith("tact") or cmd[2]:lower():startswith("regain") then Roll_ind_2 = 25  rollchange = true
	elseif cmd[2]:lower():startswith("all") or cmd[2]:lower():startswith("skillchain") then Roll_ind_2 = 26  rollchange = true
	elseif cmd[2]:lower():startswith("miser") or cmd[2]:lower():startswith("save tp") or cmd[2]:lower():startswith("conserve t") then Roll_ind_2 = 27  rollchange = true
	elseif cmd[2]:lower():startswith("companion") or cmd[2]:lower():startswith("pet r") then Roll_ind_2 = 28  rollchange = true
	elseif cmd[2]:lower():startswith("avenge") or cmd[2]:lower():startswith("counter") then Roll_ind_2 = 29  rollchange = true
	elseif cmd[2]:lower():startswith("natural") or cmd[2]:lower():startswith("enhance") or cmd[2]:lower():startswith("duration") then Roll_ind_2 = 30  rollchange = true
	elseif cmd[2]:lower():startswith("run") or cmd[2]:lower():startswith("meva") or cmd[2]:lower():startswith("magic e") then Roll_ind_2 = 31  rollchange = true
	end
	
	if rollchange == true then
		windower.add_to_chat(7,'Setting Roll 1 to: '..Rollindex[Roll_ind_2]..'')
	else
		windower.add_to_chat(7,'Invalid roll name, Roll 1 remains: '..Rollindex[Roll_ind_2]..'')
	end
end

function save_weapons()
	add_to_chat(123,'Main, sub, and range saved')
	weapons = {
		main = player.equipment.main,
		sub = player.equipment.sub,
		range = player.equipment.range}
end



function get_idle_set()
	if buffactive['Shell'] then
		return sets.idle.ShellV
	else
		return sets.idle
	end
end

function get_engaged_set()
	--haste = get_haste()
	local acc = cycle_table['Melee Accuracy']
	if sets.engaged[get_haste_set()][acc[acc[1]]] then -- sets.engaged.DW11.Mid
		s = sets.engaged[get_haste_set()][acc[acc[1]]]
	else
		s = sets.engaged[get_haste_set()] -- sets.engaged.DW11
	end
	return s
end

function get_haste_set()
	local k = 100
	for i,set in pairs(haste_sets) do -- assumes it iterates in order
		if DW_Needed <= i then
			if i < k then
				k = i
			end
		end
	end
	return haste_sets[k]
end

function get_WS_acc(ws)
	local acc = {}
	if weaponskills[ws] then	
		acc = weaponskills[ws]
	else
		acc = 'Physical Accuracy'
	end
	return cycle_table[acc][cycle_table[acc][1]] -- a string 'Normal', 'Mid', or 'High'
end

function get_WS_type(ws)
	local t = weaponskills[ws]
	if t == 'Ranged Accuracy' then
		return 'Ranged'
	elseif t == 'Magic Accuracy' then
		return 'Magic'
	else
		return 'Physical'
	end
end

function handle_cure()
	equip(sets.CureReceived)
end

function handle_cursna()
	equip(sets.Cursna)
end

function handle_qd()
	local element = cycle_table['Quickdraw Element'][cycle_table['Quickdraw Element'][1]]
	send_command('input /ja "'..element..' shot" <t>')
end

function gearinfo(cmdParams)
    if cmdParams[1] == 'gearinfo' then
        if type(tonumber(cmdParams[2])) == 'number' then
            if tonumber(cmdParams[2]) ~= DW_Needed then
				DW_Needed = tonumber(cmdParams[2])
				DW = true
            end
        elseif type(cmdParams[2]) == 'string' then
            if cmdParams[2] == 'false' then
        	    DW_Needed = 0
                DW = false
      	    end
        end
        --[[if type(tonumber(cmdParams[3])) == 'number' then
          	if tonumber(cmdParams[3]) ~= Haste then
              	Haste = tonumber(cmdParams[3])
            end
        end]]
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
		if not moving then
			local t = ft_target()
			--if t and t.valid_target and not t.in_party and not bit.band(0xFF000000,t.id) then --t.id ~= player.id then
			--print(bit.band(0xFF00000000,t.id))
			--print(bit.tohex(t.id))
			--print(bit.band(t.id,0xFF000000))
			if t and bit.band(t.id,0xFF000000) ~= 0 then -- highest byte of target.id indicates whether it's a play or not
				facetarget()
			end
		end
        if not midaction() and player.status == 'Engaged' then
            update_gear()
        end
    end
end

function update_gear()
	if player.status == 'Engaged' and not emergancy_DT then
		equip(get_engaged_set())
		if cycle_table['DD Mode'][1] == 3 then
			equip(sets.engaged.Hybrid)
		end
	else -- if we are idle
		equip(get_idle_set())
	end
	if buffactive.Sleep or buffactive.Lullaby then
		equip(get_idle_set())
	end
end

function get_eTP()
	local etp = player.tp + 250
	if player.equipment.range == 'Fomalhaut' then
		local etp = etp + 500
	elseif player.equipment.range == 'Anarchy +2' then
		local etp = etp + 1000
	end
	return etp
end

function buff_change(buff,gain)
	if buff == 'Sleep' or buff == 'Lullaby' then update_gear() end
end

local sch_storms = {
	Fire='Firestorm',
	Earth='Sandstorm',
	Water='Rainstorm',
	Wind='Windstorm',
	Ice='Hailstorm',
	Thunder='Thunderstorm',
	Light='Aurorastorm',
	Dark='Voidstorm'
}

function precast(spell,action)
	--if RA_precast(spell,action) then return end -- intercept and queue actions if autoRA is on
	
	-- rng helper integration --
	eventArgs = {} 
	filter_precast(spell, {}, eventArgs)
	if eventArgs.cancel then return end
	-- end rng helper integration --
	
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
	elseif spell.action_type == 'Ranged Attack' then
		if spell.target.distance > 24.9 then
			cancel_spell()
			return
		end
		if buffactive[265] or buffactive[581] then
			if flurry == 1 then
				equip(sets.precast.RA.Flurry1)
			else
				equip(sets.precast.RA.Flurry2)
			end
		else
			equip(sets.precast.RA)
		end
		local t = ft_target()
		if t and bit.band(t.id,0xFF000000) ~= 0 then -- highest byte of target.id indicates whether it's a play or not
			facetarget()
		end
	elseif spell.type == 'WeaponSkill' then
		if spell.skill == 'Marksmanship' then
			if spell.target.distance > 21 then
				cancel_spell()
				return
			end
		elseif spell.target.distance > 5.9 then
			cancel_spell()
			return
		end
		if sets.WS[spell.name] then
			if sets.WS[spell.name][get_WS_acc(spell.name)] then
				set = sets.WS[spell.name][get_WS_acc(spell.name)] -- sets.WS.WSName.Acc
			else
				set = sets.WS[spell.name]	-- sets.WS.WSName
			end
		else
			set = sets.WS[get_WS_type(spell.name)][get_WS_acc(spell.name)] -- sets.WS.Physical.Acc	
		end
		if get_eTP() > 2900 then
			if set.maxTP then
				set = set.maxTP
			end
		end
		---add_to_chat(set)
		equip(set)
		-- May need to check buffs for scholar storms
		if get_WS_type(spell.name) == 'Magic' and (	world.weather_element == spell.element or
													world.day_element == spell.element ) then
			equip(sets.Obi)
		end
		facetarget()
	elseif spell.name:contains('Waltz') then
		equip(sets.precast.Waltz)
	elseif spell.name:contains('Step') then
		equip(sets.precast.Step)
	elseif spell.type == 'CorsairRoll' and spell.name:contains('Roll') then
			-- if we want to only swap weapons at certain tp thresholds, put that logic here
			if not midroll then
				save_weapons()
			end
			midroll = true
			equip(sets.JA['Phantom Roll'])	
	elseif spell.type == 'CorsairShot' then
		if cycle_table['Quickdraw Mode'][cycle_table['Quickdraw Mode'][1]] == 2 then -- damage/acc
			if spell.name:contains('Light') or spell.name:contains('Dark') then
				equip(sets.JA.Quickdraw.Accuracy)
			else
				equip(sets.JA.Quickdraw.Damage)
			end
		else -- STP
			equip(sets.JA.Quickdraw['Store TP'])			
		end
		facetarget()
		
	elseif spell.type == 'JobAbility' then	
		if sets.JA[spell.name] then
			equip(sets.JA[spell.name])
		elseif spell.english == 'Fold' and buffactive['Bust'] == 2 then
			equip(sets.JA.FoldDoubleBust)
		end
		-- Again, don't know if this will catch sch storms
		if world.weather_element == spell.element or world.day_element == spell.element then
			equip(sets.Obi)
		end
	elseif spell.name:contains('Soultrapper') then
		equip({ammo="Blank Soulplate"})
	end
end

function midcast(spell,action)
	if spell.name == 'Sneak' or spell.name == 'Spectral Jig' or spell.name:startswith('Monomi') and spell.target.type == 'SELF' then --click off buffs if needed
		send_command('cancel 71')
	end
	if spell.action_type == 'Magic' then
		if sets.midcast[spell.name] then 
			equip(sets.midcast[spell.name])
		elseif sets.midcast[spell.skill] then
			equip(sets.midcast[spell.skill])
		else
			equip(sets.midcast)
		end
	elseif spell.action_type == 'Ranged Attack' then
		local acc = cycle_table['Ranged Accuracy'][cycle_table['Ranged Accuracy'][1]]
		if acc == 'Normal' then
			equip(sets.midcast.RA)
		else
			equip(sets.midcast.RA[acc])
		end
		if buffactive['Triple Shot'] then
			equip(sets.TripleShot)
		end
	end
end

function aftercast(spell,action)
	if not midroll then
		equip(weapons)
	end
	--if spell.type == 'CorsairRoll' then
	equip({range=weapons.range})
	midroll = false
	--end
	--[[if spell.type == 'Ranged Attack' or spell.type == 'CorsairShot' or spell.type == 'WeaponSkill' then
		facetarget()
	end]]
	
	update_gear()
end

function status_change(new,action)
	update_gear()
end

function facetarget()
	if not autofacetarget then return end
	local t = ft_target()
	local destX = t.x
	local destY = t.y
	local direction = math.abs(PlayerH - math.deg(HeadingTo(destX,destY)))
	if direction > 5 then
		windower.ffxi.turn(HeadingTo(destX,destY))
	end
end

function ft_target()
	local rh = rh_status()
	if rh.enabled and rh.target then
		return windower.ffxi.get_mob_by_id(rh.target)
	else
		return windower.ffxi.get_mob_by_target('t')
	end
end

function HeadingTo(X,Y)
	local X = X - windower.ffxi.get_mob_by_id(windower.ffxi.get_player().id).x
	local Y = Y - windower.ffxi.get_mob_by_id(windower.ffxi.get_player().id).y
	local H = math.atan2(X,Y)
	return H - 1.5708
end

windower.raw_register_event('outgoing chunk', function(id, data)
    if id == 0x015 then
        local action_message = packets.parse('outgoing', data)
		PlayerH = action_message["Rotation"]
	end
end)

windower.raw_register_event('action',
    function(act)
        --check if you are a target of spell
        local actionTargets = act.targets
        playerId = windower.ffxi.get_player().id
        isTarget = false
        for _, target in ipairs(actionTargets) do
            if playerId == target.id then
                isTarget = true
            end
        end
        if isTarget == true then
            if act.category == 4 then
                local param = act.param
                if param == 845 and flurry ~= 2 then
                    --add_to_chat(122, 'Flurry Status: Flurry I')
                    flurry = 1
                elseif param == 846 then
                    --add_to_chat(122, 'Flurry Status: Flurry II')
                    flurry = 2
                end
            end
        end
    end)	