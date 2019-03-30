function get_dw_needed()
	local gear_haste = 256
	local ja_haste = 0
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
	return DW_Needed
end

function Job_DW()
	local player = windower.ffxi.get_player()
	if player.main_job == 'NIN' then
		return 35
	elseif player.main_job == 'DNC' then
		return 35
	elseif player.sub_job == 'NIN' then
		return 25
	elseif player.sub_job == 'DNC' then
		return 15
	end
	return 0
end

function get_MA_haste() -- result undefined if gearswap's vars are not loaded.
	local ma_haste = 0
	if buffactive[33] then  -- Haste 1 and 2
		ma_haste = ma_haste + 150
	end
	if Haste_Level == 2 then -- rest of haste 2
		ma_haste = ma_haste + 157
	end
	if buffactive['march'] then -- First march is honor march
		ma_haste = ma_haste + 174
		if buffactive['march'] > 1 then -- second is victory march
			ma_haste = ma_haste + 293
		end
		if buffactive['march'] > 2 then -- advancing march for some reason
			ma_haste = ma_haste + 194
		end
	end
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
                end
            end
        end
    end)	