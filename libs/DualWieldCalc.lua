packets = require('packets')
res = require('resources')
function get_dw_needed()
	local gear_haste = 256
	local ja_haste = get_JA_haste()
	local ma_haste = get_MA_haste()
	
	if ja_haste > 256 then
		ja_haste = 256
	end
	if ma_haste > 448 then
		ma_haste = 448
	end
	
	total_haste = gear_haste + ja_haste + ma_haste
	if total_haste > 819 then
		total_haste = 819
	end
	DW_Needed = math.ceil( (1- (0.2 / ((1024 - total_haste) / 1024 )) ) * 100 - Job_DW())
	--print(DW_Needed)
	return DW_Needed
end

function Job_DW()
	local player = windower.ffxi.get_player()
	if player.main_job == 'NIN' then
		return 35
	elseif player.main_job == 'DNC' then
		return 35
	elseif player.main_job == 'THF' then
		return 30
	elseif player.sub_job == 'NIN' then
		return 25
	elseif player.sub_job == 'DNC' then
		return 15
	end
	return 0
end

function get_JA_haste()
	local ja_haste = 0
	local player = windower.ffxi.get_player()
	update_party()
	
	local DNC_Main = false
	
	for k, v in pairs(member_table) do
		if v['Main job'] == 'DNC' then
			DNC_main = true
		end
	end
	
	if DNC_Main then
		ja_haste = ja_haste + 101
	elseif buffactive['haste samba'] then
		ja_haste = ja_haste + 51
	end
	
	return ja_haste
end

function update_party()
	local old = member_table
	local new = {}
	
	member_table = {}
	
	local party = windower.ffxi.get_party()

    local key_indices = {'p0', 'p1', 'p2', 'p3', 'p4', 'p5',}
   
    for k = 1, 6 do
        local member = party[key_indices[k]]
        if member and member.mob then
			new[member.mob.name] = {id = member.mob.id , name = member.mob.name, mob = member.mob, ['Main job']=0,['Sub job']=0}
        end
	end
	
	for new_name, new_member in pairs(new) do
		for old_name, old_member in pairs(old) do
			if old_name == new_name then
				new[old_name] = {id = old_member.id , name = old_member.name, mob = new_member.mob, ['Main job'] = old_member['Main job'], ['Sub job'] = old_member['Sub job']}
			end
		end
	end
	
	for new_name, new_member in pairs(new) do
		if new_member.id == player.id then
			new[new_name]['Main job'] = player.main_job
			if new[new_name]['Sub job'] then
				new[new_name]['Sub job'] = player.sub_job
			else
				new[new_name]['Sub job'] ='NON'
			end
		elseif party_from_packet[new_member.id] and new_member.id ~= player.id then
			new[new_name]['Main job'] = res.jobs:with('id', party_from_packet[new_member.id]['Main job']).ens
			new[new_name]['Sub job'] = res.jobs:with('id', party_from_packet[new_member.id]['Sub job']).ens
		end
	end
end

function get_MA_haste() -- result undefined if gearswap's vars are not loaded.
	local ma_haste = 0
	if buffactive[33] then  -- Haste 1 and 2
		ma_haste = ma_haste + 150
	end
	if Haste_Level == 2 then -- rest of haste 2
		ma_haste = ma_haste + 157
	end
	for i = 1, buffactive['march'] or 0, 1 do
		ma_haste = ma_haste + MarchInfo[Marches[i]]
	end
	--[[if buffactive['march'] then -- First march is honor march
		ma_haste = ma_haste + 174
		if buffactive['march'] > 1 then -- second is victory march
			ma_haste = ma_haste + 293
		end
		if buffactive['march'] > 2 then -- advancing march for some reason
			ma_haste = ma_haste + 194
		end
	end]]
	if buffactive['embrava'] then
		ma_haste = ma_haste + 266
	end
	if buffactive[604] then -- mighty guard
		ma_haste = ma_haste + 150
	end
	if buffactive[580] then -- indi/geo haste
		ma_haste = ma_haste + 300
	end
	return ma_haste
end

Haste_Level = 0
Marches = {'Honor March','Victory March','Advancing March'} -- Have a list with all three, and just order them by the most recent
MarchInfo = {
	['Honor March'] = 174,
	['Victory March'] = 293,
	['Advancing March'] = 194,
}
member_table = {}
party_from_packet = {}

function Add_March(march)
	for i = 1, 3 do
		if Marches[i] == march then
			table.remove(Marches, i)
			table.insert(Marches, 1, march)
			break
		end
	end
end

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
                if param == 57 and Haste_Level ~= 2 then
                    Haste_Level = 1
                elseif param == 511 then
                    Haste_Level = 2
				elseif param == 417 then -- honor march
					Add_March('Honor March')
				elseif param == 420 then -- victory march
					Add_March('Victory March')
				elseif param == 419 then -- advancing march
					Add_March('Advancing March')
                end
            end
        end
    end)
	
windower.raw_register_event('incoming chunk', function(id, data, modified, injected, blocked)
	if id == 0x0DD then
		local packet = packets.parse('incoming', data)
		party_from_packet[packet['ID']] = {id = packet['ID'] , name = packet['Name'], ['Main job'] = packet['Main job'], ['Sub job'] = packet['Sub job']} 
	end
end)