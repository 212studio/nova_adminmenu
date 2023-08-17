-- Attento a quello che tocchi
-- Nova Scripts

local ESX = exports.es_extended:getSharedObject()
local inJail = false
local setJailCoords = false
local spectating = false
local idSpectate = 0
local nomiTesta = false


Citizen.CreateThread(function()
    while ESX.IsPlayerLoaded() == false do
        Citizen.Wait(100)
    end
    local jail = nil 
    ESX.TriggerServerCallback('ricky-admin:getInJail', function(jail1) 
        jail = jail1
    end)
    while jail == nil do
        Citizen.Wait(0)
    end
    inJail = jail
    if inJail then 
        setJailCoords = true
    end
end)

RegisterCommand(Config.CommandName, function(source, args, rawCommand)
    if SonoStaff() == false then return end
    OpenAdminMenu()
end)

if Config.Keybinds.adminmenu.enable then 
    RegisterKeyMapping(Config.CommandName, 'Admin Menu', 'keyboard', Config.Keybinds.adminmenu.key)
end

if Config.Keybinds.nomitesta.enable then 
    RegisterKeyMapping('-+nomitesta', 'Nomi Sopra la Testa', 'keyboard', Config.Keybinds.nomitesta.key)
    TriggerEvent('chat:removeSuggestion', '/-+nomitesta')
    RegisterCommand('-+nomitesta', function(source, args, rawCommand)
        if SonoStaff() == false then return end
        nomiTesta = not nomiTesta
        if nomiTesta then 
            ESX.ShowNotification(Config.Lang[Config.Language]["nomitesta_a"])
            fields = {
                {
                  name = Config.Lang[Config.Language]['nome_staff'],
                  value = GetPlayerName(PlayerId()),
                  inline = true
                },
                {
                  name = Config.Lang[Config.Language]["stato_nomitesta"],
                  value = Config.Lang[Config.Language]["attivo"],
                  inline = true
                },
              }
        else
            ESX.ShowNotification(Config.Lang[Config.Language]["nomitesta_b"])
            fields = {
                {
                  name = Config.Lang[Config.Language]['nome_staff'],
                  value = GetPlayerName(PlayerId()),
                  inline = true
                },
                {
                  name = Config.Lang[Config.Language]["stato_nomitesta"],
                  value = Config.Lang[Config.Language]["inattivo"],
                  inline = true
                },
              }
        end
    
        TriggerServerEvent('ricky-admin:webhook', Config.Lang[Config.Language]["nomitesta"], fields, "nomiplayer")
    end)
end

RegisterNUICallback('deletewarn', function(data)
    local id = data.id
    local index = data.index
    ESX.ShowNotification(Config.Lang[Config.Language]["delete_warn"])
    TriggerServerEvent('ricky-admin:deletewarn', id, index)
end)

SonoStaff = function()
    local staff1 = nil
   ESX.TriggerServerCallback('ricky-admin:sonoStaff', function(staff) 
        staff1 = staff
    end)
    while staff1 == nil do
        Citizen.Wait(0)
    end
    return staff1
end

postMessage = function(data)
    SendNUIMessage(data)
end

CreateThread(function()
    while true do
        ESX.TriggerServerCallback('ricky-admin:getPlayers', function(t)
            players = t
        end)
        postMessage({
            type = "UPDATE_PLAYERS",
            players = players
        })
        Wait(5000)
    end
end)

OpenAdminMenu = function()
    ESX.TriggerServerCallback('ricky-admin:getPlayers', function(t)
        ESX.TriggerServerCallback('ricky-admin:getData', function(data)
            if SonoStaff() == false then return end
            SetNuiFocus(true, true)
            players = t
            postMessage({
                type = "SET_RADIUS",
                radius = Config.ClearAreaRadius
            })
            postMessage({
                type = "SET_ADMIN_ONLINE",
                admin = data.adminOnline
            })
            postMessage({
                type = "SET_KICKS",
                kicks = data.kicks
            })
            postMessage({
                type = "SET_CONFIG",
                config = Config
            })
            postMessage({
                type = "SET_BAN",
                ban = data.bans
            })
            postMessage({
                type = "SET_INFO_STAFF",
                info = data.infoStaff
            })
            postMessage({
                type = "SET_JOBS",
                jobs = data.jobs
            })
            postMessage({
                type = "SET_ADMIN_GROUPS",
                groups = Config.AdminGroup
            })
            postMessage({
                type = "SET_ORARIO",
                orario = data.orario
            })
            postMessage({
                type = "SET_AZIONI",
                azioni = Config.Azioni
            })
            postMessage({
                type = "SET_AZIONI_PERSONALE",
                azioni = Config.AzioniPersonale
            })
            postMessage({
                type = "OPEN",
                players = players
            })
            postMessage({
                type = "SET_SERVER_LOGO",
                logo = Config.LogoServer
            })
        end)
    end)
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('skinmenu', function(data, cb)
    local id = data.id
    TriggerServerEvent('ricky-admin:skinmenu', id)
end)

