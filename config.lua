Config = {}

Config.NomeServer = "Nova Scripts"

Config.LogoServer = "https://cdn.discordapp.com/attachments/944572269202640946/1140062557068075028/nova.png"

Config.DiscordServer = "https://discord.gg/tHAbhd94vS"

Config.Language = "it"

Config.AdminJailCoords = vector3(1641.6, 2571.0, 44.5)

Config.GroupUser = 'user'

Config.CommandName = 'admin'

Config.Keybinds = {
    adminmenu = {
        enable = true,
        key = 'M'
    },
    noclip = {
        enable = true,
        key = 'HOME'
    },
    nomitesta = {
        enable = true,
        key = 'F9'
    },
}


Config.AdminGroup = {

    -- ['GROUP_NAME'] = {
    --     rank = 0,
    --     label = "GROUP_LABEL",
    --     id = "GROUP_ID",
    -- }

    ['helper'] = {
        rank = 1,
        label = "Helper",
        id = "helper",
    },
    ['mod'] = {
        rank = 2,
        label = "Moderatore",
        id = "mod",
    },
    ['admin'] = {
        rank = 3,
        label = "Admin",
        id = "admin",
    },
    ['superadmin'] = {
        rank = 4,
        label = "Super Admin",
        id = "superadmin",
    },
    ['owner'] = {
        rank = 5,
        label = "Owner",
        id = "owner",
    }
}

Config.ClearAreaRadius = {
    {
        label = "100",
        value = 100
    },
    {
        label = "250",
        value = 250
    },
    {
        label = "500",
        value = 500
    }
}

Config.Trigger = {
    skin = 'esx_skin:openSaveableMenu',
    revive = "esx_ambulancejob:revive",
    heal = "esx_basicneeds:healPlayer",
}

Config.WipeSettings = { -- !!

    -- [TABLE_NAME] = {
    --     COLUMN_NAME
    -- }
    
    ['identifier'] = {
        'users'
    }
}

Config.BanTime = {
    {
        label = "12 Ore",
        value = 43200
    },
    {
        label = "1 Giorno",
        value = 86400
    },
    {
        label = "2 Giorni",
        value = 172800
    },
    {
        label = "3 Giorni",
        value = 259200
    },
    {
        label = "1 Settimana",
        value = 604800
    },
    {
        label = "2 Settimane",
        value = 1209600
    },
    {
        label = "Permanente",
        value = 999999999 
    }
}


-- Non modificare l'id delle azioni
Config.Azioni = {
    {
        label = 'Ban',
        id = 'ban',
        image = 'ban.png',
        rank = 1 -- Grado minimo
    },
    {
        label = 'Kick',
        id = 'kick',
        image = 'kick.png',
        rank = 1
    },
    {
        label = 'Admin Jail',
        id = 'adminjail',
        image = 'adminjail.png',
        rank = 1
    },
    {
        label = 'Warn',
        id = 'warn',
        image = 'warn.png',
        rank = 1
    },
    {
        label = 'Skin Menu',
        id = 'skinmenu',
        image = 'skinmenu.png',
        rank = 1
    },
    {
        label = 'Spectate',
        id = 'spectate',
        image = 'spectate.png',
        rank = 1
    },
    {
        label = 'Revive',
        id = 'revive',
        image = 'revive.png',
        rank = 1
    },
    {
        label = 'Heal',
        id = 'heal',
        image = 'heal.png',
        rank = 1
    },
    {
        label = 'Kill',
        id = 'kill',
        image = 'kill.png',
        rank = 1
    },
    {
        label = 'Wipe',
        id = 'wipe',
        image = 'wipe.png',
        rank = 1
    },
    {
        label = 'Go To',
        id = 'goto',
        image = 'goto.png',
        rank = 1
    },
    {
        label = 'Bring',
        id = 'bring',
        image = 'bring.png',
        rank = 1
    },
    {
        label = 'Give Item',
        id = 'giveitem',
        image = 'giveitem.png',
        rank = 1
    },
    {
        label = 'Give Money',
        id = 'givemoney',
        image = 'givemoney.png',
        rank = 1
    },
    {
        label = 'Set Job',
        id = 'setjob',
        image = 'setjob.png',
        rank = 1
    },
    {
        label = 'Clear Inv.',
        id = 'clearinventory',
        image = 'clearinventory.png',
        rank = 1
    },
    {
        label = 'Give Admin',
        id = 'giveadmin',
        image = 'giveadmin.png',
        rank = 1
    },
    {
        label = 'Clear Ped',
        id = 'clearped',
        image = 'clearped.png',
        rank = 1
    },
    {
        label = 'DM',
        id = 'sendmessage',
        image = 'sendmessage.png',
        rank = 1
    },
    {
        label = 'Freeze',
        id = 'freeze',
        image = 'freeze.png',
        rank = 1
    }
}

