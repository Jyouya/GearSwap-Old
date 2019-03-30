require('rnghelper')
require('modes')
require('GUI')
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
	send_command('bind f9 gs c cycle meleeAccuracy')
	send_command('bind ^f9 gs c cycle rangedAccuracy')
	send_command('bind !f9 gs c cycle magicAccuracy')
	send_command('bind @f9 gs c cycle hotshotAccuracy')
	
	send_command('bind f10 gs c set DDMode Emergancy DT')
	send_command('bind ^f10 gs c cycle DDMode')
	
	send_command('bind f11 gs c cycle quickdrawElement1')
	send_command('bind ^f11 gs c cycleback quickdrawElement1')
	send_command('bind !f11 gs c cycle quickdrawMode1')
	
	send_command('bind f12 gs c cycle quickdrawElement2')
	send_command('bind ^f12 gs c cycleback quickdrawElement2')
	send_command('bind !f12 gs c cycle quickdrawMode2')
	
	send_command('bind ^- gs c cycle meleeWeapons')
	send_command('bind ^= gs c cycle rangedWeapon')
	
	send_command('bind numpad0 input /ra <t>')
	send_command('bind numpad. gs c QD 1')
	send_command('bind ^numpad. gs c QD 2')
	
	
	selfCommandMaps = {
		['set']		= handle_set,
		['toggle']	= handle_toggle,
		['cycle']	= handle_cycle,
		['cycleback']	= handle_cycleback,
		['update']	= update_gear,
		['cursna']	= handle_cursna,
		['cure']	= handle_cure,
		['save']	= save_weapons,
		['QD']		= handle_qd,
		
		['face']	= handle_face,
		}
	
	rangedWeapon = M{['description']='Ranged Weapon', 'Death Penalty', 'Armageddon', 'Fomalhaut', 'Anarchy +2'}
	meleeWeapons = M{['description']='Melee Weapons', 'Rostam-Naegling', 'Rostam-Blurred', 'Rostam-Shield', 'Naegling-Blurred', 'Fettering-Shield', 'Rostam-Fettering'}
	
	weapontable = {
		['Rostam-Naegling']={main='Rostam',sub='Naegling'},
		['Rostam-Blurred']={main='Rostam',sub='Blurred Knife +1'},
		['Rostam-Shield']={main='Rostam',sub='Nusku Shield'},
		['Naegling-Blurred']={main='Naegling',sub={name='Blurred Knife +1',priority=15}},
		['Fettering-Shield']={main='Fettering Blade',sub='Nusku Shield'},
		['Rostam-Fettering']={main='Rostam',sub='Fettering Blade'}
		}
	
	meleeAccuracy = M{['description']='Melee Accuracy', 'Normal', 'Mid', 'Acc'}
	rangedAccuracy = M{['description']='Ranged Accuracy', 'Normal', 'Mid', 'Acc'}
	magicAccuracy = M{['description']='Magic Accuracy', 'Normal', 'Mid', 'Acc'}
	hotshotAccuracy = M{['description']='Hotshot Accuracy', 'Normal', 'Mid', 'Acc'}
	quickdrawElement1 = M{['description']='Primary Quickdraw Element', 'Fire', 'Earth', 'Water', 'Wind', 'Ice', 'Thunder', 'Light', 'Dark'}
	quickdrawElement2 = M{['description']='Secondary Quickdraw Element', 'Dark', 'Fire', 'Earth', 'Water', 'Wind', 'Ice', 'Thunder', 'Light'}
	quickdrawMode1 = M{['description']='Primary Quickdraw Mode', 'Damage', 'Store TP'}
	quickdrawMode2 = M{['description']='Secondary Quickdraw Mode', 'Damage', 'Store TP'}
	QDMode = 'Damage'
	DDMode = M{['description']='DD Mode', 'Normal', 'Hybrid', 'Emergancy DT'}
	emergancyDT = M(false,'Emegancy DT')
	
	DW_Needed = 11
	DW = true
	haste_sets = {
		[0]	 = 'SW',
		[11] = 'DW11',
		[74] = 'DW15',}	
	flurry = 1
	
	autofacetarget = true
	rm_target = nil
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
	Adhemar.Legs.PathD = { name="Adhemar Kecks +1", augments={'AGI+12','"Rapid Shot"+13','Enmity-6',}}
	Adhemar.Hands = {}
	Adhemar.Hands.PathA = { name="Adhemar Wrist. +1", augments={'DEX+12','AGI+12','Accuracy+20',}}
	Adhemar.Hands.PathC = { name="Adhemar Wrist. +1", augments={'AGI+12','Rng.Acc.+20','Rng.Atk.+20',}}
														
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
	
	sets.JA.FoldDoubleBust = {hands="Lanun Gants +3"}
	
	sets.JA.Quickdraw = {}
	sets.JA.Quickdraw.Damage = {}
	sets.JA.Quickdraw.Accuracy = {
		ammo="Living Bullet",
		head="Oshosi Mask +1",
		neck="Commodore Charm +2",
		ear1="Gwati Earring",
		ear2="Dignitary's Earring",
		body="Mummu Jacket +2",
		hands="Mummu Wrists +2",
		ring1="Rahab Ring",
		ring2="Kishar Ring",
		back=Camulus.LeadenSalute,
		waist="Kwahu Kachina Belt +1",
		legs="Mummu Kecks +2",
		feet="Oshosi Leggings +1",}
	sets.JA.Quickdraw['Store TP'] = {
		ammo="Living Bullet",
		neck="Iskur Gorget",
		ear1="Enervating Earring",
		ear2="Dignitary's Earring",
		body="Mummu Jacket +2",
		hands=Adhemar.Hands.PathC,
		ring1="Chirich Ring +1",
		ring2="Ilabrat Ring",
		back=Camulus.Quickdraw,
		waist="Kentarch Belt +1",
		legs="Chas. Culottes +1",
		feet="Mummu Gamashes +2"}
	
	sets.precast = {
		head="Herculean Helm",
		neck="Baetyl Pendant",
		hands="Leyline Gloves",
		ring1="Rahab Ring",
		ring2="Kishar Ring",
		back=Camulus.Fastcast,}
		
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
		legs=Adhemar.Legs.PathD,
		feet="Meg. Jam. +2",
		back=Camulus.Snapshot,
		waist="Yameya Belt",}
		
	sets.precast.RA.Flurry2 = {
		ammo="Chrono Bullet",
		head="Chass. Tricorne +1",
		neck="Commodore Charm +2",
		body="Laksamana's Frac +3",
		hands="Carmine Fin. Ga. +1",
		legs=Adhemar.Legs.PathD,
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
		ring1="Hajduk Ring +1",
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
		ear1="Ishvara Earring",
		})
	
	sets.WS['Last Stand'].Acc = set_combine(sets.WS['Last Stand'].Mid, {
		ring1="Hajduk Ring +1",
		--ring2="Hajduk Ring +1",
		waist="K. Kachina Belt",
		})
	
	sets.WS['Last Stand'].Acc.fullTP = set_combine(sets.WS['Last Stand'].Acc, {
		ear1="Ishvara Earring",
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
		hands=Adhemar.Hands.PathC,
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
		waist="K. Kachina Belt +1",
		ring1="Hajduk Ring +1",
		ring2="Hajduk Ring +1",--Regal Ring
		})
		
	sets.TripleShot = {
		head="Oshosi Mask +1",
		body="Chasseur's Frac +1",
		hands="Lanun Gants +3",
		legs="Oshosi Trousers +1",
		feet="Oshosi Leggings +1",
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
		
	sets.engaged.DW15.Acc = set_combine( sets.engaged.DW15.Mid, {
		
		})
		
	sets.engaged.Hybrid = {
		head=Adhemar.Head.PathD,
		neck="Loricate Torque +1",
		feet=herc.feet.DT
		}
		
	sets.Obi = {waist="Hachirin-no-obi"}
		
	send_command('lua load gearinfo')
	build_UI()
end

function file_unload() -- unbind hotkeys
	send_command('lua u gearinfo')
	send_command('unbind f9')
	send_command('unbind ^f9')
	send_command('unbind !f9')
	send_command('unbind @f9')
	
	send_command('unbind f10')
	send_command('unbind ^f10')
	
	send_command('unbind f11')
	send_command('unbind ^f11')
	send_command('unbind !f11')
	
	send_command('unbind f12')
	send_command('unbind ^f12')
	send_command('unbind !f12')
	
	send_command('unbind ^-')
	send_command('unbind ^=')
	
	send_command('unbind numpad0')
	send_command('unbind numpad.')
	send_command('unbind ^numpad.')
end

function build_UI()
	DT = IconButton{
		x = 1732,
		y = 80,
		var = DDMode,
		icons = {
			{img = 'DD Normal.png', value = 'Normal'},
			{img = 'DD Hybrid.png', value = 'Hybrid'},
			{img = 'Emergancy DT.png', value = 'Emergancy DT'}
		},
		command = 'gs c update'
	}
	DT:draw()

	weap = IconButton{
		x = 1732,
		y = 134,
		var = meleeWeapons,
		icons = {
			{img = 'Rostam-Naegling.png', value = 'Rostam-Naegling'},
			{img = 'Rostam-Blurred.png', value = 'Rostam-Blurred'},
			{img = 'Rostam-Nusku.png', value = 'Rostam-Shield'},
			{img = 'Kaja-Blurred.png', value = 'Naegling-Blurred'},
			{img = 'Fettering-Nusku.png', value = 'Fettering-Shield'},
			{img = 'Rostam-Fettering.png', value = 'Rostam-Fettering'}
		},
		command = 'gs c update'
	}
	weap:draw() -- initialize the weapon button
	
	range= IconButton{
		x = 1732,
		y = 188,
		var = rangedWeapon,
		icons = {
			{img = 'Death Penalty.png', value = 'Death Penalty'},
			{img = 'Armageddon.png', value = 'Armageddon'},
			{img = 'Fomalhaut.png', value = 'Fomalhaut'},
			{img = 'Anarchy +2.png', value = 'Anarchy +2'}
		},
		command = 'gs c update'
	}
	range:draw()
	
	QD1 = IconButton{
		x = 1732,
		y = 242,
		var = quickdrawElement1,
		icons = {
			{img = 'Fire Shot.png', value = 'Fire'},
			{img = 'Earth Shot.png', value = 'Earth'},
			{img = 'Water Shot.png', value = 'Water'},
			{img = 'Wind Shot.png', value = 'Wind'},
			{img = 'Ice Shot.png', value = 'Ice'},
			{img = 'Thunder Shot.png', value = 'Thunder'},
			{img = 'Light Shot.png', value = 'Light'},
			{img = 'Dark Shot.png', value = 'Dark'}
		},
		command = 'gs c update'
	}
	QD1:draw()
	QD2 = IconButton{
		x = 1732,
		y = 296,
		var = quickdrawElement2,
		icons = {
			{img = 'Fire Shot.png', value = 'Fire'},
			{img = 'Earth Shot.png', value = 'Earth'},
			{img = 'Water Shot.png', value = 'Water'},
			{img = 'Wind Shot.png', value = 'Wind'},
			{img = 'Ice Shot.png', value = 'Ice'},
			{img = 'Thunder Shot.png', value = 'Thunder'},
			{img = 'Light Shot.png', value = 'Light'},
			{img = 'Dark Shot.png', value = 'Dark'}
		},
		command = 'gs c update'
	}
	QD2:draw()
	
	RHToggle = ToggleButton{
		x = 1732,
		y = 404,
		var = 'enabled',
		iconUp = 'RH Off.png',
		iconDown = 'RH On.png',
	}
	RHToggle:draw()
	
	AMToggle = ToggleButton{
		x = 1732,
		y = 458,
		var = 'useAM',
		iconUp = 'Aftermath Off.png',
		iconDown = 'Aftermath On.png',
	}
	AMToggle:draw()
	
	RHWS = PassiveText({
		x = 1896,
		y = 512,
		text = 'RH Weaponskill: %s',
		--var = 'weaponskill',
		align = 'right'},
		'weaponskill')
	RHWS:draw()
	
	Acc_display = TextCycle{
		x = 1896,
		y = 532,
		var = meleeAccuracy,
		align = 'right',
		width = 112,
		command = 'gs c update'
	}
	Acc_display:draw()
	
	RAcc_display = TextCycle{
		x = 1896,
		y = 564,
		var = rangedAccuracy,
		align = 'right',
		width = 112,
		command = 'gs c update'
	}
	RAcc_display:draw()
	
	MAcc_display = TextCycle{
		x = 1896,
		y = 596,
		var = magicAccuracy,
		align = 'right',
		width = 112,
		command = 'gs c update'
	}
	MAcc_display:draw()
	
	HAcc_display = TextCycle{
		x = 1896,
		y = 628,
		var = hotshotAccuracy,
		align = 'right',
		width = 112,
		command = 'gs c update'
	}
	HAcc_display:draw()
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

function handle_toggle(cmdParams)
	if #cmdParams == 0 then
		return
	end
	mode = _G[cmdParams[1]]
	mode:toggle()
	add_to_chat(123,'%s set to %s':format(mode.description,tostring(mode.value)))
	update_gear()
end

function handle_set(cmdParams)
	if #cmdParams == 0 then
		return
	end
	local m = table.remove(cmdParams, 1)
	mode = _G[m]
	
	local s = table.remove(cmdParams, 1)
	if #cmdParams ~= 0 then
		for i,word in ipairs(cmdParams) do
			s = s..' '..word
		end
	end
	
	mode:set(s)
	update_gear()
	add_to_chat(123,'%s set to %s':format(mode.description, tostring(mode.value)))
end

function handle_cycle(cmdParams)
	if #cmdParams == 0 then
		add_to_chat(123,'Cycle failure: field not specified.')
		return
	end
	mode = _G[cmdParams[1]]
	mode:cycle()
	add_to_chat(123,'%s set to %s':format(mode.description,mode.value))
	update_gear()
end

function handle_cycleback(cmdParams)
	if #cmdParams == 0 then
		add_to_chat(123,'Cycle failure: field not specified.')
		return
	end
	mode = _G[cmdParams[1]]
	mode:cycleback()
	add_to_chat(123,'%s set to %s':format(mode.description,mode.value))
	update_gear()
end

function get_idle_set()
	if buffactive['Shell'] then
		return sets.idle.ShellV
	else
		return sets.idle
	end
end

function get_engaged_set()	
	local acc = meleeAccuracy.value
	local haste = get_haste_set()
	
	if sets.engaged[haste][acc] then
		s = sets.engaged[haste][acc]
	else
		s = sets.engaged[haste]
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
	return _G[weaponskills[ws] or 'meleeAccuracy'].value
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

function handle_qd(cmdParams)
	local element = _G['quickdrawElement%i':format(cmdParams[1])].value
	QDMode = _G['quickdrawMode%i':format(cmdParams[1])].value	-- set global QD mode for the precast function
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
        if type(cmdParams[4]) == 'string' then
            if cmdParams[4] == 'true' then
                moving = true
            elseif cmdParams[4] == 'false' then
                moving = false
            end
        end
		if not moving then
			local t = ft_target()
			if t and bit.band(t.id,0xFF000000) ~= 0 then -- highest byte of target.id indicates whether it's a player or not
				facetarget()
			end
		end
        if not midaction() and player.status == 'Engaged' then
            update_gear()
        end
    end
end

function handle_face(target)
	rm_target = tonumber(target)
end

function update_gear()
	if player.status == 'Engaged' and DDMode.value ~=  'Emergancy DT' then
		equip(get_engaged_set())
		if DDMode.value == 'Hybrid' then
			equip(sets.engaged.Hybrid)
		end
	else -- if we are idle
		equip(get_idle_set())
	end
	if buffactive.Sleep or buffactive.Lullaby then
		equip(get_idle_set())
	end
	--print(rangedWeapon.value, meleeWeapons.value)
	
	equip({range=rangedWeapon.value})
	equip(weapontable[meleeWeapons.value])
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
	if buff == 'Flurry' and not gain then
		flurry = 0
	end
end

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
		equip(set)
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

			equip(sets.JA['Phantom Roll'])	
	elseif spell.type == 'CorsairShot' then
		if QDMode == 'Damage' then
			if spell.name:contains('Light') or spell.name:contains('Dark') then
				equip(sets.JA.Quickdraw.Accuracy)
			else
				equip(sets.JA.Quickdraw.Damage)
			end
		else -- STP
			if spell.name:contains('Light') or spell.name:contains('Dark') then
				equip(sets.JA.Quickdraw.Accuracy)
			else
				equip(sets.JA.Quickdraw['Store TP'])
			end
		end
		facetarget()
		
	elseif spell.type == 'JobAbility' then	
		if sets.JA[spell.name] then
			equip(sets.JA[spell.name])
		elseif spell.english == 'Fold' and buffactive['Bust'] == 2 then
			equip(sets.JA.FoldDoubleBust)
		end
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
		local acc = rangedAccuracy.value
		local gun = rangedWeapon.value
		local equipSet = sets.midcast.RA
		
		if equipSet[gun] then
			equipSet = equipSet[gun]
		end
		if equipSet.AM3 and buffactive['Aftermath: Lv.3'] then
			equipSet = equipSet.AM3
		end
		if equipSet[acc] then
			equipSet = equipSet[acc]
		end
		equip(equipSet)
		if buffactive['Triple Shot'] then
			equip(sets.TripleShot)
		end
	end
end

function aftercast(spell,action)
	rm_target = nil
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
	elseif rm_target then
		return windower.ffxi.get_mob_by_id(rm_target)
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