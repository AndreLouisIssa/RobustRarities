public.define_rarity{ name = 'Heroic', above = 'Epic'}
public.define_rarity{ name = 'Elemental', above = 'Heroic' }
public.define_rarity{ name = 'Perfect', above = 'Elemental' }
public.define_rarity{ name = 'Duo', above = 'Perfect' }
public.define_rarity{ name = 'Legendary', above = 'Duo' }
public.define_rarity{ name = 'Legacy', below = 'Perfect' }
public.define_rarity{ name = 'Suspicious', color = { 207, 0, 0, 255 }, rank = 3 }

for _,v in pairs(game.TraitData) do 
    for _,u in pairs(v) do
        if type(u) == 'table' and u.RarityLevels ~= nil then u.RarityLevels =
            {
                Elemental =
                {
                    Multiplier = 1.00,
                },
                Perfect =
                {
                    Multiplier = 1.25,
                },
                Legacy =
                {
                    Multiplier = 1.50,
                },
                Suspicious =
                {
                    Multiplier = 1.75,
                }
            }
        end
        if type(u) == 'table' and u.RarityChances ~= nil then u.RarityChances =
            {
                Elemental =
                {
                    Multiplier = 1.75,
                },
                Perfect =
                {
                    Multiplier = 1.50,
                },
                Legacy =
                {
                    Multiplier = 1.25,
                },
                Suspicious =
                {
                    Multiplier = 1.00,
                }
            }
        end
        if type(u) == 'table' and u.Rarity ~= nil then
            u.Rarity = 'Suspicious'
        end
    end
end