-- Non modificare l'id delle azioni
Config.AzioniPersonale = {
    {
        label = 'Revive',
        id = 'revive',
        image = 'revive.png',
        rank = 1
    },
    {
        label = 'Heal',
        id = 'heal',
        image = 'heal.png',
        rank = 1
    },
    {
        label = 'NoClip',
        id = 'noclip',
        image = 'noclip.png',
        rank = 1
    },
    {
        label = "Invisibilità",
        id = 'invisibilita',
        image = 'invisibility.png',
        rank = 1
    },
    {
        label = "God Mode",
        id = 'godmode',
        image = 'invincible.png',
        rank = 1
    },
    {
        label = "Nomi Player",
        id = 'nomiplayer',
        image = 'nomiplayer.png',
        rank = 1
    },
    {
        label = "Annuncio",
        id = "annuncio",
        image = 'announce.png',
        rank = 1
    },
    {
        label = 'Give Item',
        id = 'giveitem',
        image = 'giveitem.png',
        rank = 1
    },
    {
        label = "Revive All",
        id = "reviveall",
        image = "reviveall.png",
        rank = 1
    },
    {
        label = "Dai Soldi a Tutti",
        id = "givemoneyall",
        image = "givemoney.png",
        rank = 1
    },
    {
        label = "Ripara Veicolo",
        id = "repairvehicle",
        image = "repairveh.png",
        rank = 1
    },
    {
        label = "Clear Area",
        id = "cleararea",
        image = "cleararea.png",
        rank = 1
    },
    {
        label = "Clear Inv.",
        id = "clearinventory",
        image = "clearinventory.png",
        rank = 1
    },
    {
        label = "Clear Ped",
        id = "clearped",
        image = "clearped.png",
        rank = 1
    },
    {
        label = "Skin Menu",
        id = "skinmenu",
        image = "skinmenu.png",
        rank = 1
    }
}

