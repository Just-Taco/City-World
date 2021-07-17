local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "HT_base")

--local dato = os.date("%d/%m/%Y %X")

--vRP.DWebhook('https://discord.com/api/webhooks/783546803022069760/Jx8y42KhPHIF8fjL0t3YCNc9I6hoSJpwe7lInxU_0PlOtow6dfygOVLPSDGhT10Hw1Wx', 'UL SERVER STATUS', '> **SERVEREN STARTEDE**. \n> IP: 173.249.48.177:30120 \n> **DATO: '..dato)

HT = {}
HT.ServerCallbacks = {}
HT.UsableItemsCallbacks = {}
RegisterServerEvent('HT:triggerServerCallback')
AddEventHandler('HT:triggerServerCallback', function(name, requestId, ...)
	local _source = source
    HT.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('HT:serverCallback', _source, requestId, ...)
	end, ...)
end)

HT.TriggerServerCallback = function(name, requestId, source, cb, ...)
    if HT.ServerCallbacks[name] ~= nil then
        HT.ServerCallbacks[name](source, cb, ...)
    else
        --print('TriggerServerCallback => [' .. name .. '] does not exist')
    end
end

HT.RegisterUsableItem = function(item, cb)
	HT.UsableItemsCallbacks[item] = cb
end


HT.RegisterServerCallback = function(name, cb)
    HT.ServerCallbacks[name] = cb
end
  
AddEventHandler('HT_base:getBaseObjects', function(cb)
    cb(HT)
end)

HT.RegisterServerCallback('HT:JobCallback', function(source, cb, data)
    local user_id = vRP.getUserId({source})
    local job = vRP.getUserGroupByType({user_id,"job"})
    cb(job)
end)    

AddEventHandler('HT_base:playerLoaded', function(source)
    local xPlayer = vRP.getUserId({source})
end)

HT.RegisterServerCallback('vrp-hasgroup', function(source, cb, group)
    local user_id = vRP.getUserId({source})
    if vRP.hasGroup({user_id, perm}) then
      cb(true)
    else
      cb(false)
    end
end)