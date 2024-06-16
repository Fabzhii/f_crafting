
ESX.RegisterServerCallback('fcrafting:getJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getJob().name, xPlayer.getJob().grade)
end)

RegisterServerEvent('fcrafting:craftItem')
AddEventHandler('fcrafting:craftItem', function(item)
    exports.ox_inventory:AddItem(source, item.item, item.amount)
end)    

RegisterServerEvent('fcrafting:removeRequirements')
AddEventHandler('fcrafting:removeRequirements', function(requirements)
    for k,v in pairs(requirements) do 
        exports.ox_inventory:RemoveItem(source, v.item, v.amount)
    end 
end)   

RegisterServerEvent('fcrafting:addRequirements')
AddEventHandler('fcrafting:addRequirements', function(requirements)
    for k,v in pairs(requirements) do 
        exports.ox_inventory:AddItem(source, v.item, v.amount)
    end 
end)  