local lastCoords = nil
local lastHeading = nil
RegisterNUICallback('spectate', function(data)
    idSpectate = tonumber(data.id)
    SetNuiFocus(false, false)
    lastCoords = GetEntityCoords(PlayerPedId())
    lastHeading = GetEntityHeading(PlayerPedId())
    spectating = true
    ESX.ShowHelpNotification(Config.Lang[Config.Language]['esci_spectate'])
    local fields = {
        {
          name = Config.Lang[Config.Language]['nome_staff'],
          value = GetPlayerName(PlayerId()),
          inline = true
        },
        {
          name = Config.Lang[Config.Language]["nome_player"],
          value = GetPlayerName(GetPlayerFromServerId(idSpectate)),
          inline = true
        },
      }
    TriggerServerEvent('ricky-admin:webhook', Config.Lang[Config.Language]["inizio_spectate"], fields, "spectate")
end)

RegisterNetEvent('ricky-admin:dm')
AddEventHandler('ricky-admin:dm', function(text)
    SendDMMessage(text)
end)

RegisterNUICallback('repairvehicle', function()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 then
        SetVehicleFixed(veh)
        SetVehicleDirtLevel(veh, 0.0)
        local fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["veicolo"],
              value = GetDisplayNameFromVehicleModel(GetEntityModel(veh)),
              inline = true
            },
          }

        TriggerServerEvent('ricky-admin:webhook', Config.Lang[Config.Language]["ripara_veicolo"], fields, "repairvehicle")
        ESX.ShowNotification(Config.Lang[Config.Language]["repair_vehicle2"])
    end
end)

RegisterNetEvent('ricky-admin:cleararea')
AddEventHandler('ricky-admin:cleararea', function(radius)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local vehicles = ESX.Game.GetVehiclesInArea(pos, tonumber(radius))
    for k,v in pairs(vehicles) do 
        ESX.Game.DeleteVehicle(v)
    end

    ClearAreaOfVehicles(pos.x, pos.y, pos.z, radius, false, false, false, false, false)
    ClearAreaOfPeds(pos.x, pos.y, pos.z, radius, 1)
    ClearAreaOfObjects(pos.x, pos.y, pos.z, radius, 1)
    ClearAreaOfCops(pos.x, pos.y, pos.z, radius, 1)
    ClearAreaOfProjectiles(pos.x, pos.y, pos.z, radius, 1)
    ClearAreaOfEverything(pos.x, pos.y, pos.z, radius, 1)


    local fields = {
        {
          name = Config.Lang[Config.Language]['nome_staff'],
          value = GetPlayerName(PlayerId()),
          inline = true
        }
      }

    TriggerServerEvent('ricky-admin:webhook', Config.Lang[Config.Language]["clear_area"], fields, "cleararea")
    ESX.ShowNotification(Config.Lang[Config.Language]["clear_area2"])
end)

RegisterNUICallback('clearped', function(data)
    local id = data.id
    TriggerServerEvent('ricky-admin:clearped', id)
    ESX.ShowNotification(Config.Lang[Config.Language]["clear_ped2"])
end)

RegisterNetEvent('ricky-admin:clearped')
AddEventHandler('ricky-admin:clearped', function()
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped)
    ClearPedBloodDamage(ped)
    ESX.ShowNotification(Config.Lang[Config.Language]["clear_ped"])
end)

