---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

mod = modutil.mod.Mod.Register(_PLUGIN.guid)

data = mod.Data

function stale_run()
    return data.run == nil or game.CurrentRun == nil or game.TableLength(game.GameState.RunHistory) ~= data.run
end

function restore()
    if data.rarities == nil then
        data.rarities = {}
    end
    if data.traits == nil or stale_run() then
        data.traits = {}
        data.run = nil
    end
    for k,v in pairs(rarities) do
        data.rarities[k] = v
    end
    for k,v in pairs(traits) do
        data.traits[k] = v
    end
    for k,v in pairs(data.rarities) do
        rarities[k] = v
    end
    for k,v in pairs(data.traits) do
        traits[k] = v
    end

    if game.CurrentRun ~= nil then
        data.run = game.TableLength(game.RunHistory)
        for _, traitData in pairs(game.CurrentRun.Hero.Traits) do
            local name = traitData.Name
            local rarity = rarities[traits[name]]
            if rarity ~= nil and rom.mods[rarity.plugin] ~= nil and traitData.RarityLevels ~= nil and traitData.RarityLevels[rarity.name] ~= nil then
                traitData.Rarity = rarity.name
            end
        end
    end

    for name,rarity in pairs(rarities) do
        game.TraitRarityData.RarityValues[name] = rarity.rank or 0

        local exists, order
        
        order = game.TraitRarityData.BoonRarityRollOrder
        exists = game.ToLookup(order)[name]
        if not exists then
            local j = nil
            if rarity.above ~= nil then
                j = 0
                for i,v in ipairs(order) do
                    if v == rarity.above then
                        j = i + 1
                    end
                end
            elseif rarity.below ~= nil then
                for i,v in ipairs(order) do
                    if v == rarity.below then
                        j = i
                    end
                end
            end

            if j ~= nil then
                table.insert(order,j,name)
            else 
                table.insert(order,name)
            end
        end

        order = game.TraitRarityData.RarityUpgradeOrder
        exists = game.ToLookup(order)[name]
        if not exists then
            local j = nil
            if rarity.above ~= nil then
                j = 0
                for i,v in ipairs(order) do
                    if v == rarity.above then
                        j = i + 1
                    end
                end
            elseif rarity.below ~= nil then
                for i,v in ipairs(order) do
                    if v == rarity.below then
                        j = i
                    end
                end
            end

            if j ~= nil then
                table.insert(order,j,name)
            else 
                table.insert(order,name)
            end
        end

        j = #game.TraitRarityData.BoonRarityRollOrder
        for i,v in ipairs(game.TraitRarityData.BoonRarityRollOrder) do
            game.TraitRarityData.BoonRarityReverseRollOrder[j-i+1] = v
        end

        if rarity.color ~= nil then
            game.Color['BoonPatch' .. name] = rarity.color
        end

    end
end

function clean()
    if game.CurrentRun ~= nil then
        for _, traitData in pairs(game.CurrentRun.Hero.Traits) do
            local name = traitData.Rarity
            local rarity = rarities[name]
            if rarity ~= nil then
                set_trait(traitData.Name, name)
                traitData.Rarity = 'Common'
            end
        end
    end
end

modutil.mod.Path.Wrap('Save', function(base, ...)
    clean()
    base(...)
    restore()
end)

modutil.mod.Path.Wrap('SaveCheckpoint', function(base, ...)
    clean()
    base(...)
    restore()
end)

restore()