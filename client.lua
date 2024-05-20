local QBCore = nil
local ESX = nil

if Config.UseQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.UseESX then
    ESX = exports["es_extended"]:getSharedObject()
end

local function isPlayerDead(playerPed)
    return IsEntityDead(playerPed)
end

local function startRobberyAnimation()
    RequestAnimDict("random@mugging3")
    while not HasAnimDictLoaded("random@mugging3") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "random@mugging3", "handsup_standing_base", 8.0, -8.0, -1, 49, 0, false, false, false)
end

local function startLootingAnimation()
    RequestAnimDict("amb@medic@standing@tendtodead@base")
    while not HasAnimDictLoaded("amb@medic@standing@tendtodead@base") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@medic@standing@tendtodead@base", "base", 8.0, -8.0, -1, 49, 0, false, false, false)
end

local function notify(message)
    exports.ox_lib:notify({ description = message, type = 'error' })
end

local function showProgress(label, duration)
    exports.ox_lib:progress({
        label = label,
        duration = duration,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = { car = true, combat = true, mouse = false }
    })
end

local function getClosestPlayer()
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)

    for index, value in ipairs(players) do
        local target = GetPlayerPed(value)
        if target ~= ply then
            local targetCoords = GetEntityCoords(target, 0)
            local distance = #(plyCoords - targetCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

local function isPlayerArmed(playerPed)
    return GetCurrentPedWeapon(playerPed, true)
end

if Config.UseCommands then
    RegisterCommand('rob', function()
        local playerPed = PlayerPedId()
        local closestPlayer, closestDistance = getClosestPlayer()

        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            local targetPed = GetPlayerPed(closestPlayer)
            if isPlayerArmed(playerPed) then
                if isPlayerDead(targetPed) then
                    notify("This player is dead, please pick up the body.")
                else
                    showProgress("Robbery in progress...", 5000)
                    startRobberyAnimation()
                    Citizen.Wait(5000)
                    TriggerServerEvent('robbery:completeRobbery', GetPlayerServerId(closestPlayer))
                end
            else
                notify("You need a weapon to pull off the heist.")
            end
        else
            notify("There are no players nearby to loot.")
        end
    end, false)

    RegisterCommand('loot', function()
        local playerPed = PlayerPedId()
        local closestPlayer, closestDistance = getClosestPlayer()

        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            local targetPed = GetPlayerPed(closestPlayer)
            if isPlayerDead(targetPed) then
                showProgress("Loot the bodies...", 5000)
                startLootingAnimation()
                Citizen.Wait(5000)
                TriggerServerEvent('robbery:completeLooting', GetPlayerServerId(closestPlayer))
            else
                notify("This player is not dead yet.")
            end
        else
            notify("There are no players nearby to pick up the body.")
        end
    end, false)
end

if Config.UseQbTarget then
    exports['qb-target']:AddGlobalPlayer({
        options = {
            {
                label = "Rob the player",
                icon = "fas fa-gun",
                action = function(entity)
                    local playerPed = PlayerPedId()
                    local closestPlayer = entity

                    if closestPlayer then
                        local targetPed = GetPlayerPed(GetPlayerFromServerId(closestPlayer))
                        if isPlayerArmed(playerPed) then
                            if isPlayerDead(targetPed) then
                                notify("This player is dead, please pick up the body.")
                            else
                                showProgress("Robbery in progress...", 5000)
                                startRobberyAnimation()
                                Citizen.Wait(5000)
                                TriggerServerEvent('robbery:completeRobbery', closestPlayer)
                            end
                        else
                            notify("You need a weapon to pull off the heist.")
                        end
                    else
                        notify("There are no players nearby to loot.")
                    end
                end
            },
            {
                label = "Loot the bodies",
                icon = "fas fa-hand-holding-medical",
                action = function(entity)
                    local playerPed = PlayerPedId()
                    local closestPlayer = entity

                    if closestPlayer then
                        local targetPed = GetPlayerPed(GetPlayerFromServerId(closestPlayer))
                        if isPlayerDead(targetPed) then
                            showProgress("Loot the bodies....", 5000)
                            startLootingAnimation()
                            Citizen.Wait(5000)
                            TriggerServerEvent('robbery:completeLooting', closestPlayer)
                        else
                            notify("This player is not dead yet.")
                        end
                    else
                        notify("There are no players nearby to pick up the body.")
                    end
                end
            }
        },
        distance = 3.0
    })
end

if Config.UseOxTarget then
    exports['ox_target']:AddGlobalPlayer({
        options = {
            {
                name = 'rob',
                label = 'Rob the player',
                icon = 'fas fa-gun',
                action = function(entity)
                    local playerPed = PlayerPedId()
                    local closestPlayer = entity

                    if closestPlayer then
                        local targetPed = GetPlayerPed(GetPlayerFromServerId(closestPlayer))
                        if isPlayerArmed(playerPed) then
                            if isPlayerDead(targetPed) then
                                notify("This player is dead, please pick up the body.")
                            else
                                showProgress("Robbery in progress...", 5000)
                                startRobberyAnimation()
                                Citizen.Wait(5000)
                                TriggerServerEvent('robbery:completeRobbery', closestPlayer)
                            end
                        else
                            notify("You need a weapon to pull off the heist.")
                        end
                    else
                        notify("There are no players nearby to loot.")
                    end
                end
            },
            {
                name = 'loot',
                label = 'Loot the bodies',
                icon = 'fas fa-hand-holding-medical',
                action = function(entity)
                    local playerPed = PlayerPedId()
                    local closestPlayer = entity

                    if closestPlayer then
                        local targetPed = GetPlayerPed(GetPlayerFromServerId(closestPlayer))
                        if isPlayerDead(targetPed) then
                            showProgress("Searching for corpses...", 5000)
                            startLootingAnimation()
                            Citizen.Wait(5000)
                            TriggerServerEvent('robbery:completeLooting', closestPlayer)
                        else
                            notify("This player is not dead yet.")
                        end
                    else
                        notify("There are no players nearby to pick up the body.")
                    end
                end
            }
        },
        distance = 3.0
    })
end