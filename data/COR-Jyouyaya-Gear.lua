function build_gearsets()
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
	Camulus.AM3 = { name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','AGI+10','Crit.hit rate+10','Phys. dmg. taken-10%',}}
	
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
		ammo="Devastating Bullet",
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
		ear2="Telos Earring",
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
		head="Taeon Chapeau",
		neck="Commodore Charm +2",
		body="Laksamana's Frac +3",
		hands="Carmine Fin. Ga. +1",
		legs="Laksamana's Trews +3",
		feet="Meg. Jam. +2",
		back=Camulus.Snapshot,
		waist="Impulse Belt",}
		
	sets.precast.RA.Flurry1 = {
		head="Taeon Chapeau",
		neck="Commodore Charm +2",
		body="Laksamana's Frac +3",
		hands="Carmine Fin. Ga. +1",
		legs=Adhemar.Legs.PathD,
		feet="Meg. Jam. +2",
		back=Camulus.Snapshot,
		waist="Yameya Belt",}
		
	sets.precast.RA.Flurry2 = {
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
		back=Camulus.LeadenSalute,
		waist="Light Belt",
		}
		
	sets.WS['Hot Shot'].Mid = set_combine(sets.WS['Hot Shot'], {
		--ammo="Devastating Bullet"
		body="Laksamana's Frac +3",
		ring2="Hajduk Ring +1",
		})
	
	sets.WS['Hot Shot'].Acc = set_combine(sets.WS['Hot Shot'].Mid, {
		ammo="Devastating Bullet",
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
		ear2="Telos Earring",
		ring1="Dingir Ring",
		ring2="Ilabrat Ring",
		waist="Yemaya Belt",
		back=Camulus.rSTP}
		
	sets.midcast.RA.Mid = set_combine(sets.midcast.RA,{
		ammo="Devastating Bullet",
		feet="Meg. Jam. +2",
		ring1="Hajduk Ring +1",
		waist="K. Kachina Belt +1",
		})
		
	sets.midcast.RA.Acc = set_combine(sets.midcast.RA.Mid,{
		ammo="Devastating Bullet",
		body="Laksamana's Frac +3",
		--hands="Meghanada Gloves +2",
		legs="Laksamana's Trews +3",
		feet="Meg. Jam. +2",
		waist="K. Kachina Belt +1",
		ring1="Hajduk Ring +1",
		--ring2="Hajduk Ring +1",--Regal Ring
		})
		
	sets.midcast.RA.Armageddon = set_combine(sets.midcast.RA, {})
	sets.midcast.RA.Armageddon.Mid = set_combine(sets.midcast.RA.Mid, {})
	sets.midcast.RA.Armageddon.Acc = set_combine(sets.midcast.RA.Acc, {})
	
	sets.midcast.RA.Armageddon.AM3 = {
		ammo="Chrono Bullet",
		head="Meghanada Visor +2",
		body="Meghanada Cuirie +2",
		hands="Mummu Wrists +2",
		legs="Darraigner's Brais",
		feet="Oshosi Leggings +1",
		neck="Iskur Gorget",
		waist="K. Kachina Belt +1",
		ear1="Enervating Earring",
		ear2="Telos Earring",
		ring1="Mummu Ring",
		ring2="Begrudging Ring",
		back=Camulus.AM3	
	}
		
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
		right_ear="Telos Earring", --5 cessance
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
		right_ear="Telos Earring", --5 cessance
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
		right_ear="Telos Earring", --5 telos
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
	
	sets.TreasureHunter = {
		hands="Volte Bracers",
		ring1="Gorney Ring",
		waist="Chaac Belt"
		}
	
	sets.item = {}
end
