
ESX.RegisterServerCallback('fcrafting:getJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getJob().name, xPlayer.getJob().grade)
end)

RegisterServerEvent('fcrafting:craftItem')
AddEventHandler('fcrafting:craftItem', function(item)
    local cancelRequirements = false
    for k,v in pairs(item.requirements) do 
        if exports.ox_inventory:GetItemCount(source, v.item) < v.amount then 
            cancelRequirements = true
        end 
    end 
    if not cancelRequirements then 
        for k,v in pairs(item.requirements) do 
            exports.ox_inventory:RemoveItem(source, v.item, v.amount)
        end 
        exports.ox_inventory:AddItem(source, item.item, item.amount)
        TriggerClientEvent('fcrafting:result', source, true)
    else 
        TriggerClientEvent('fcrafting:result', source, false)
    end
end)    