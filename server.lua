-- Attento a quello che tocchi
-- Nova Scripts

local ESX = exports.es_extended:getSharedObject()

local client_var = {}

RegisterServerEvent('ricky-admin:addvariable')
AddEventHandler('ricky-admin:addvariable', function(type, value)
  client_var[source] = {}
  client_var[source][type] = value
end)

GetLicense = function(source, type)
    local steamid  = false
    local license  = false
    local discord  = false
    local xbl      = false
    local liveid   = false
    local ip       = false

  for k,v in pairs(GetPlayerIdentifiers(source))do
        
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        steamid = string.gsub(v, "steam:", "")
      elseif string.sub(v, 1, string.len("license:")) == "license:" then
        license = string.gsub(v, "license:", "")
      elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
        xbl  = string.gsub(v, "xbl:", "")
      elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
        ip = string.gsub(v, "ip:", "")
      elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
        discord = string.gsub(v, "discord:", "")
      elseif string.sub(v, 1, string.len("live:")) == "live:" then
        liveid = string.gsub(v, "live:", "")
      end
    
  end

    if type == "steam" then
        return steamid
    elseif type == "license" then
        return license
    elseif type == "discord" then
        return discord
    elseif type == "xbl" then
        return xbl
    elseif type == "liveid" then
        return liveid
    elseif type == "ip" then
        return ip
    end
    
end

function DiscordRequest(method, endpoint, jsondata, reason)
  local data = nil
  PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
  data = {data=resultData, code=errorCode, headers=resultHeaders}
  end, method, #jsondata > 0 and jsondata or "", {["Content-Type"] = "application/json", ["Authorization"] = "Bot "..ConfigServer.Token, ['X-Audit-Log-Reason'] = reason})

  while data == nil do
      Citizen.Wait(0)
  end

  return data
end

GetPlayerAvatar = function(id)
  local idDiscord = tonumber(GetLicense(id, "discord"))
  local url = nil
  PerformHttpRequest("https://discord.com/api/v8/users/"..idDiscord, function (errorCode, resultData, resultHeaders)
  if errorCode == 200 then
    local userData = json.decode(resultData)
    local username = userData.display_name
    local avatar = userData.avatar

    url = "https://cdn.discordapp.com/avatars/" .. userData.id .. "/" .. avatar .. ".png"
else
    print("Errore nella richiesta HTTP: "..errorCode)
    url = ""
end
end, "GET", "", {Authorization = "Bot "..ConfigServer.Token})

while url == nil do Wait(0) end 
return url
end

GetWarn = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  CheckSql(xPlayer.source)
  local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_admin WHERE identifier = @identifier", {
    ['@identifier'] = identifier,
  })
  if result[1] == nil then 
    return {}
  end
  if result[1].warn == nil then
    return {}
  else
    return json.decode(result[1].warn)
  end
end

GetKick = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  CheckSql(xPlayer.source)
  local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_admin WHERE identifier = @identifier", {
    ['@identifier'] = identifier,
  })
  if result[1].kick == nil then
    return {}
  else
    return json.decode(result[1].kick)
  end
end

GetBan = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  CheckSql(xPlayer.source)
  local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_admin WHERE identifier = @identifier", {
    ['@identifier'] = identifier,
  })
  if result[1].ban == nil then
    return {}
  else
    return json.decode(result[1].ban)
  end
end

GetJail = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  CheckSql(xPlayer.source)
  local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_admin WHERE identifier = @identifier", {
    ['@identifier'] = identifier,
  })
  if result[1].jail == nil then
    return {}
  else
    return json.decode(result[1].jail)
  end
end

local function getBans()
  local ban = LoadResourceFile(GetCurrentResourceName(), 'ban.json')
  if ban == nil then
    return {}
  end

  local ban2 = json.decode(ban)

  return ban2
end

getPlayers = function()
    local xPlayers = ESX.GetExtendedPlayers() 
    local players = {}
    for k, xPlayer in pairs(xPlayers) do 
      local rankLabel = Config.AdminGroup[xPlayer.getGroup()]
      if rankLabel == nil then 
        rankLabel = Config.Lang[Config.Language]['utente']
      else
        rankLabel = rankLabel.label
      end

      local freezed = false 
      if client_var[xPlayer.source] ~= nil then
        freezed = client_var[xPlayer.source].freeze 
      end
        table.insert(players, {
            name = GetPlayerName(xPlayer.source),
            id = xPlayer.source,
            staff = SonoStaff(xPlayer),
            job = xPlayer.job, 
            rankLabel = rankLabel,
            freezed = freezed,
            license = {
                discord = GetLicense(xPlayer.source, "discord") or "N/A",
                steam = GetLicense(xPlayer.source, "steam") or "N/A",
                license = GetLicense(xPlayer.source, "license") or "N/A",
            },
            warn = GetWarn(xPlayer),
            kick = GetKick(xPlayer),
            avatar = GetPlayerAvatar(xPlayer.source),
            ban = GetBan(xPlayer),
            jail = GetJail(xPlayer),
            inJail = InJail(xPlayer.source),
        })
    end
    return players
end

