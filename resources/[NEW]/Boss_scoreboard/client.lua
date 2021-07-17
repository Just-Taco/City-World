local keys = {
	["~"] = 243, 
	["."] = 81,
	["INSERT"] = 121,
}
--[[#####################################################################
						UI Functions
#####################################################################--]]
RegisterNetEvent('Boss_scoreboard:openUI')		--Open Ui												
AddEventHandler('Boss_scoreboard:openUI', function()	
	SendNUIMessage({type = 'openUI'}) 
end)
--[[##########################--]]			--Close Ui													
RegisterNetEvent('Boss_scoreboard:closeUI')														
AddEventHandler('Boss_scoreboard:closeUI', function()	
	SetNuiFocus(false, false)	
	SendNUIMessage({type = 'closeUI'})	
end)
--##################################
--			Callbacks
--##################################
RegisterNUICallback("NUIFocusOff", function() --close function for when mouse is active
    SetNuiFocus(false, false)
	scoreboard_Active = false
end)
RegisterNUICallback("NUIFocusOff_m", function() --close function for mouse
	SetNuiFocus(false, false)
end)
--##################################
--			key functions
--##################################
scoreboard_Active = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		
		if IsControlJustReleased(0, keys["INSERT"]) then 	-- scoreboard toggle
			if scoreboard_Active then
				scoreboard_Active = false
				TriggerEvent("Boss_scoreboard:closeUI", source)
			else
				scoreboard_Active = true
				TriggerEvent("Boss_scoreboard:openUI", source)
				TriggerServerEvent('Boss_scoreboard:getInfo', source)
			end
		end
		if IsControlJustReleased(0, keys["."]) and scoreboard_Active then 	--- Mouse toggle
			SetNuiFocus(true, true)		
		end
    end
end)
--##################################
--			Table Functions
--##################################
RegisterNetEvent('Boss_scoreboard:setScoreboard')
AddEventHandler('Boss_scoreboard:setScoreboard', function(info)
	local players = {}
	table.insert(players,
		'<tr><td><button class="profile" id="profile" style="border-color: '.. info.color ..'"><div class="player_info"><div id="player_id">'
		.. info.id ..'</div><div id="player_name">'
		.. info.name ..'</div></div ><div class="extra_info"><div class="player_job"><div id="job_title">Job Title:</div><div id="job_name" style="color: '.. info.job_color ..'">'
		.. info.job ..'</div></div><div class="player_phone"><div id="phone_label">Phone:</div><div id="phone_number" style="color: '.. info.phone_color ..'">'
		.. info.phone ..'</div></div></div></button></td></tr>'
	)
	
	SendNUIMessage({type = 'update_List',	text = table.concat(players)})
	
	TriggerServerEvent('Boss_scoreboard:getCounts')
end)

RegisterNetEvent('Boss_scoreboard:setCount')
AddEventHandler('Boss_scoreboard:setCount', function(j_info)
	
	SendNUIMessage({
		action = 'update_Counts',
		jobs = {
			job_1 = j_info.job_1,
			job_2 = j_info.job_2,
			job_3 = j_info.job_3,
			job_4 = j_info.job_4,
			
			extra_1 = j_info.extra_1,
			extra_2 = j_info.extra_2,
			extra_3 = j_info.extra_3,
			extra_4 = j_info.extra_4,
			
			online_1 = j_info.online_1,
			online_2 = j_info.online_2,
			online_3 = j_info.online_3,
			online_4 = j_info.online_4,
		}
	})	
end)
--##################################
--			Functions
--##################################
function GetPlayers()
    local players = {}

    for i = 0, 256 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end