Citizen.CreateThread(function()
  while true do
    if spectating then 
        Wait(0)
        if IsControlJustPressed(0, 38) then
            spectating = false
            postMessage({
                type = "RESUME"
            })
            SetNuiFocus(true, true)
            NetworkSetInSpectatorMode(false, PlayerPedId())
            DetachEntity(PlayerPedId(), true, true)
            SetEntityVisible(PlayerPedId(), true, 0)
            SetEntityCoords(PlayerPedId(), lastCoords)
            SetEntityHeading(PlayerPedId(), lastHeading)
            local fields = {
                {
                  name = Config.Lang[Config.Language]['nome_staff'],
                  value = GetPlayerName(PlayerId()),
                  inline = true
                },
                {
                  name = Config.Lang[Config.Language]["nome_player"],
                  value = GetPlayerName(GetPlayerFromServerId(idSpectate)),
                  inline = true
                },
              }
            TriggerServerEvent('ricky-admin:webhook', Config.Lang[Config.Language]["fine_spectate"], fields, "spectate")
        end
        ESX.TriggerServerCallback('ricky-admin:getCoordsPlayer', function(coords, coords2) 
            if not spectating then return end
            SetEntityVisible(PlayerPedId(), false, 0)
            AttachEntityToEntity(PlayerPedId(), GetPlayerPed(GetPlayerFromServerId(idSpectate)), 4103, 0.0, 0.0, 3.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
            SetEntityCoords(PlayerPedId(), coords2.x, coords2.y, coords2.z)
            NetworkSetInSpectatorMode(true, GetPlayerPed(GetPlayerFromServerId(idSpectate)))
        end, idSpectate)
    else
        Wait(1000)
    end
     
   end
end)

RegisterNUICallback('unjail', function(data, cb)
    local id = data.id
    TriggerServerEvent('ricky-admin:unjail', id)
end)

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityPhysicsHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end


local noclipEnabled = false

Citizen.CreateThread(function()
  while true do
    if noclipEnabled then 
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId(), false)
        local camCoords = direzione_cam()
        SetEntityVelocity(PlayerPedId(), 0.01, 0.01, 0.01)

        if IsControlPressed(0, 32) then
            playerCoords = playerCoords + (1.0 * camCoords)
        end

        if IsControlPressed(0, 269) then
            playerCoords = playerCoords - (1.0 * camCoords)
        end

        SetEntityCoordsNoOffset(PlayerPedId(), playerCoords, true, true, true)
    else
        Wait(1000)
    end
   end
end)

direzione_cam = function()
    local heading = GetGameplayCamRelativeHeading() + GetEntityPhysicsHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
    local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

    if len ~= 0 then
        coords = coords / len
    end
    return coords
end


RegisterNUICallback('heal', function(data, cb)
    local id = data.id
    TriggerServerEvent('ricky-admin:heal', id)
    ESX.ShowNotification(Config.Lang[Config.Language]['heal'])
end)

RegisterNUICallback('revive', function(data, cb)
    local id = data.id
    TriggerServerEvent('ricky-admin:revive', id)
    ESX.ShowNotification(Config.Lang[Config.Language]['revive'])
end)

RegisterCommand('noclip', function(source, args, rawCommand)
    if SonoStaff() == false then return end
    noclipEnabled = not noclipEnabled 
    local ped = PlayerPedId()
    if noclipEnabled then 
        ESX.ShowNotification(Config.Lang[Config.Language]['noclip_attivato'])
        ESX.ShowHelpNotification(Config.Lang[Config.Language]['exit_noclip'])
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetEntityCollision(ped, false, false)
        SetEntityVisible(ped, false, false)
        SetEveryoneIgnorePlayer(PlayerId(), true)
        SetPoliceIgnorePlayer(PlayerId(), true)
        local fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_noclip"],
              value = Config.Lang[Config.Language]["attivo"],
              inline = true
            },
          }
        TriggerServerEvent('ricky-admin:webhook', 'NoClip', fields, "noclip")
      else
        ESX.ShowNotification(Config.Lang[Config.Language]['noclip_disattivato'])
        FreezeEntityPosition(ped, false)
        SetEntityInvincible(ped, false)
        SetEntityCollision(ped, true, true)
        SetEntityVisible(ped, true, false)
        SetEveryoneIgnorePlayer(PlayerId(), false)
        SetPoliceIgnorePlayer(PlayerId(), false)
        local fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_noclip"],
              value = Config.Lang[Config.Language]["inattivo"],
              inline = true
            },
          }
        TriggerServerEvent('ricky-admin:webhook', Config.Lang[Config.Language]["noclip"], fields, "noclip")
      end
end)

if Config.Keybinds.noclip.enable then
    RegisterKeyMapping('noclip', 'Noclip', 'keyboard', Config.Keybinds.noclip.key)
end

