
local craftingPosition = nil 
local craftingQueue = {}
local currentData = {}
local inUI = false 

local small = {}
local large = {}
local blips = {}

--
--- Crafting Queue Thread 
--

Citizen.CreateThread(function()
    while true do 
        if craftingPosition ~= nil then 
            if (#(GetEntityCoords(PlayerPedId()) - craftingPosition) > Config.CraftingRadius) and json.encode(craftingQueue) ~= '[]' then 
                for k,v in pairs(craftingQueue) do 
                    TriggerServerEvent('fcrafting:addRequirements', v.requirements)
                end 
                craftingQueue = {}
                Config.Notifcation(Config.Translation['too_far'])
            end 
        end 

        if json.encode(craftingQueue) ~= '[]'  then 
            craftingQueue[1].time = craftingQueue[1].time - 1
            if craftingQueue[1].time <= 0 then 
                TriggerServerEvent('fcrafting:craftItem', craftingQueue[1])
                table.remove(craftingQueue, 1)
                Config.Notifcation(Config.Translation['item_crafted'])
            end 

        end 

        Citizen.Wait(1000)
    end 
end)

--
--- Showing Markers and Blips
--

Citizen.CreateThread(function()
    for k,v in pairs(Config.CraftingLocations) do 
        large[k] = {}
        blips[k] = {}
        for o,i in pairs(v.locations) do 

            if v.blip.enabled then 
                blips[k][o] = AddBlipForCoord(i)
                SetBlipSprite(blips[k][o], v.blip.id)
                SetBlipDisplay(blips[k][o], 4)
                SetBlipScale(blips[k][o], 1.0)
                SetBlipColour(blips[k][o], v.blip.color)
                SetBlipAsShortRange(blips[k][o], true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.title)
                EndTextCommandSetBlipName(blips[k][o])
            end 

            large[k][o] = lib.zones.sphere({
                coords = i,
                radius = 25,
                debug = false,
                inside = function()
                    DrawMarker(v.marker.id, i, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.marker.size, v.marker.size, v.marker.size, v.marker.color.r, v.marker.color.g, v.marker.color.b, 120, false, true, 2, false)
                end,
            })
        end 
    end 
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.CraftingLocations) do 
        small[k] = {}
        for o,i in pairs(v.locations) do 
            small[k][o] = lib.zones.sphere({
                coords = i,
                radius = 1.2,
                debug = false,
                inside = function()
                    if IsControlJustReleased(0, 38) then 
                        openCrafter(i, k)
                    end 
                end,
                onEnter = function()
                    Config.InfoBar(Config.Translation['access'], true)
                end,
                onExit = function()
                    Config.InfoBar(Config.Translation['access'], false)
                end,
            })
        end 
    end 
end)

function openCrafter(position, crafter)
    lib.hideTextUI()
    exports[GetCurrentResourceName()]:openCraftingStation(Config.CraftingLocations[crafter], 1, nil)
end 

--
--- Nui Message and UI Display
--

function sendToNui(type, categories, table, queue, selectedCategorie, title, item, focus)
    SetNuiFocus(focus, focus)
    DisplayRadar(false)
    SendNUIMessage({
        type = type,
        categories = categories, 
        table = table, 
        queue = queue, 
        selectedCategorie = selectedCategorie,
        title = title,
        item = item,
        path = Config.ImgPath
    })
    inUI = true
    Citizen.CreateThread(function()
        while inUI do 
            SendNUIMessage({
                type = 'update',
                queue = craftingQueue, 
                path = Config.ImgPath
            })
            Citizen.Wait(250)
        end 
    end)
end 

--
--- Export with converting stationData table in ui format
--

