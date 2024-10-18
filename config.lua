Config = {}

Config.ImgPath = 'nui://ox_inventory/web/images/'

Config.DefaultTitle = 'Werkbank'
Config.RemoveItemsOnFailure = true
Config.CraftingRadius = 5.0

Config.CraftingLocations = {

    {
        locations = {
            vector3(958.5643, 3616.1636, 32.7644),
            vector3(-2314.1997, 259.1409, 169.6019),
        },
        marker = {
            id = 21, 
            color = {r = 70, g = 70, b = 255},
            size = 0.5,
        },
        blip = {
            enabled = true,
            id = 402,
            color = 4,
        },
        title = 'Crafter',
        access = {
            job = nil,
            grades = nil,
        },
        categories = {
            {
                categoryLabel = 'Banane', 
                carftingRecipes = {
                    {    
                        output = {'apple', 1},
                        input = {
                            {'banana', 1},
                        },
                        requiredTime = 120,
                    },
                },
            },
            {
                categoryLabel = 'Apfel', 
                carftingRecipes = {
                    {    
                        output = {'banana', 1},
                        input = {
                            {'apple', 1},
                        },
                        requiredTime = 120,
                    },
                },
            },
        },
    },
}

Config.Translation = {
    ['access'] = {'[E] - Mit Crafter Interagieren', nil},
    ['no_requirements'] = {'Du hast nicht die benötigten Gegenstände!', 'error'},
    ['too_far'] = {'Du hast dich zu weit vom Crafter entfernt!', 'error'},
    ['item_crafted'] = {'Du hast einen Gegenstand hergestellt!', 'success'},
    ['queue_cleared'] = {'Du hast die Crafting Warteschlange geleert!', 'info'},
}

Config.Notifcation = function(notify)
    local message = notify[1]
    local notify_type = notify[2]
    lib.notify({
        position = 'top-right',
        description = message,
        type = notify_type,
    })
end 

Config.InfoBar = function(info, toggle)
    local message = info[1]
    local notify_type = info[2]
    if toggle then 
        lib.showTextUI(message, {position = 'left-center'})
    else 
        lib.hideTextUI()
    end
end 
