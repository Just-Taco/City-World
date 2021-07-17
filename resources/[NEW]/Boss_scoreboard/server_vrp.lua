local Boss_scoreboard = class("Boss_scoreboard", vRP.Extension)

function Boss_scoreboard:__construct()
	vRP.Extension.__construct(self)
  
	self.cfg = module("Boss_scoreboard", "cfg/cfg")
end

--##################################
--			Clent Calls
--##################################
RegisterServerEvent('Boss_scoreboard:getInfo')
AddEventHandler('Boss_scoreboard:getInfo', function()
	vRP:triggerEvent("PlayerInfo")
end)
RegisterServerEvent('Boss_scoreboard:getCounts')
AddEventHandler('Boss_scoreboard:getCounts', function()
	vRP:triggerEvent("JobCount")
end)
--##################################
--			Events
--##################################
Boss_scoreboard.event = {}
local info = {}

function Boss_scoreboard.event:PlayerInfo()
	local users = vRP.EXT.Group:getUsersByPermission("!group.user")
	local perm = self.cfg.perms
    local color = self.cfg.color
	
	for _,user in pairs(users) do
		local identity = vRP.EXT.Identity:getIdentity(user.cid)
		local id = user.cid
		local gtype = user:getGroupByType("job")
		local firstName = identity.firstname
		local lastName = identity.name
		local phoneNumber = user.identity.phone
        local content = ""
		local m_job = "Unemployed"
		if m_job then
			if not user:hasGroup(gtype) then
				user:addGroup(self.cfg.default)
			else 
				m_job = vRP.EXT.Group:getGroupTitle(gtype)
			end
		end

		if user:hasPermission(perm.online_1) then			--Owner
			info.color = color.profile_1
		elseif user:hasPermission(perm.online_2) then		--Admin
			info.color = color.profile_2
		elseif user:hasPermission(perm.online_3) then		--Mod
			info.color = color.profile_3
		else												--User
			info.color = color.profile_4
		end
		
		info.id = content.."<div>"..id.."</div>"
		info.name = content.."<div>"..firstName.." "..lastName.."</div>"
		info.job = content.."<div>"..m_job.."</div>"
		info.job_color = color.job_name
		info.phone = "<div>"..phoneNumber.."</div>"
		info.phone_color = color.phone_number
		
	end
	TriggerClientEvent("Boss_scoreboard:setScoreboard", source, info)
end

local j_info = {}

function Boss_scoreboard.event:JobCount()
	local perm = self.cfg.perms
	
	j_info.job_1 = #vRP.EXT.Group:getUsersByPermission(perm.job_1)
	j_info.job_2 = #vRP.EXT.Group:getUsersByPermission(perm.job_2)
	j_info.job_3 = #vRP.EXT.Group:getUsersByPermission(perm.job_3)
	j_info.job_4 = #vRP.EXT.Group:getUsersByPermission(perm.job_4)
	
	j_info.extra_1 = #vRP.EXT.Group:getUsersByPermission(perm.extra_1)
	j_info.extra_2 = #vRP.EXT.Group:getUsersByPermission(perm.extra_2)
	j_info.extra_3 = #vRP.EXT.Group:getUsersByPermission(perm.extra_3)
	j_info.extra_4 = #vRP.EXT.Group:getUsersByPermission(perm.extra_4)
	
	j_info.online_1 = #vRP.EXT.Group:getUsersByPermission(perm.online_1)
	j_info.online_2 = #vRP.EXT.Group:getUsersByPermission(perm.online_2)
	j_info.online_3 = #vRP.EXT.Group:getUsersByPermission(perm.online_3)
	j_info.online_4 = #vRP.EXT.Group:getUsersByPermission(perm.online_4)
	
	TriggerClientEvent("Boss_scoreboard:setCount", source, j_info)
end

vRP:registerExtension(Boss_scoreboard)