GetStaffBan = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  CheckSql(xPlayer.source)
  local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_admin")
  local bans = {}
  for i=1, #result, 1 do 
    local ban = json.decode(result[i].ban)
    if ban ~= nil then 
      for a=1, #ban, 1 do 
        if ban[a].staff.identifier == identifier then 
          table.insert(bans, ban[a])
        end
      end
    end
  end
  return bans
end

GetStaffKick = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  CheckSql(xPlayer.source)
  local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_admin")
  local kicks = {}
  for i=1, #result, 1 do 
    local kick = json.decode(result[i].kick)
    if kick ~= nil then 
      for a=1, #kick, 1 do 
        if kick[a].staff.identifier == identifier then 
          table.insert(kicks, kick[a])
        end
      end
    end
  end
  return kicks
end

GetStaffJail = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  CheckSql(xPlayer.source)
  local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_admin")
  local jails = {}
  for i=1, #result, 1 do 
    local jail = json.decode(result[i].jail)
    if jail ~= nil then 
      for a=1, #jail, 1 do 
        if jail[a].staff.identifier == identifier then 
          table.insert(jails, jail[a])
        end
      end
    end
  end
  return jails
end

GetStaffWarn = function(xPlayer)
  local identifier = GetLicense(xPlayer.source, "license")
  CheckSql(xPlayer.source)
  local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_admin")
  local warns = {}
  for i=1, #result, 1 do 
    local warn = json.decode(result[i].warn)
    if warn ~= nil then 
      for a=1, #warn, 1 do 
        if warn[a].staff.identifier == identifier then 
          table.insert(warns, warn[a])
        end
      end
    end
  end
  return warns
end

local function getJobs()
  local jobs = {}
  local esxJobs = ESX.GetJobs()
  for k, v in pairs(esxJobs) do
    table.insert(jobs, {
      label = v.label,
      value = v.name,
    })
  end

  return jobs
end


