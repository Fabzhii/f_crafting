# f_crafting
FiveM Crafting system with exports.

## Export

```lua
  exports[f_crafting]:openCraftingStation(data, categorie, item)
```

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `data` | `table` | **Required**. Crafting Table Content |
| `categorie` | `number` | Slot of the default Categorie |
| `item` | `number` | Slot of the default Item |

### Example

```lua

    local data = {
        position = vector3(1, 2, 3),
        title = 'Workbench',
        access = {job = 'police', grades = 5},
        categories = {
            {
                categoryLabel = 'General', 
                carftingRecipes = {
                    {    
                        output = {'handcuffs', 1},
                        input = {
                            {'metal', 5},
                            {'gear', 1},
                        },
                        requiredTime = 10,
                    },
                },
            },
            {
                categoryLabel = 'Guns', 
                carftingRecipes = {
                    {    
                        output = {'weapon_pistol', 1},
                        input = {
                            {'metal', 5},
                            {'gun_body', 2},
                        },
                        requiredTime = 15,
                    },
                    {    
                        output = {'weapon_smg', 1},
                        input = {
                            {'metal', 7},
                            {'gun_body', 4},
                        },
                        requiredTime = 25,
                    },
                },
            },
        }
    }

    local categorie = 2 -- Guns Categorie will be opened by default

    local item = 2 -- weapon_smg will be opened by default

  exports[f_crafting]:openCraftingStation(data, categorie, item)
```