RegisterNUICallback('noclip', function(data, cb)
    SetNuiFocus(false, false)
    ExecuteCommand('noclip')
end)

RegisterNUICallback('revocaban', function(data)
    local id = data.id
    TriggerServerEvent('ricky-admin:revocaban', GetPlayerServerId(PlayerId()), id)
    ESX.ShowNotification(Config.Lang[Config.Language]['revoca_ban'])
end)

RegisterNUICallback('kill', function(data, cb)
    local id = data.id
    TriggerServerEvent('ricky-admin:kill', id)
    ESX.ShowNotification(Config.Lang[Config.Language]['kill'])
end)

RegisterNUICallback('goto', function(data, cb)
    local id = data.id
    TriggerServerEvent('ricky-admin:goto', id)
end)

RegisterNUICallback('bring', function(data, cb)
    local id = data.id
    TriggerServerEvent('ricky-admin:bring', id)
end)

RegisterNUICallback('wipe', function(data, cb)
    local id = data.id
    TriggerServerEvent('ricky-admin:wipe', id)
    ESX.ShowNotification(Config.Lang[Config.Language]['wipe'])
end)

RegisterNUICallback('clearinv', function(data, cb)
    local id = data.id
    TriggerServerEvent('ricky-admin:clearInv', id)
    ESX.ShowNotification(Config.Lang[Config.Language]['clear_inv2'])
end)

RegisterNetEvent('ricky-admin:kill')
AddEventHandler('ricky-admin:kill', function()
  local ped = PlayerPedId()
  SetEntityHealth(ped, 0)
end)

RegisterNUICallback('action', function(data, cb)
    TriggerServerEvent('ricky-admin:action', data)
end)

RegisterNetEvent('ricky-admin:updatePlayers')
AddEventHandler('ricky-admin:updatePlayers', function()
    ESX.TriggerServerCallback('ricky-admin:getPlayers', function(players)
        ESX.TriggerServerCallback('ricky-admin:getData', function(data) 
            if SonoStaff() == false then return end
            postMessage({
                type = "UPDATE_PLAYERS",
                players = players
            })

            postMessage({
                type = "SET_BAN",
                ban = data.bans
            })

            postMessage({
                type = "SET_INFO_STAFF",
                info = data.infoStaff
            })

        end)
    end)
end)

RegisterNetEvent('ricky-admin:setped')
AddEventHandler('ricky-admin:setped', function(model)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
          Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
    end
end)

RegisterNetEvent('ricky-admin:resetped')
AddEventHandler('ricky-admin:resetped', function()
    local maschio = 'mp_m_freemode_01'
    local femmina = 'mp_f_reemode_01'
    TriggerEvent('skinchanger:getSkin', function(skin)
      if skin.sex == 0 then 
        RequestModel(maschio)
        while not HasModelLoaded(maschio) do
          Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), maschio)
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
          end)
      else
        RequestModel(femmina)
        while not HasModelLoaded(femmina) do
          Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), femmina)
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
          end)
      end
    end)
end)

RegisterNetEvent('ricky-admin:adminjail')
AddEventHandler('ricky-admin:adminjail', function()
    inJail = true
    setJailCoords = true
end)

Citizen.CreateThread(function()
  while true do
    if inJail then 
        Wait(0)
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, true)
        if setJailCoords then 
        SetEntityCoords(ped, Config.AdminJailCoords)
        end
        DisableAllControlActions(0)
    else
        Wait(1000)
    end
   end
end)



RegisterNetEvent('ricky-admin:unjail')
AddEventHandler('ricky-admin:unjail', function()
  local ped = PlayerPedId()
  setJailCoords = false
  inJail = false
  Wait(1000)
  FreezeEntityPosition(ped, false)
end)

RegisterNUICallback('freeze', function(data)
    local id = tonumber(data.id)
    TriggerServerEvent('ricky-admin:freeze', id)
end)

RegisterNUICallback('sfreeze', function(data)
    local id = tonumber(data.id)
    TriggerServerEvent('ricky-admin:sfreeze', id)
end)

RegisterNetEvent('ricky-admin:freeze')
AddEventHandler('ricky-admin:freeze', function()
    FreezeEntityPosition(PlayerPedId(), true)
end)

RegisterNetEvent('ricky-admin:sfreeze')
AddEventHandler('ricky-admin:sfreeze', function()
    FreezeEntityPosition(PlayerPedId(), false)
end)