local function getInfoStaff(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  local rankLabel = Config.AdminGroup[xPlayer.getGroup()]
  if rankLabel == nil then
    rankLabel = Config.Lang[Config.Language]['utente']
  else
    rankLabel = rankLabel.label
  end
  local info = {
    name = GetPlayerName(xPlayer.source),
    id = xPlayer.source,
    staff = SonoStaff(xPlayer),
    job = xPlayer.getJob(),
    rank = getRank(xPlayer.source),
    rankLabel = rankLabel,
    avatar = GetPlayerAvatar(xPlayer.source),
    ban = GetStaffBan(xPlayer),
    kick = GetStaffKick(xPlayer),
    jail = GetStaffJail(xPlayer),
    warn = GetStaffWarn(xPlayer),
    license = {
      discord = GetLicense(xPlayer.source, "discord") or "N/A",
      steam = GetLicense(xPlayer.source, "steam") or "N/A",
      license = GetLicense(xPlayer.source, "license") or "N/A",
    },
  }
  return info
end

local function getBans()
  local ban = LoadResourceFile(GetCurrentResourceName(), 'ban.json')
  if ban == nil then
    return {}
  end

  local ban2 = json.decode(ban)

  return ban2
end

local function getAdminOnline()
  local xPlayers = ESX.GetExtendedPlayers()
  local adminOnline = 0

  for _, xPlayer in pairs(xPlayers) do
    for a, b in pairs(Config.AdminGroup) do
      if xPlayer.getGroup() == a then
        adminOnline = adminOnline + 1
      end
    end
  end

  return adminOnline
end

local function getKicks()
  local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_admin")
  local counterKicks = 0
  for i = 1, #result, 1 do
    local kick = json.decode(result[i].kick)
    if kick ~= nil then
      for a = 1, #kick, 1 do
        counterKicks = counterKicks + 1
      end
    end
  end

  return counterKicks
end

getPlayers = function()
  local xPlayers = ESX.GetExtendedPlayers() 
  local players = {}
  for k, xPlayer in pairs(xPlayers) do 
    local rankLabel = Config.AdminGroup[xPlayer.getGroup()]
    if rankLabel == nil then 
      rankLabel = Config.Lang[Config.Language]['utente']
    else
      rankLabel = rankLabel.label
    end

    local freezed = false 
    if client_var[xPlayer.source] ~= nil then
      freezed = client_var[xPlayer.source].freeze 
    end
      table.insert(players, {
          name = GetPlayerName(xPlayer.source),
          id = xPlayer.source,
          staff = SonoStaff(xPlayer),
          job = xPlayer.job, 
          rankLabel = rankLabel,
          freezed = freezed,
          license = {
              discord = GetLicense(xPlayer.source, "discord") or "N/A",
              steam = GetLicense(xPlayer.source, "steam") or "N/A",
              license = GetLicense(xPlayer.source, "license") or "N/A",
          },
          warn = GetWarn(xPlayer),
          kick = GetKick(xPlayer),
          avatar = GetPlayerAvatar(xPlayer.source),
          ban = GetBan(xPlayer),
          jail = GetJail(xPlayer),
          inJail = InJail(xPlayer.source),
      })
  end
  return players
end

ESX.RegisterServerCallback('ricky-admin:getPlayers', function(source, cb)
  cb(getPlayers())
end)

ESX.RegisterServerCallback('ricky-admin:getData', function(source, cb)
  local data = {}

  data.jobs = getJobs()
  data.infoStaff = getInfoStaff(source)
  data.orario = os.date("%H:%M")
  data.bans = getBans()
  data.adminOnline = getAdminOnline()
  data.kicks = getKicks()


  cb(data)
end)

ESX.RegisterServerCallback('ricky-admin:getInfoStaff', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local rankLabel = Config.AdminGroup[xPlayer.getGroup()]
  if rankLabel == nil then 
    rankLabel = Config.Lang[Config.Language]['utente']
  else
    rankLabel = rankLabel.label
  end
  local info = {
    name = GetPlayerName(xPlayer.source),
    id = xPlayer.source,
    staff = SonoStaff(xPlayer),
    job = xPlayer.getJob(),
    rank = getRank(xPlayer.source),
    rankLabel = rankLabel,
    avatar = GetPlayerAvatar(xPlayer.source),
    ban = GetStaffBan(xPlayer),
    kick = GetStaffKick(xPlayer),
    jail = GetStaffJail(xPlayer),
    warn = GetStaffWarn(xPlayer),
    license = {
        discord = GetLicense(xPlayer.source, "discord") or "N/A",
        steam = GetLicense(xPlayer.source, "steam") or "N/A",
        license = GetLicense(xPlayer.source, "license") or "N/A",
    },
  }
  cb(info)
end)

getRank = function(source)
  local group = ESX.GetPlayerFromId(source).getGroup()
  for k,v in pairs(Config.AdminGroup) do 
    if group == k then 
      return v.rank
    end
  end
end

ESX.RegisterServerCallback('ricky-admin:sonoStaff', function(source, cb)
  cb(SonoStaff(ESX.GetPlayerFromId(source)))
end)


CheckSql = function(id)
  local xPlayer = ESX.GetPlayerFromId(id)
  if xPlayer == nil then return end

  local result =  MySQL.Sync.fetchAll("SELECT * FROM ricky_admin WHERE identifier = @identifier", {
        ['@identifier'] = GetLicense(xPlayer.source, "license"),
  })

  if result[1] == nil then 
    MySQL.Async.execute("INSERT INTO ricky_admin (identifier) VALUES (@identifier)", {
      ['@identifier'] = GetLicense(xPlayer.source, "license"),
    })
    Wait(1000)
  end
end

InJail = function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer == nil then return end

  CheckSql(xPlayer.source)

  local result =  MySQL.Sync.fetchAll("SELECT * FROM ricky_admin WHERE identifier = @identifier", {
        ['@identifier'] = GetLicense(xPlayer.source, "license")
  })

  if result[1].inJail == nil or result[1].inJail == 0 then 
    return false
  else
    return true
  end
end

RegisterServerEvent('ricky-admin:action')
AddEventHandler('ricky-admin:action', function(data)
  local staff = ESX.GetPlayerFromId(source)
  local target = ESX.GetPlayerFromId(data.id)
  local value1 =  data.value1
  local value2 =  data.value2

  if data.action == 'warn' then 
    local reason = value1
    if target then 
      CheckSql(target.source)
      local warn = GetWarn(target)

      table.insert(warn, {
        reason = reason,
        name = GetPlayerName(target.source),
        staff = {
          name = GetPlayerName(staff.source),
          identifier = GetLicense(staff.source, "license")
        },
        date = os.date("%d/%m/%Y %H:%M:%S")
      })

      MySQL.Async.execute("UPDATE ricky_admin SET warn = @warn WHERE identifier = @identifier", {
        ['@warn'] = json.encode(warn),
        ['@identifier'] = GetLicense(target.source, "license"),
      })
      local fields = {
        {
          name = Config.Lang[Config.Language]['nome_staff'],
          value = GetPlayerName(staff.source),
          inline = true
        },
        {
          name = Config.Lang[Config.Language]["nome_player"],
          value = GetPlayerName(target.source),
          inline = true
        },
        {
          name = Config.Lang[Config.Language]["motivo"],
          value = reason,
          inline = true
        },
      }
      sendWebhook("WARN", fields, ConfigServer.Webhook.warn)
    end
  elseif data.action == 'kick' then
    local reason = value1
    if target then 
      CheckSql(target.source)

      local kick = GetKick(target)

      table.insert(kick, {
        reason = reason,
        name = GetPlayerName(target.source),
        staff = {
          name = GetPlayerName(staff.source),
          identifier = GetLicense(staff.source, "license")
        },
        date = os.date("%d/%m/%Y %H:%M:%S")
      })

      MySQL.Async.execute("UPDATE ricky_admin SET kick = @kick WHERE identifier = @identifier", {
        ['@kick'] = json.encode(kick),
        ['@identifier'] = GetLicense(target.source, "license"),
      })

      DropPlayer(target.source, reason)
      local fields = {
        {
          name = Config.Lang[Config.Language]['nome_staff'],
          value = GetPlayerName(staff.source),
          inline = true
        },
        {
          name = Config.Lang[Config.Language]["nome_player"],
          value = GetPlayerName(target.source),
          inline = true
        },
        {
          name = Config.Lang[Config.Language]["motivo"],
          value = reason,
          inline = true
        },
      }
      sendWebhook("KICK", fields, ConfigServer.Webhook.kick)
    end
  elseif data.action == 'ban' then
    local time = value1
    local reason = value2
    local futuroBanId = math.random(1000, 99999)
   time = time + os.time()
   local myBan = GetBan(target)



   table.insert(myBan, {
    reason = reason,
    name = GetPlayerName(target.source),
    staff = {
      name = GetPlayerName(staff.source),
      identifier = GetLicense(staff.source, "license"),
    },
    scadenzaLabel = os.date("%d/%m/%Y %H:%M:%S", time),
    scadenza = time,
    idBan = futuroBanId,
    date = os.date("%d/%m/%Y %H:%M:%S")
  })

  MySQL.Async.execute("UPDATE ricky_admin SET ban = @ban WHERE identifier = @identifier", {
    ['@ban'] = json.encode(myBan),
    ['@identifier'] = GetLicense(target.source, "license"),
  })





   local ban = LoadResourceFile(GetCurrentResourceName(), 'ban.json')
   if ban == nil then 
    return 
   end

    local ban = json.decode(ban)

    table.insert(ban, {
      identifier = target.identifier,
      name = GetPlayerName(target.source),
      time = time,
      reason = reason,
      labelScadenza = os.date("%d/%m/%Y %H:%M:%S", time),
      time = time,
      staff = {
        name = GetPlayerName(staff.source),
        identifier = GetLicense(staff.source, "license"),
      },
      idBan = futuroBanId,
      dataBan = os.date("%d/%m/%Y %H:%M:%S"),
    })

    local discord = GetLicense(target.source, "discord")
    local steam = GetLicense(target.source, "steam")
    local license = GetLicense(target.source, "license")
    local xbl = GetLicense(target.source, "xbl")
    local liveid = GetLicense(target.source, "liveid")
    local ip = GetLicense(target.source, "ip")
    if discord  then
      ban[#ban].discord = discord
    end
    if steam  then
      ban[#ban].steam = steam
    end
    if license  then
      ban[#ban].license = license
    end
    if xbl  then
      ban[#ban].xbl = xbl
    end
    if liveid  then
      ban[#ban].liveid = liveid
    end
    if ip  then
      ban[#ban].ip = ip
    end

    

    SaveResourceFile(GetCurrentResourceName(), 'ban.json', json.encode(ban, {indent = true}), -1)
    local fields = {
      {
        name = Config.Lang[Config.Language]['nome_staff'],
        value = GetPlayerName(staff.source),
        inline = true
      },
      {
        name = Config.Lang[Config.Language]["nome_player"],
        value = GetPlayerName(target.source),
        inline = true
      },
      {
        name = Config.Lang[Config.Language]["motivo"],
        value = reason,
        inline = true
      },
      {
        name = "Scadenza",
        value = os.date('%d/%m/%Y %H:%M:%S', time),
        inline = true
      },
    }
    sendWebhook("BAN", fields, ConfigServer.Webhook.ban)
    DropPlayer(target.source, 'Sei stato bannato dal server per: '..reason..' - Scadenza: '..os.date('%d/%m/%Y %H:%M:%S', time))
  elseif data.action == 'giveitem' then 
    local item = value1
    local count = value2
    if target then 
      target.addInventoryItem(item, count)
      local fields = {
        {
          name = Config.Lang[Config.Language]['nome_staff'],
          value = GetPlayerName(staff.source),
          inline = true
        },
        {
          name = Config.Lang[Config.Language]["nome_player"],
          value = GetPlayerName(target.source),
          inline = true
        },
        {
          name = "Oggetto",
          value = item,
          inline = true
        },
        {
          name = "Quantità",
          value = count,
          inline = true
        },
      }
      sendWebhook("GIVE ITEM", fields, ConfigServer.Webhook.giveitem)
    end
    
  elseif data.action == 'givemoney' then
    local account = value1
    local count = value2
    if target then 
      target.addAccountMoney(account, tonumber(count))
      local fields = {
        {
          name = Config.Lang[Config.Language]['nome_staff'],
          value = GetPlayerName(staff.source),
          inline = true
        },
        {
          name = Config.Lang[Config.Language]["nome_player"],
          value = GetPlayerName(target.source),
          inline = true
        },
        {
          name = "Account",
          value = account,
          inline = true
        },
        {
          name = "Quantità",
          value = count,
          inline = true
        },
      }
      sendWebhook("GIVE MONEY", fields, ConfigServer.Webhook.givemoney)
    end
  elseif data.action == 'setjob' then
    local job = value1
    local grade = value2
    if target then 
      target.setJob(job, grade)
      local fields = {
        {
          name = Config.Lang[Config.Language]['nome_staff'],
          value = GetPlayerName(staff.source),
          inline = true
        },
        {
          name = Config.Lang[Config.Language]["nome_player"],
          value = GetPlayerName(target.source),
          inline = true
        },
        {
          name = "Lavoro",
          value = job,
          inline = true
        },
        {
          name = "Grado",
          value = grade,
          inline = true
        },
      }
      sendWebhook("SET JOB", fields, ConfigServer.Webhook.setjob)
    end
  elseif data.action == 'adminjail' then
    local reason = value1

    print(target)
    
    if target then 

      MySQL.Sync.execute("UPDATE ricky_admin SET jailCoords = @jailCoords WHERE identifier = @identifier", {
        ['@identifier'] = GetLicense(target.source, "license"),
        ['@jailCoords'] = json.encode(target.getCoords(true))
    })

      target.setCoords(Config.AdminJailCoords)
      local myJail = GetJail(target)

      table.insert(myJail, {
        reason = reason,
        name = GetPlayerName(target.source),
        staff = {
          name = GetPlayerName(staff.source),
          identifier = GetLicense(staff.source, "license"),
        },
        date = os.date("%d/%m/%Y %H:%M:%S")
      })

      MySQL.Async.execute("UPDATE ricky_admin SET jail = @jail WHERE identifier = @identifier", {
        ['@jail'] = json.encode(myJail),
        ['@identifier'] = GetLicense(target.source, "license"),
      })

        MySQL.Sync.execute("UPDATE ricky_admin SET inJail = @inJail WHERE identifier = @identifier", {
          ['@identifier'] = GetLicense(target.source, "license"),
          ['@inJail'] = 1
        })

      TriggerClientEvent('ricky-admin:adminjail', target.source)
      local fields = {
        {
          name = Config.Lang[Config.Language]['nome_staff'],
          value = GetPlayerName(staff.source),
          inline = true
        },
        {
          name = Config.Lang[Config.Language]["nome_player"],
          value = GetPlayerName(target.source),
          inline = true
        },
        {
          name = Config.Lang[Config.Language]["motivo"],
          value = reason,
          inline = true
        },
      }
      sendWebhook("ADMIN JAIL", fields, ConfigServer.Webhook.adminjail)
      end
  elseif data.action == 'giveadmin' then
    local group = value1
    if target then 
      target.setGroup(group)
      local fields = {
        {
          name = Config.Lang[Config.Language]['nome_staff'],
          value = GetPlayerName(staff.source),
          inline = true
        },
        {
          name = Config.Lang[Config.Language]["nome_player"],
          value = GetPlayerName(target.source),
          inline = true
        },
        {
          name = "Gruppo",
          value = group,
          inline = true
        },
      }
      sendWebhook("GIVE ADMIN", fields, ConfigServer.Webhook.giveadmin)
    end
  elseif data.action == 'setped' then
    local ped = value1
    if target then 
      TriggerClientEvent('ricky-admin:setped', target.source, ped)
    end
  elseif data.action == 'dm' then
    local msg = value1
    if target then 
      TriggerClientEvent('ricky-admin:dm', target.source, msg)
      local fields = {
        {
          name = Config.Lang[Config.Language]['nome_staff'],
          value = GetPlayerName(staff.source),
          inline = true
        },
        {
          name = Config.Lang[Config.Language]["nome_player"],
          value = GetPlayerName(target.source),
          inline = true
        },
        {
          name = "Messaggio",
          value = msg,
          inline = true
        },
      }
      sendWebhook("MESSAGGIO PRIVATO", fields, ConfigServer.Webhook.sendmessage)
    end
  elseif data.action == 'annuncio' then 
    TriggerClientEvent('ricky-admin:announce', -1, value1)
    local fields = {
      {
        name = Config.Lang[Config.Language]['nome_staff'],
        value = GetPlayerName(staff.source),
        inline = true
      },
      {
        name = "Messaggio",
        value = value1,
        inline = true
      },
    }
    sendWebhook("ANNUNCIO", fields, ConfigServer.Webhook.annuncio)
  elseif data.action == "givemoneyall" then 
    local account = value1
    local count = value2
    local xPlayers = ESX.GetExtendedPlayers()
    for k,v in pairs(xPlayers) do 
      v.addAccountMoney(account, tonumber(count))
    end
    local fields = {
      {
        name = Config.Lang[Config.Language]['nome_staff'],
        value = GetPlayerName(staff.source),
        inline = true
      },
      {
        name = "Account",
        value = account,
        inline = true
      },
      {
        name = "Quantità",
        value = count,
        inline = true
      },
    }
    sendWebhook("DAI SOLDI A TUTTI", fields, ConfigServer.Webhook.givemoneyall)
  elseif data.action == "cleararea" then 
    local radius = value1
    TriggerClientEvent('ricky-admin:cleararea', -1, radius)
    local fields = {
      {
        name = Config.Lang[Config.Language]['nome_staff'],
        value = GetPlayerName(staff.source),
        inline = true
      },
      {
        name = "Raggio",
        value = radius,
        inline = true
      },
    }
    sendWebhook("CLEAR AREA", fields, ConfigServer.Webhook.cleararea)
  end
  TriggerClientEvent('ricky-admin:updatePlayers', -1)
end)

GetInfoBanFromId = function(source)
  local nomeRisorsa = GetCurrentResourceName()
  local file = LoadResourceFile(nomeRisorsa, 'ban.json')
  local data = json.decode(file)

  for k,v in pairs(data) do 
    if v.idBan == source then 
      return v
    end
  end
  return false
end

GetInfoBan = function(source)
  local nomeRisorsa = GetCurrentResourceName()
  local file = LoadResourceFile(nomeRisorsa, 'ban.json')
  local data = json.decode(file)

  local steam = GetLicense(source, 'steam') or 'N/A'
  local discord = GetLicense(source, 'discord')or 'N/A'
  local license = GetLicense(source, 'license')or 'N/A'
  local xbl = GetLicense(source, 'xbl')or 'N/A'
  local live = GetLicense(source, 'live')or 'N/A'
  local ip = GetLicense(source, 'ip')or 'N/A'

  for k,v in pairs(data) do 
    if v.steam == steam or v.discord == discord or v.license == license or v.xbl == xbl or v.live == live or v.ip == ip then 
      return v
    end
  end
  return false
end

GetBanFromIdentifier = function(identifier)
  local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_admin WHERE identifier = @identifier", {
    ['@identifier'] = identifier,
  })
  if result[1].ban == nil then
    return {}
  else
    return json.decode(result[1].ban)
  end
end

UnBan = function(idBan)
  local nomeRisorsa = GetCurrentResourceName()
  local file = LoadResourceFile(nomeRisorsa, 'ban.json')
  local data = json.decode(file)

  for k,v in pairs(data) do 
    if v.idBan == idBan then 
      v.valido = false
      SaveResourceFile(nomeRisorsa, 'ban.json', json.encode(data, {indent = true}), -1)

      local myBan = GetBanFromIdentifier(v.license)
      for a,b in pairs(myBan) do 
        if b.idBan == idBan then 
          b.valido = false
        end
      end

      MySQL.Async.execute("UPDATE ricky_admin SET ban = @ban WHERE identifier = @identifier", {
        ['@ban'] = json.encode(myBan),
        ['@identifier'] = v.license,
      })
    end
  end
  
  TriggerClientEvent('ricky-admin:updatePlayers', -1)
end

CheckBanned = function(source)
  local nomeRisorsa = GetCurrentResourceName()
  local file = LoadResourceFile(nomeRisorsa, 'ban.json')
  local data = json.decode(file)

  local steam = GetLicense(source, 'steam') or 'N/A'
  local discord = GetLicense(source, 'discord') or 'N/A'
  local license = GetLicense(source, 'license') or 'N/A'
  local xbl = GetLicense(source, 'xbl') or 'N/A'
  local live = GetLicense(source, 'live') or 'N/A'
  local ip = GetLicense(source, 'ip') or 'N/A'

  for k,v in pairs(data) do 
    if v.steam == steam or v.discord == discord or v.license == license or v.xbl == xbl or v.live == live or v.ip == ip then
      if v.valido == nil then 
        if v.time > os.time() then 
          return true
        else
          UnBan(v.idBan)
          return false
        end 
      end
    end
  end
  return false
end


AddEventHandler('playerConnecting', function(name, skr, d)
  local src = source
  d.defer()
  Wait(50)
  d.update('Controllando la lista ban')
  if CheckBanned(src) == false then 
    d.done()
    return
  end
  Wait(150)
  local ban = GetInfoBan(src)
  d.presentCard([==[{
    "type": "AdaptiveCard",
    "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
    "version": "1.5",
    "body": [
        {
            "type": "TextBlock",
            "text": "]==]..Config.NomeServer..[==[",
            "wrap": true,
            "horizontalAlignment": "Center"
        },
        {
            "type": "TextBlock",
            "text": "Sei stato bannato da questo server",
            "wrap": true,
            "size": "Medium",
            "horizontalAlignment": "Center"
        },
        {
            "type": "ActionSet",
            "actions": [
                {
                    "type": "Action.Execute",
                    "title": "BAN ID : ]==]..ban.idBan..[==["
                }
            ],
            "horizontalAlignment": "Center"
        },
        {
            "type": "TextBlock",
            "text": "Scadenza prevista per il ban: ]==]..os.date('%d/%m/%Y %H:%M:%S', ban.time)..[==[",
            "wrap": true,
            "horizontalAlignment": "Center"
        },
        {
            "type": "TextBlock",
            "text": "Se ritieni che il tuo ban sia stato un errore, contatta l'amministrazione del server (unisciti al server discord di seguito)",
            "wrap": true,
            "size": "Large",
            "color": "Warning",
            "horizontalAlignment": "Center"
        },
        {
            "type": "ActionSet",
            "actions": [
                {
                    "type": "Action.OpenUrl",
                    "title": "]==]..Config.NomeServer..[==[",
                    "url": "]==]..Config.DiscordServer..[==["
                }
            ],
            "horizontalAlignment": "Center"
        }
    ]
}]==])
end)

RegisterServerEvent('ricky-admin:skinmenu')
AddEventHandler('ricky-admin:skinmenu', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  TriggerClientEvent(Config.Trigger.skin, id)
  local target = ESX.GetPlayerFromId(id)

  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    },
  }
  sendWebhook("SKIN MENU", fields, ConfigServer.Webhook.skinmenu)
end)

RegisterServerEvent('ricky-admin:heal')
AddEventHandler('ricky-admin:heal', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    },
  }
  sendWebhook("HEAL", fields, ConfigServer.Webhook.heal)
  TriggerClientEvent(Config.Trigger.heal, id)
end)

RegisterServerEvent('ricky-admin:revive')
AddEventHandler('ricky-admin:revive', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)

  local target = ESX.GetPlayerFromId(id)
  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    },
  }
  sendWebhook("REVIVE", fields, ConfigServer.Webhook.revive)
  TriggerClientEvent(Config.Trigger.revive, id)