exports('openCraftingStation', function(stationData, categorie, item)
    if stationData ~= nil then 
        currentData = stationData

        if categorie == nil then 
            categorie = 1
        end 

        local position = GetEntityCoords(PlayerPedId()) 
        if stationData.position ~= nil then 
            position = stationData.position 
        end 

        local position = GetEntityCoords(PlayerPedId()) 
        if stationData.position ~= nil then 
            position = stationData.position 
        end 

        local name = Config.DefaultTitle
        if stationData.title ~= nil then 
            name = stationData.title 
        end 

        local access = {job = nil, grades = nil}
        if stationData.access ~= nil then 
            access = stationData.access 
        end 

        local categories = {}
        if stationData.categories ~= nil then 
            categories = stationData.categories 
        end 

        ESX.TriggerServerCallback('fcrafting:getJob', function(xJob, xGrade)
            if access.job == nil then 
                openCrafting(position, name, categories, categorie, item)
            else 
                if type(access.job) == 'string' then 
                    if xJob == access.job then 
                        if access.grade == nil then 
                            openCrafting(position, name, categories, categorie, item)
                        else 
                            if type(access.grade) == 'number' then 
                                if xGrade >= access.grade then 
                                    openCrafting(position, name, categories, categorie, item)
                                end 
                            elseif type(access.grade) == 'table' then 
                                for o,i in pairs(access.grade) do 
                                    if i == access.grade then 
                                        openCrafting(position, name, categories, categorie, item)
                                    end 
                                end 
                            end 
                        end 
                    end 
                elseif  type(access.job) == 'table' then 
                    for k,v in pairs(access.job) do 
                        if v == xJob then 
                            if access.grade == nil then 
                                openCrafting(position, name, categories, categorie, item)
                            else 
                                if type(access.grade) == 'number' then 
                                    if xGrade >= access.grade then 
                                        openCrafting(position, name, categories, categorie, item)
                                    end 
                                elseif type(access.grade) == 'table' then 
                                    for o,i in pairs(access.grade) do 
                                        if i == access.grade then 
                                            openCrafting(position, name, categories, categorie, item)
                                        end 
                                    end 
                                end 
                            end 
                        end 
                    end 
                end 
            end 
        end)
    end 
end)

function openCrafting(xPosition, xName, xCategories, categorie, item)
    craftingPosition = xPosition

    local categories = getCategories(xCategories)
    local table = getTable(xCategories, categorie)
    local queue = craftingQueue
    local selectedCategorie = categorie
    local title = xName

    sendToNui('show', categories, table, queue, selectedCategorie, title, item, true)
end 


function getCategories(xCategories)
    local categories = {}
    for k,v in pairs(xCategories) do 
        table.insert(categories, {type = k, label = v.categoryLabel})
    end
    return categories
end 

function getTable(xCategories, position)
    local cat = {}
    local categorie = xCategories[position].carftingRecipes
    for k,v in pairs(categorie) do 

        table.insert(cat, {
            item = v.output[1],
            name = getName(v.output[1]),
            time = v.requiredTime,
            amount = v.output[2],
            requirements = getRequirements(v.input),
        })
    end 
    return cat
end 

function getRequirements(input)
    local requirements = {}
    for k,v in pairs(input) do 
        table.insert(requirements, {
            item = v[1],
            name = getName(v[1]),
            amount = (v[2]),
        })
    end 
    return requirements
end 

function getName(item)
    local name = ''
    for k,v in pairs(exports.ox_inventory:Items()) do 
        if v.name == item then 
            name = v.label
        end 
    end 
    return name
end 

function getCount(item)
    local count = 0
    for k,v in pairs(exports.ox_inventory:GetPlayerItems()) do 
        if v.name == item then 
            count = v.count
        end 
    end 
    return count
end 

-- 
--- NUI Callbacks
--

RegisterNUICallback('categorie', function(data, cb)
    local categorie = tonumber(data.returnValue)
    exports[GetCurrentResourceName()]:openCraftingStation(currentData, categorie, nil)
    cb({})
end)

RegisterNUICallback('exit', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'hide',
    })
    cb({})
    DisplayRadar(true)
    inUI = false 
end)

RegisterNUICallback('craft', function(data, cb)

    local item = data.returnValue[3]
    local itemnumber = data.returnValue[2] + 1
    local selectedCategorie = data.returnValue[1]

    local cancelRequirements = false
    for k,v in pairs(item.requirements) do 
        if getCount(v.item) < v.amount then 
            cancelRequirements = true
        end 
    end 
    if not cancelRequirements then 
        TriggerServerEvent('fcrafting:removeRequirements', item.requirements)

        table.insert(craftingQueue, {
            item = item.item,
            label = item.name,
            time = item.time,
            amount = item.amount,
            requirements = item.requirements,
        })
    else 
        Config.Notifcation(Config.Translation['no_requirements'])
    end 
    exports[GetCurrentResourceName()]:openCraftingStation(currentData, selectedCategorie, itemnumber)
    cb({})
end)

RegisterNUICallback('clear', function(data, cb)
    local itemnumber = data.returnValue[2] + 1
    local selectedCategorie = data.returnValue[1]
    for k,v in pairs(craftingQueue) do 
        TriggerServerEvent('fcrafting:addRequirements', v.requirements)
    end 
    craftingQueue = {}
    exports[GetCurrentResourceName()]:openCraftingStation(currentData, selectedCategorie, itemnumber)
    cb({})
end)