Config.Lang = {
    ['it'] = {
        ['dashboard'] = "Dashboard",
        ['lista_player'] = "Lista Player",
        ['menu_personale'] = "Menu Personale",
        ['lista_ban'] = "Lista Ban",
        ['esci'] = "Esci",
        ['benvenuto'] = "Benvenuto,",
        ['search_name'] = "Cerca dal Nome",
        ['search_id'] = "Cerca dall\'ID",
        ['lista_kick'] = "Lista Kick",
        ['lista_jail'] = "Lista Jail",
        ['lista_warn'] = "Lista Warn",
        ['nome_staff'] = "Nome Staff",
        ['nome_player'] = "Nome Utente",
        ['motivo'] = "Motivo",
        ['data'] = "Data",
        ['azioni'] = "Azioni",
        ['scadenza'] = "Scadenza",
        ['valido'] = "Valido",
        ['scaduto'] = "Scaduto",
        ['stato'] = "Stato",
        ['id_ban'] = "ID Ban",
        ['seleziona_opzione'] = "Seleziona un Opzione",
        ['confirm'] = "Conferma",
        ['cancel'] = "Cancella",
        ['utente'] = "Utente",
        ['revoca'] = "Revoca",
        ['no_azione'] = "Nessun Azione",
        ['discord'] = "Discord ID: ",
        ['steam'] = "Steam ID: ",
        ['license'] = "License ID: ",
        ['elimina'] = "Elimina",
        ['seleziona_opzione'] = "Seleziona un Opzione",
        ['ban_totali'] = "Ban Totali",
        ['kick_totali'] = "Kick Totali",
        ['staff_online'] = "Admin Online",
        ['player_online'] = "Player Online",
        ['unfreeze'] = "Unfreeze",
        ['unjail'] = "Unjail",
        ['job_grade'] = "Grado Lavoro",
        ['ban'] = "BAN",
        ['kick'] = "KICK",
        ['jail'] = "ADMIN JAIL",
        ['warn'] = "WARN",
        ['giveitem'] = "GIVE ITEM",
        ['givemoney'] = "GIVE MONEY",
        ['setjob'] = "SET JOB",
        ['sendmessage'] = "MANDA MESSAGGIO IN DM",
        ['giveadmin'] = "DAI PERMESSI",
        ['setped'] = "SET PED",
        ['item_name'] = "Nome Item",
        ['item_count'] = "Quantità Item",
        ['cash'] = "Contanti",
        ['bank'] = "Banca",
        ['black_money'] = "Soldi Sporchi",
        ['count'] = "Quantità",
        ['text'] = "Messaggio",
        ['ped_name'] = "Nome Ped",
        ['annuncio'] = "ANNUNCIO",
        ['dmmessage'] = "MESSAGGIO PRIVATO",
        ['give_money_all'] = "DAI SOLDI A TUTTI",
        ['stato_nomitesta'] = "Stato Nomi Testa",
        ['stato_noclip'] = "Stato NoClip",
        ['stato_invisible'] = "Stato Invisibilità",
        ['stato_godmode'] = "Stato Godmode",
        ['godmode'] = "Godmode",
        ['noclip'] = "NoClip",
        ['invisibilita'] = "Invisibilità",
        ['nomitesta'] = "Nomi Testa",
        ['attivo'] = "Attivo",
        ['inattivo'] = "Inattivo",
        ['esci_spectate'] = "Premi ~INPUT_PICKUP~ per uscire dalla modalità spettatore",
        ['inizio_spectate'] = "Inizio Spectate",
        ['fine_spectate'] = "Fine Spectate",
        ['veicolo'] = "Veicolo",
        ['ripara_veicolo'] = "Ripara Veicolo",
        ['clear_area'] = "Clear Area",
        ['exit_noclip'] = "Premi ~INPUT_23B4087C~ per uscire dal noclip",

        ['noclip_attivato'] = "NoClip Attivato",
        ['noclip_disattivato'] = "NoClip Disattivato",
        ['revive'] = "Hai rianimato con successo!",
        ['heal'] = "Hai curato con successo!",
        ['clear_ped'] = "Il tuo ped è stato pulito con successo",
        ['clear_ped2'] = "Hai pulito il ped con successo",
        ['clear_area2'] = "Hai pulito la zona con successo",
        ['repair_vehicle2'] = "Hai riparato il veicolo con successo",
        ['delete_warn'] = "Hai eliminato il warn",
        ['nomitesta_a'] = "Hai attivato i nomi sulla testa",
        ['nomitesta_b'] = "Hai disattivato i nomi sulla testa",     
        ['revoca_ban'] = "Hai revocato il ban",
        ['kill'] = "Hai ucciso il player",
        ['wipe'] = "Hai wipato il player",
        ['clear_inv2'] = "Hai pulito l\'inventario del player",
        ['jailato'] = "Hai messo in carcere il player",
        ['unjailato'] = "Hai scarcerato il player",
        ['invisibilita_a'] = "Hai attivato l\'invisibilità",
        ['invisibilita_b'] = "Hai disattivato l\'invisibilità",
        ['godmode_a'] = "Hai attivato la godmode",
        ['godmode_b'] = "Hai disattivato la godmode",
        ['revive_all'] = "Hai curato tutti"
    },
    ['en'] = {
        ['dashboard'] = "Dashboard",
        ['lista_player'] = "Player List",
        ['menu_personale'] = "Personal Menu",
        ['lista_ban'] = "Ban List",
        ['esci'] = "Exit",
        ['benvenuto'] = "Welcome,",
        ['search_name'] = "Search by Name",
        ['search_id'] = "Search by ID",
        ['lista_kick'] = "Kick List",
        ['lista_jail'] = "Jail List",
        ['lista_warn'] = "List Warn",
        ['nome_staff'] = "Staff Name",
        ['nome_player'] = "User",
        ['motivo'] = "reason",
        ['data'] = "Date",
        ['azioni'] = "Actions",
        ['scadenza'] = "Expire",
        ['valido'] = "Valid",
        ['scaduto'] = "Expired",
        ['stato'] = "Status",
        ['id_ban'] = "ID Ban",
        ['seleziona_opzione'] = "Select an Option",
        ['confirm'] = "Confirm",
        ['cancel'] = "Cancel",
        ['utente'] = "User",
        ['revoca'] = "Revoke",
        ['no_azione'] = "No Action",
        ['discord'] = "Discord ID: ",
        ['steam'] = "Steam ID: ",
        ['license'] = "License ID: ",
        ['elimina'] = "Delete",
        ['ban_totali'] = "Total Bans",
        ['kick_totali'] = "Total Kicks",
        ['staff_online'] = "Admin Online",
        ['player_online'] = "Player Online",
        ['unfreeze'] = "Unfreeze",
        ['unjail'] = "Unjail",
        ['job_grade'] = "Job Grade",
        ['ban'] = "BAN",
        ['kick'] = "KICK",
        ['jail'] = "ADMIN JAIL",
        ['warn'] = "WARN",
        ['giveitem'] = "GIVE ITEM",
        ['givemoney'] = "GIVE MONEY",
        ['setjob'] = "SET JOB",
        ['sendmessage'] = "DM MESSAGE",
        ['giveadmin'] = "GIVE PERMISSIONS",
        ['setped'] = "SET PED",
        ['item_name'] = "Item Name",
        ['item_count'] = "Item Quantity",
        ['cash'] = "Cash",
        ['bank'] = "Bank",
        ['black_money'] = "Dirty Money",
        ['count'] = "Amount",
        ['text'] = "Message",
        ['ped_name'] = "Ped Name",
        ['annuncio'] = "ANNOUNCE",
        ['dmmessage'] = "DM MESSAGE",
        ['give_money_all'] = "GIVE MONEY TO ALL",
        ['stato_nomitesta'] = "Head Names Status",
        ['stato_noclip'] = "NoClip state",
        ['stato_invisible'] = "Invisibility Status",
        ['stato_godmode'] = "Godmode state",
        ['godmode'] = "Godmode",
        ['noclip'] = "NoClip",
        ['invisibilita'] = "Invisibility",
        ['nomitesta'] = "Head Names",
        ['attivo'] = "Active",
        ['inattivo'] = "Inactive",
        ['esci_spectate'] = "Press ~INPUT_PICKUP~ to exit spectator mode",
        ['inizio_spectate'] = "Start Spectate",
        ['fine_spectate'] = "End Spectate",
        ['veicolo'] = "Vehicle",
        ['ripara_veicolo'] = "Repair Vehicle",
        ['clear_area'] = "Clear Area",
        ['exit_noclip'] = "Press ~INPUT_23B4087C~ to exit noclip",

        ['noclip_attivato'] = "NoClip Activated",
        ['noclip_disattivato'] = "NoClip Disabled",
        ['revive'] = "You have successfully revived!",
        ['heal'] = "You have successfully healed!",
        ['clear_ped'] = "Your ped has been cleared successfully",
        ['clear_ped2'] = "You have cleared the ped successfully",
        ['clear_area2'] = "You have cleared the area successfully",
        ['repair_vehicle2'] = "You have successfully repaired the vehicle",
        ['delete_warn'] = "You have deleted the warn",
        ['nomitesta_a'] = "You have activated headnames",
        ['nomitesta_b'] = "You have deactivated the names on the head",
        ['revoca_ban'] = "You have revoked the ban",
        ['kill'] = "You have killed the player",
        ['wipe'] = "You have wiped the player",
        ['clear_inv2'] = "You have cleared the player\'s inventory",
        ['jailato'] = "You have jailed the player",
        ['unjailato'] = "You have released the player",
        ['invisibilita_a'] = "You have invisibility activated",
        ['invisibilita_b'] = "You have disabled invisibility",
        ['godmode_a'] = "You have activated godmode",
        ['godmode_b'] = "You have disabled godmode",
        ['revive_all'] = "You have cured all"
    }
}

-- Functions --

SonoStaff = function(xPlayer)
    local group = xPlayer.getGroup()
    for k, v in pairs(Config.AdminGroup) do
        if group == k then
            return true
        end
    end
    return false
end

SendDMMessage = function(text)
    postMessage({
        type = "SHOW_DM_MESSAGE",
        text = text
    })
end

Announce = function(text)
    postMessage({
        type = "SHOW_ANNOUNCE",
        text = text
    })
end