end)

RegisterServerEvent('ricky-admin:kill')
AddEventHandler('ricky-admin:kill', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)

  local target = ESX.GetPlayerFromId(id)
  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    },
  }
  sendWebhook("KILL", fields, ConfigServer.Webhook.kill)
  TriggerClientEvent('ricky-admin:kill', id)
end)


RegisterServerEvent('ricky-admin:goto')
AddEventHandler('ricky-admin:goto', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  if target == nil then 
    return
  end

  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    },
  }
  sendWebhook("GOTO", fields, ConfigServer.Webhook.goto1)
  local coords = target.getCoords(true)
  staff.setCoords(coords)
end)


RegisterServerEvent('ricky-admin:bring')
AddEventHandler('ricky-admin:bring', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  if target == nil then 
    return
  end
  
  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    },
  }
  sendWebhook("BRING", fields, ConfigServer.Webhook.bring)
  local coords = staff.getCoords(true)
  target.setCoords(coords)
end)


RegisterServerEvent('ricky-admin:clearInv')
AddEventHandler('ricky-admin:clearInv', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)

  local target = ESX.GetPlayerFromId(id)
  if target == nil then 
    return
  end

  local itemsTarget = target.getInventory()
  for k,v in pairs(itemsTarget) do 
    target.removeInventoryItem(v.name, v.count)
  end
  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    },
  }
  sendWebhook("CLEAR INV.", fields, ConfigServer.Webhook.clearinventory)
