Config = {}

Config.ImgPath = 'img/'

Config.DefaultTitle = 'Werkbank'
Config.RemoveItemsOnFailure = true
Config.CraftingRadius = 5.0

Config.CraftingLocations = {
    {
        locations = {
            vector3(219.6, -862.5,30.3),
            vector3(229.6, -866.5,30.3),
        },
        marker = {
            id = 21, 
            color = {r = 70, g = 70, b = 255},
            size = 0.5,
        },
        blip = {
            enabled = true,
            id = 459,
            color = 26,
        },
        title = 'Werkbank',
        access = {
            job = {'police', 'sheriff'},
            grades = {0, 1, 2},
        },
        categories = {
            {
                categoryLabel = 'Geld', 
                carftingRecipes = {
                    {    
                        output = {'creditcard', 1},
                        input = {
                            {'money', 500},
                            {'id-card', 1},
                        },
                        requiredTime = 10,
                        failureChance = 10,
                    },
                    {    
                        output = {'money', 3},
                        input = {
                            {'black_money', 5},
                        },
                        requiredTime = 5,
                        failureChance = 5,
                    },
                },
            },
            {
                categoryLabel = 'Essen', 
                carftingRecipes = {
                    {    
                        output = {'pizza_chs', 1},
                        input = {
                            {'noodles', 500},
                            {'water', 1},
                        },
                        requiredTime = 10,
                        failureChance = 10,
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
    ['item_craft_failed'] = {'Der Herstellungsprozess ist fehlgeschlagen!', 'error'},
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
