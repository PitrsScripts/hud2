local Framework, frameworkType


CreateThread(function()
    if GetResourceState("es_extended") == "started" then
        Framework = exports["es_extended"]:getSharedObject()
        frameworkType = "esx"
        print("[HUD] Framework detected: ESX")
    elseif GetResourceState("qb-core") == "started" then
        Framework = exports["qb-core"]:GetCoreObject()
        frameworkType = "qbcore"
        print("[HUD] Framework detected: QBCore")
    else
        print("[HUD] Error: No supported framework (ESX or QBCore) detected.")
    end
end)

RegisterNetEvent('pitrs_hud:server:UpdateArmor', function(newArmor)
    local src = source
    if frameworkType == "esx" then
        local xPlayer = Framework.GetPlayerFromId(src)
        if xPlayer then
            local identifier = xPlayer.identifier
            MySQL.update('UPDATE users SET armor = ? WHERE identifier = ?', {
                newArmor,
                identifier
            })
        end
    elseif frameworkType == "qbcore" then
        local Player = Framework.Functions.GetPlayer(src)
        if Player then
            Player.Functions.SetMetaData("armor", newArmor)
        end
    end
end)


RegisterNetEvent('pitrs_hud:server:UpdateHealth', function(newHealth)
    local src = source
    if frameworkType == "esx" then
        local xPlayer = Framework.GetPlayerFromId(src)
        if xPlayer then
            local identifier = xPlayer.identifier
            MySQL.update('UPDATE users SET health = ? WHERE identifier = ?', {
                newHealth,
                identifier
            })
        end
    elseif frameworkType == "qbcore" then
        local Player = Framework.Functions.GetPlayer(src)
        if Player then
            Player.Functions.SetMetaData("health", newHealth)
        end
    end
end)

RegisterNetEvent('pitrs_hud:server:LoadArmorAndHealth', function()
    local src = source
    if frameworkType == "esx" then
        local xPlayer = Framework.GetPlayerFromId(src)
        if xPlayer then
            local identifier = xPlayer.identifier
            MySQL.single('SELECT armor, health FROM users WHERE identifier = ?', {identifier}, function(result)
                if result then
                    TriggerClientEvent('pitrs_hud:client:UpdateArmorAndHealth', src, result.armor or 0, result.health or 100)
                else
                    TriggerClientEvent('pitrs_hud:client:UpdateArmorAndHealth', src, 0, 100)
                end
            end)
        end
    elseif frameworkType == "qbcore" then
        local Player = Framework.Functions.GetPlayer(src)
        if Player then
            local armor = Player.PlayerData.metadata["armor"] or 0
            local health = Player.PlayerData.metadata["health"] or 100
            TriggerClientEvent('hud2:client:UpdateArmorAndHealth', src, armor, health)
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local ped = GetPlayerPed(src)
    local armor = GetPedArmour(ped)
    local health = GetEntityHealth(ped) - 100

    if frameworkType == "esx" then
        local xPlayer = Framework.GetPlayerFromId(src)
        if xPlayer then
            local identifier = xPlayer.identifier
            MySQL.update('UPDATE users SET armor = ?, health = ? WHERE identifier = ?', {
                armor,
                health,
                identifier
            })
        end
    elseif frameworkType == "qbcore" then
        local Player = Framework.Functions.GetPlayer(src)
        if Player then
            Player.Functions.SetMetaData("armor", armor)
            Player.Functions.SetMetaData("health", health)
        end
    end
end)