end)


ESX.RegisterServerCallback('ricky-admin:getInJail', function(source, cb)
  cb(InJail(source))
end)

RegisterServerEvent('ricky-admin:unjail')
AddEventHandler('ricky-admin:unjail', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)

  local target = ESX.GetPlayerFromId(id)
  if target == nil then 
    return
  end

  local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_admin WHERE identifier = @identifier", {
    ['@identifier'] = GetLicense(target.source, "license"),
  })

  MySQL.Sync.execute("UPDATE ricky_admin SET inJail = @inJail WHERE identifier = @identifier", {
    ['@identifier'] = GetLicense(target.source, "license"),
    ['@inJail'] = 0
  })


  local coords = json.decode(result[1].jailCoords)

  target.setCoords(coords)

  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    },
  }
  sendWebhook("UNJAIL", fields, ConfigServer.Webhook.adminjail)

  TriggerClientEvent('ricky-admin:updatePlayers', -1)
  TriggerClientEvent('ricky-admin:unjail', target.source)

end)


RegisterServerEvent('ricky-admin:wipe')
AddEventHandler('ricky-admin:wipe', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)
  local target = ESX.GetPlayerFromId(id)
  if target == nil then 
    return
  end

  for k,v in pairs(Config.WipeSettings) do 
    for a,b in pairs(v) do 

        MySQL.Sync.execute('DELETE FROM '..b..' WHERE '..k..' = @identifier',{
          ['@identifier'] = target.identifier,
        })
    end
  end
  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    },
  }
  sendWebhook("WIPE", fields, ConfigServer.Webhook.wipe)
  DropPlayer(target.source, 'Sei stato wipato dal server')
