local QBCore = nil
local ESX = nil
local ox_inventory = exports.ox_inventory

if Config.UseQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.UseESX then
    ESX = exports["es_extended"]:getSharedObject()
end

local function notify(source, message)
    TriggerClientEvent('ox_lib:notify', source, { description = message, type = 'error' })
end

RegisterServerEvent('robbery:completeRobbery')
AddEventHandler('robbery:completeRobbery', function(targetPlayerId)
    local xPlayer, targetPlayer

    if Config.UseQBCore then
        xPlayer = QBCore.Functions.GetPlayer(source)
        targetPlayer = QBCore.Functions.GetPlayer(targetPlayerId)
    elseif Config.UseESX then
        xPlayer = ESX.GetPlayerFromId(source)
        targetPlayer = ESX.GetPlayerFromId(targetPlayerId)
    end

    if targetPlayer then
        exports.ox_inventory:openInventory('player', targetPlayer.source)
    else
        notify(source, "The target player does not exist.")
    end
end)

RegisterServerEvent('robbery:completeLooting')
AddEventHandler('robbery:completeLooting', function(targetPlayerId)
    local xPlayer, targetPlayer

    if Config.UseQBCore then
        xPlayer = QBCore.Functions.GetPlayer(source)
        targetPlayer = QBCore.Functions.GetPlayer(targetPlayerId)
    elseif Config.UseESX then
        xPlayer = ESX.GetPlayerFromId(source)
        targetPlayer = ESX.GetPlayerFromId(targetPlayerId)
    end

    if targetPlayer then
        if IsEntityDead(GetPlayerPed(targetPlayer.source)) then
            exports.ox_inventory:openInventory('player', targetPlayer.source)
        else
            notify(source, "The target player is not dead yet and cannot pick up the body.")
        end
    else
        notify(source, "The target player does not exist.")
    end
end)