local invisible = false
RegisterNUICallback('invisibilita', function()
    invisible = not invisible
    SetNuiFocus(false, false)
    if not invisible then
        ESX.ShowNotification(Config.Lang[Config.Language]['invisibilita_b'])
        SetEntityVisible(PlayerPedId(), true, 0)
        fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_invisible"],
              value = Config.Lang[Config.Language]["inattivo"],
              inline = true
            },
          }
    else
        ESX.ShowNotification(Config.Lang[Config.Language]['invisibilita_a'])
        SetEntityVisible(PlayerPedId(), false, 0)
        fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_invisible"],
              value = Config.Lang[Config.Language]["attivo"],
              inline = true
            },
          }
    end
    TriggerServerEvent('ricky-admin:webhook', Config.Lang[Config.Language]["invisibilita"], fields, "invisibilita")
end)

local godmode = false
RegisterNUICallback('godmode', function()
    godmode = not godmode
    if godmode then 
        ESX.ShowNotification(Config.Lang[Config.Language]['godmode_a'])
         fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_godmode"],
              value = Config.Lang[Config.Language]["attivo"],
              inline = true
            },
          }
    else
        ESX.ShowNotification(Config.Lang[Config.Language]['godmode_b'])
         fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_godmode"],
              value = Config.Lang[Config.Language]["inattivo"],
              inline = true
            },
          }
    end

    TriggerServerEvent('ricky-admin:webhook', "Godmode", fields, "godmode")
    SetNuiFocus(false, false)
end)

RegisterNUICallback('reviveall', function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('ricky-admin:reviveall')
    ESX.ShowNotification(Config.Lang[Config.Language]['revive_all'])
end)

RegisterNetEvent('ricky-admin:announce')
AddEventHandler('ricky-admin:announce', function(text)
  Announce(text)
end)

Citizen.CreateThread(function()
    while true do
      if godmode then 
          Wait(0)
          SetEntityInvincible(PlayerPedId(), true)
      else
          Wait(1000)
            SetEntityInvincible(PlayerPedId(), false)
      end
     end
  end)

-- Citizen.CreateThread(function()
--   while true do
--     if invisible or noclipEnabled then 
--         Wait(0)
--         SetEntityVisible(PlayerPedId(), false, 0)
--     else
--         Wait(1000)
--         SetEntityVisible(PlayerPedId(), true, 0)
--     end
--    end
-- end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    TriggerServerEvent('ricky-admin:addvariable', 'freeze', IsEntityPositionFrozen(PlayerPedId()))
    ESX.TriggerServerCallback('ricky-admin:getOrario', function(orario)
        postMessage({
            type = "SET_ORARIO",
            orario = orario
        })
    end)
   end
end)

DrawText3D = function(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterNUICallback('nomiplayer', function()
    nomiTesta = not nomiTesta
    if nomiTesta then 
        ESX.ShowNotification(Config.Lang[Config.Language]["nomitesta_a"])
        fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_nomitesta"],
              value = Config.Lang[Config.Language]["attivo"],
              inline = true
            },
          }
    else
        ESX.ShowNotification(Config.Lang[Config.Language]["nomitesta_b"])
        fields = {
            {
              name = Config.Lang[Config.Language]['nome_staff'],
              value = GetPlayerName(PlayerId()),
              inline = true
            },
            {
              name = Config.Lang[Config.Language]["stato_nomitesta"],
              value = Config.Lang[Config.Language]["inattivo"],
              inline = true
            },
          }
    end

    TriggerServerEvent('ricky-admin:webhook', Config.Lang[Config.Language]["nomitesta"], fields, "nomiplayer")
end)

Citizen.CreateThread(function()
  while true do
    if nomiTesta then 
        Wait(0)
        for k,v in pairs(GetActivePlayers()) do 
            if NetworkIsPlayerActive(v) then
                local ped = GetPlayerPed(v)
                local coords = GetEntityCoords(ped)
                if IsPedInAnyVehicle(ped, false) then
                    DrawText3D(coords.x, coords.y, coords.z + 1.5, GetPlayerName(v).." | Vita: "..GetEntityHealth(ped).." | ID: "..GetPlayerServerId(v))
                else
                    DrawText3D(coords.x, coords.y, coords.z + 1.0, GetPlayerName(v).." | Vita: "..GetEntityHealth(ped).." | ID: "..GetPlayerServerId(v))
                end
            end
         end
    else
        Wait(1000)
    end
   end
end)