end)

RegisterServerEvent('ricky-admin:deletewarn')
AddEventHandler('ricky-admin:deletewarn', function(id, index)
  local src = source
  local staff = ESX.GetPlayerFromId(src)

  local target = ESX.GetPlayerFromId(id)

  if target == nil then 
    return
  end

  if index == 0 then 
    index = 1
  end

  local warn = GetWarn(target)
  table.remove(warn, index)

  MySQL.Async.execute("UPDATE ricky_admin SET warn = @warn WHERE identifier = @identifier", {
    ['@warn'] = json.encode(warn),
    ['@identifier'] = GetLicense(target.source, "license"),
  })

  
  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    },
  }
  sendWebhook("WARN ELIMINATO", fields, ConfigServer.Webhook.warn)
  TriggerClientEvent('ricky-admin:updatePlayers', -1)
end)


local function getJobs()
  local jobs = {}
  local esxJobs = ESX.GetJobs()
  for k, v in pairs(esxJobs) do
    table.insert(jobs, {
      label = v.label,
      value = v.name,
    })
  end

  return jobs
end

ESX.RegisterServerCallback('ricky-admin:getOrario', function(source, cb)
  local hour = os.date("%H:%M")
  cb(hour)
end)


RegisterCommand('unban', function(source, args, rawCommand)
  if source == 0 or SonoStaff(ESX.GetPlayerFromId(source)) then 
    local idBan = tonumber(args[1])
    if not GetInfoBanFromId(idBan) then 
      if source == 0 then 
        print("ID Ban non valido")
      else
        ESX.GetPlayerFromId(source).showNotification("ID Ban non valido", "error")
      end
      return
    end
    UnBan(idBan)
    if source == 0 then 
      print("Unban effettuato con successo")
    else
      ESX.GetPlayerFromId(source).showNotification("Unban effettuato con successo", "success")
    end
  end
end)

