local Core = exports['core']:GetCoreObject()
local isOpen = false
local active = false
local currentweapons = {}
local prop = {}

Citizen.CreateThread(function () 
    local book = GetHashKey("mp001_s_mp_catalogue01x")
    local pcoords = GetEntityCoords(PlayerPedId())
    RequestModel(book)
    while not HasModelLoaded(book) do
        Citizen.Wait(0)
    end
    
    for i = 1,#Config.StoreLocations do
        exports['core']:createPrompt('gun_catalogue_'..i, vector3(Config.StoreLocations[i].coords.x, Config.StoreLocations[i].coords.y, Config.StoreLocations[i].coords.z), Core.Shared.Keybinds['J'], 'Open Gun Catalogue', {
            type = 'client',
            action = function()
                if not active then                    
                    active = true
                    OpenUI()
                    FreezeEntityPosition(PlayerPedId(), true)
                end
            end,
        })
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, Config.StoreLocations[i].coords.x, Config.StoreLocations[i].coords.y, Config.StoreLocations[i].coords.z)
        SetBlipSprite(blip, -145868367, 1)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, Config.StoreLocations[i].LocationLabel.." Gun store")
    end

    for i = 1, #Config.StoreLocations do
        prop[i] = CreateObjectNoOffset(book, Config.StoreLocations[i].coords.x, Config.StoreLocations[i].coords.y, Config.StoreLocations[i].coords.z, false, false, false, false)
        SetEntityHeading(prop[i], Config.StoreLocations[i].coords.w)
        FreezeEntityPosition(prop[i], true)
    end
end)

function startup()
    isOpen = false
    SetNuiFocus(isOpen, isOpen)
    SendNUIMessage({
        type = "OpenBookGui",
        value = false
    })
end

function OpenUI()
    isOpen = true
    SetNuiFocus(isOpen,isOpen)
    SendNUIMessage({
        type = "OpenBookGui",
        value = true,
    })
end

function CloseUI()
    isOpen = false
    SetNuiFocus(isOpen,isOpen)
    active = false
    FreezeEntityPosition(PlayerPedId(), false)
    SendNUIMessage({
        type = "OpenBookGui",
        value = false,
    })
end

function Purchase(data)
    Wait(200)
    TriggerServerEvent('gunCatalogue:Purchase',data)
end

RegisterCommand('closeui', function(...) CloseUI() end)

RegisterNUICallback('purchaseweapon', function(data)
    Wait(200)
    TriggerServerEvent('gunCatalogue:Purchase', data)
end)
RegisterNUICallback('close', CloseUI)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        FreezeEntityPosition(PlayerPedId(), false)
        for i = 1,#Config.StoreLocations do
            exports['core']:deletePrompt('gun_catalogue_'..i)
        end
        for i=1,#prop do
            DeleteObject(prop[i])
        end
    end
end)