ESX.RegisterServerCallback('ricky-admin:getCoordsPlayer', function(source,cb,id)
  local xPlayer = ESX.GetPlayerFromId(id)
  if xPlayer == nil then return end
  cb(xPlayer.getCoords(true), xPlayer.getCoords(false))
end)

RegisterServerEvent('ricky-admin:freeze')
AddEventHandler('ricky-admin:freeze', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)

  local target = ESX.GetPlayerFromId(id)

  if target == nil then 
    return
  end

  TriggerClientEvent('ricky-admin:freeze', target.source)
  if client_var[target.source].freeze == 1 then 
    client_var[target.source].freeze = false
  else
    client_var[target.source].freeze = 1
  end

  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    },
  }
  sendWebhook("FREEZE", fields, ConfigServer.Webhook.freeze)

  TriggerClientEvent('ricky-admin:updatePlayers', -1)
end)

RegisterServerEvent('ricky-admin:sfreeze')
AddEventHandler('ricky-admin:sfreeze', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)

  local target = ESX.GetPlayerFromId(id)

  if target == nil then 
    return
  end

  TriggerClientEvent('ricky-admin:sfreeze', target.source)
  if client_var[target.source].freeze == 1 then 
    client_var[target.source].freeze = false
  else
    client_var[target.source].freeze = 1
  end

  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    },
  }
  sendWebhook("SFREEZE", fields, ConfigServer.Webhook.freeze)

  TriggerClientEvent('ricky-admin:updatePlayers', -1)
end)

RegisterServerEvent('ricky-admin:revocaban')
AddEventHandler('ricky-admin:revocaban', function(staffId, id)
  UnBan(id)
  TriggerClientEvent('ricky-admin:updatePlayers', -1)

  local ban = GetInfoBanFromId(id)

  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staffId),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = ban.name,
      inline = true
    },
    {
      name = "Motivo Ban",
      value = ban.reason,
      inline = true
    },
    {
      name = "Scadenza Ban",
      value = ban.labelScadenza,
      inline = true
    }
  }

  sendWebhook("REVOCA BAN", fields, ConfigServer.Webhook.ban)
end)

local function getAdminOnline()
  local xPlayers = ESX.GetExtendedPlayers()
  local adminOnline = 0

  for _, xPlayer in pairs(xPlayers) do
    for a, b in pairs(Config.AdminGroup) do
      if xPlayer.getGroup() == a then
        adminOnline = adminOnline + 1
      end
    end
  end

  return adminOnline
end

RegisterServerEvent('ricky-admin:reviveall')
AddEventHandler('ricky-admin:reviveall', function()

  local staff = ESX.GetPlayerFromId(source)
  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
  }
  sendWebhook("REVIVE ALL", fields, ConfigServer.Webhook.revive)

  TriggerClientEvent(Config.Trigger.revive, -1)
end)


ESX.RegisterServerCallback('ricky-admin:getAllKicks', function(source, cb)
  local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_admin")
  local counterKicks = 0
  for i=1, #result, 1 do 
    local kick = json.decode(result[i].kick)
    if kick ~= nil then 
      for a=1, #kick, 1 do 
        counterKicks = counterKicks + 1
      end
    end
  end
  cb(counterKicks)
end)

RegisterServerEvent('ricky-admin:clearped')
AddEventHandler('ricky-admin:clearped', function(id)
  local src = source
  local staff = ESX.GetPlayerFromId(src)

  local target = ESX.GetPlayerFromId(id)
  if target == nil then 
    return
  end

  local fields = {
    {
      name = Config.Lang[Config.Language]['nome_staff'],
      value = GetPlayerName(staff.source),
      inline = true
    },
    {
      name = Config.Lang[Config.Language]["nome_player"],
      value = GetPlayerName(target.source),
      inline = true
    }
  }
  sendWebhook("CLEAR PED", fields, ConfigServer.Webhook.clearped)
  TriggerClientEvent('ricky-admin:clearped', target.source)
end)


GenerateRandomColor = function()
  local red = math.random(0, 255)
  local green = math.random(0, 255)
  local blue = math.random(0, 255)
  return red, green, blue
end

RegisterServerEvent('ricky-admin:webhook')
AddEventHandler('ricky-admin:webhook', function(title, fields, webhook)
  if type(webhook) == "string" then 
    webhook = ConfigServer.Webhook[webhook]
  end
  sendWebhook(title, fields, webhook)
end)

sendWebhook = function(title, fields, webhook)
  local colorRed, colorGreen, colorBlue = GenerateRandomColor()
  local embed = {
    {
      ["title"] = title,
      ["type"] = "rich",
      ["color"] = colorRed * 65536 + colorGreen * 256 + colorBlue,
      ["fields"] = fields,
      ["footer"] = {
        ["text"] = os.date("%d/%m/%Y %H:%M:%S"),
      },
      ['thumbnail'] = {
        ['url'] = Config.LogoServer,
      }
    }
  }
  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.NomeServer, avatar_url=Config.LogoServer, embeds = embed}), { ['Content-Type'] = 'application/json' })
end
