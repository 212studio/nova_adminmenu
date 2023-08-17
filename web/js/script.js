const app = new Vue({
    el: '#app',

    data: {

        nomeRisorsa : GetParentResourceName(),

        findbyname : '',

        findbyidban : '',

        questionInfo : {},

        kickTotali : 0,

        radius : [],

        viewTwoQuestionInput : false,
        viewOneQuestionInput : false,

        listaBan : [],

        labelAdminJail : false,
        labelFreeze : false,

        orario : "",
        
        config : [],

        viewList : false,

        listType : false,

        adminOnline : 0,

        infoStaff : [],

        azioni : [],

        jobs : [],

        adminGroups : [],

        azioniPersonale : [],

        infoDashboard : [
            {
                label : '',
                img : 'admin_online.png',
                id : 'adminonline',
                value : 0
            },
            {
                label : '',
                img : 'player_online.png',
                id : 'playeronline',
                value : 3
            },
            {
                label : '',
                img : 'total_ban.png',
                id : 'totalban',
                value : 3
            },
            {
                label : '',
                img : 'total_kick.png',
                id : 'totalkick',
                value : 3
            },
        ],

        listaPlayer : [],

        optionSelected : 'dashboard',

        playerSelected : false,

        test : false,
    },

    methods: {

        postMessage(name, table) {
            $.post(`https://${this.nomeRisorsa}/${name}`, JSON.stringify(table))
        },

        updateSelectedOption(option) {
            this.optionSelected = option;

            var elements = document.getElementsByClassName("opzione");
            for (var i = 0; i < elements.length; i++) {
                elements[i].style.background = "none"
            }

            var element = document.getElementById("opzione"+option);
            element.style.backgroundColor = "#4B4B4B";
            this.viewList = false
            this.listType = false
        },

        updateOptionSelected(option) {
            this.optionSelected = option;
        },

        setBgFromInfo(img) {
            return {
                backgroundImage: 'url("img/'+img+'")'
            }
        },

        setLogoServer() {
            return {
                backgroundImage: url(this.config.LogoServer)
            }
        },

        setPlayerBg(player) {
            if(player.staff) {
                return {
                    background: "linear-gradient(90deg, rgba(255, 12, 12, 0.40) 0%, rgba(0, 0, 0, 0.00) 100%), rgba(216, 216, 216, 0.05)"
                }
            } else {
                return {
                    background: 'linear-gradient(90deg, rgba(236, 236, 236, 0.40) 0%, rgba(0, 0, 0, 0.00) 100%), rgba(216, 216, 216, 0.05)'
                }
            }
        },

        filterByName() {
            if(this.findbyname != '') {
                return this.listaPlayer.filter(player => {
                    return (
                        player.name.toLowerCase().includes(this.findbyname.toLowerCase()) ||
                        player.id.toString().includes(this.findbyname.toLowerCase()) ||
                        player.job.name.toLowerCase().includes(this.findbyname.toLowerCase()) || 
                        player.job.label.toLowerCase().includes(this.findbyname.toLowerCase()) 
                    )
                })
            } else {
                return this.listaPlayer
            }
        },

        filterByIdBan() {
            if(this.findbyidban != '') {
                return this.listaBan.filter(ban => {
                    return (
                        ban.idBan.toString().includes(this.findbyidban.toLowerCase()) || 
                        ban.name.toLowerCase().includes(this.findbyidban.toLowerCase()) ||
                        ban.staff.name.toLowerCase().includes(this.findbyidban.toLowerCase()) 
                    )
                })
            } else {
                return this.listaBan
            }
        },

        infoUser(id) {



            this.viewList = false
            this.updateOptionSelected('infopersona');
            for(const[k,v] of Object.entries(this.listaPlayer)) {
                if(v.id == id) {
                    this.playerSelected = v
                }
            }

            for(const[k,v] of Object.entries(this.azioni)) {
                if(v.id == 'adminjail' && this.playerSelected.inJail) {
                    v.label = this.config.lang.unjail
                    v.id = 'unjail'
                } else if(v.id == 'unjail' && !this.playerSelected.inJail) {
                    v.label = this.labelAdminJail
                    v.id = 'adminjail'
                }

                if(v.id == 'freeze' && this.playerSelected.freezed) {
                    v.label = this.config.lang.unfreeze
                    v.id = 'sfreeze'
                } else if(v.id == 'sfreeze' && !this.playerSelected.freezed) {
                    v.label = this.labelFreeze
                    v.id = 'freeze'
                }
            }
        },

        revocaBan(idban) {
            this.postMessage('revocaban', {
                id : idban
            })
        },

        setImageLogo(bool) {
            if(bool) {
                var link = this.infoStaff.avatar
            } else {
                var link = this.playerSelected.avatar
            }
            return {
                backgroundImage: 'url("'+link+'")'
            }
        },

        copy(type, bool) {
            if(type == 'discord') {
                if(bool) {
                    string = this.infoStaff.license.discord
                } else {
                    string = this.playerSelected.license.discord
                }
            } else if(type == 'steam') {
                if(bool) {
                    string = this.infoStaff.license.steam
                } else {
                    string = this.playerSelected.license.steam
                }
            } else if(type == 'license') {
                if(bool) {
                    string = this.infoStaff.license.license
                } else {
                    string = this.playerSelected.license.license
                }
            }

            var $temp = $("<input>");
            $("body").append($temp);
            $temp.val(string).select();
            document.execCommand("copy");
            $temp.remove();
            

        },

        viewDoubleInput(bool) {
            this.viewTwoQuestionInput = bool
        },

        viewOneInput(bool) {
            this.viewOneQuestionInput = bool
        },

        setQuestionInformation(type) {
            return {
                background: 'radial-gradient(951.28% 203.42% at 6.89% 114.21%, '+this.questionInfo.color+' 0%, rgba(255, 255, 255, 0.82) 100%)'
            }
        },

        closeQuestion() {
            if(this.viewTwoQuestionInput) {
                this.viewTwoQuestionInput = false
            } else if(this.viewOneQuestionInput) {
                this.viewOneQuestionInput = false
            }
        },

        azione(id) {
            if(!this.playerSelected.id) {
                this.playerSelected = {}
                this.playerSelected.id = this.infoStaff.id
            }
            if(id == 'ban') {
                this.questionInfo = {
                    title : this.config.lang.ban,
                    color : '#fc1703',
                    action : 'ban',
                    input1 : {
                        type : 'select',
                        options : this.config.BanTime
                    },
                    input2 : {
                        placeholder : this.config.lang.motivo,
                        type : 'text'
                    }
                }
                this.viewDoubleInput(true)
            } else if(id == 'kick') {
                this.questionInfo = {
                    title : this.config.lang.kick,
                    color : '#cfab1b',
                    action : 'kick',
                    input1 : {
                        placeholder : this.config.lang.motivo,
                        type : 'text',
                    },
                }
                this.viewOneInput(true)
            } else if(id == 'adminjail') {
                this.questionInfo = {
                    title : this.config.lang.jail,
                    color : '#12a675',
                    action : 'adminjail',
                    input1 : {
                        placeholder : this.config.lang.motivo,
                        type : 'text'
                    }
                }
                this.viewOneInput(true)
            } else if(id == 'warn') {
                this.questionInfo = {
                    title : this.config.lang.warn,
                    color : '#1250a6',
                    action : 'warn',
                    input1 : {
                        placeholder : this.config.lang.motivo,
                        type : 'text'
                    }
                }
                this.viewOneInput(true)
            } else if(id == 'giveitem') {
                this.questionInfo = {
                    title : this.config.lang.giveitem,
                    color : 'green',
                    action : 'giveitem',
                    input1 : {
                        placeholder : this.config.lang.item_name,
                        type : 'text'
                    },
                    input2 : {
                        placeholder : this.config.lang.item_count,
                        type : 'number'
                    }
                }
                this.viewDoubleInput(true)
            } else if(id == 'givemoney') {
                this.questionInfo = {
                    title : this.config.lang.givemoney,
                    color : 'grey',
                    action : 'givemoney',
                    input1 : {
                        type : 'select',
                        options : [
                            {
                                label : this.config.lang.cash,
                                value : 'money'
                            },
                            {
                                label : this.config.lang.bank,
                                value : 'bank'
                            },
                            {
                                label : this.config.lang.black_money,
                                value : 'black_money'
                            }
                        ]
                    },
                    input2 : {
                        placeholder : this.config.lang.count,
                        type : 'number'
                    }
                }
                this.viewDoubleInput(true)
            } else if(id == 'setjob') {
                this.questionInfo = {
                    title : this.config.lang.setjob,
                    color : '#09AA70',
                    action : 'setjob',
                    input1 : {
                        options : this.jobs,
                        type : 'select',
                    },
                    input2 : {
                        placeholder : this.config.lang.job_grade,
                        type : 'number'
                    }
                }
                this.viewDoubleInput(true)
            } else if(id == 'sendmessage') {
                this.questionInfo = {
                    title : this.config.lang.sendmessage,
                    color : '#12c42f',
                    action : 'dm',
                    input1 : {
                        placeholder : this.config.lang.text,
                        type : 'text',
                    },
                }
                this.viewOneInput(true)
            } else if(id == 'skinmenu') {
                this.postMessage('skinmenu', {
                    id : this.playerSelected.id
                })
                if(this.playerSelected.id == this.infoStaff.id) {
                    this.playerSelected = false
                    this.postMessage('close')
                    $("#app").fadeOut(500)
                }
            } else if(id == 'revive') {
                this.postMessage('revive', {
                    id : this.playerSelected.id
                })
                $("#app").fadeOut(500)
                this.playerSelected = false
                this.postMessage('close')
            } else if(id == 'heal') {
                this.postMessage('heal', {
                    id : this.playerSelected.id
                })
                $("#app").fadeOut(500)
                this.playerSelected = false
                this.postMessage('close')
            } else if(id == 'kill') {
                this.postMessage('kill', {
                    id : this.playerSelected.id
                })
                $("#app").fadeOut(500)
                this.playerSelected = false
                this.postMessage('close')
            } else if(id == 'goto') {
                this.postMessage('goto', {
                    id : this.playerSelected.id
                })
                $("#app").fadeOut(500)
                this.playerSelected = false
                this.postMessage('close')
            } else if(id == 'bring') {
                this.postMessage('bring', {
                    id : this.playerSelected.id
                })
                $("#app").fadeOut(500)
                this.playerSelected = false
                this.postMessage('close')
            } else if(id == 'clearinventory') {
                this.postMessage('clearinv', {
                    id : this.playerSelected.id
                })
                $("#app").fadeOut(500)
                this.playerSelected = false
                this.postMessage('close')
            } else if(id == 'unjail') {
                this.postMessage('unjail', {
                    id : this.playerSelected.id
                })
                $("#app").fadeOut(500)
                this.playerSelected = false
                this.postMessage('close')
            } else if(id == 'wipe') {
                this.postMessage('wipe', {
                    id : this.playerSelected.id
                })
                $("#app").fadeOut(500)
                this.playerSelected = false
                this.postMessage('close')
            } else if(id == "giveadmin") {
                this.questionInfo = {
                    title : this.config.lang.giveadmin,
                    color : '#78e827',
                    action : 'giveadmin',
                    input1 : {
                        options : this.adminGroups,
                        type : 'select',
                    },
                }
                this.viewOneInput(true)
            } else if(id == "spectate") {
                if(this.playerSelected.id == this.infoStaff.id) {
                    return 
                }
                $("#app").fadeOut(500)
                this.postMessage('spectate', {
                    id : this.playerSelected.id
                })
            } else if(id == "setped") {
                this.questionInfo = {
                    title : this.config.lang.setped,
                    color : '#621cbd',
                    action : 'setped',
                    input1 : {
                        placeholder : this.config.lang.ped_name,
                        type : 'text',
                    },
                }
                this.viewOneInput(true)
            } else if(id == "freeze") {
                this.postMessage('freeze', {
                    id : this.playerSelected.id
                })
                $("#app").fadeOut(500)
                this.playerSelected = false
                this.postMessage('close')
            } else if(id == "sfreeze") {
                this.postMessage('sfreeze', {
                    id : this.playerSelected.id
                })
                $("#app").fadeOut(500)
                this.playerSelected = false
                this.postMessage('close')
            } else if(id == "noclip") {
                this.playerSelected = false
                $("#app").fadeOut(500)
                this.postMessage('noclip')
            } else if(id == "invisibilita") {
                this.playerSelected = false
                $("#app").fadeOut(500)
                this.postMessage('invisibilita')
            } else if(id== "godmode") {
                this.playerSelected = false
                $("#app").fadeOut(500)
                this.postMessage('godmode')
            } else if(id == "reviveall") {
                this.playerSelected = false
                $("#app").fadeOut(500)
                this.postMessage('reviveall')
            } else if(id == "annuncio") {
                this.questionInfo = {
                    title : this.config.lang.annuncio,
                    color : '#a84432',
                    action : 'annuncio',
                    input1 : {
                        placeholder : this.config.lang.text,
                        type : 'text',
                    },
                }
                this.viewOneInput(true)
            } else if(id == "givemoneyall") {
                this.questionInfo = {
                    title : this.config.lang.give_money_all,
                    color : 'grey',
                    action : 'givemoneyall',
                    input1 : {
                        type : 'select',
                        options : [
                            {
                                label : this.config.lang.cash,
                                value : 'money'
                            },
                            {
                                label : this.config.lang.bank,
                                value : 'bank'
                            },
                            {
                                label : this.config.lang.black_money,
                                value : 'black_money'
                            }
                        ]
                    },
                    input2 : {
                        placeholder : this.config.lang.count,
                        type : 'text',
                    }
                }
                this.viewDoubleInput(true)
            } else if(id == "repairvehicle") {
                this.postMessage('repairvehicle')
                $("#app").fadeOut(500)
                this.playerSelected = false
                this.postMessage('close')
            }else if(id == "clearped") {
                this.postMessage('clearped', {
                    id : this.playerSelected.id
                })
                $("#app").fadeOut(500)
                this.playerSelected = false
                this.postMessage('close')
            } else if(id =="nomiplayer") {
                $("#app").fadeOut(500)
                this.postMessage("close")
                this.postMessage("nomiplayer")
            } else if(id =="cleararea") {
                this.questionInfo = {
                    title : this.config.lang.clear_area,
                    color : '#f569e5',
                    action : 'cleararea',
                    input1 : {
                        type : 'select',
                        options : this.radius
                    }
                }
                this.viewOneInput(true)
            }
        },

        confirmAction() {
            var action = this.questionInfo.action
            var value1 = $(".value1").val()
            var value2 = $(".value2").val()

            this.postMessage('action', {
                action : action,
                value1 : value1,
                value2 : value2,
                id : this.playerSelected.id
            })
            this.closeQuestion()
            $("#app").fadeOut(500)
            this.playerSelected = false
            this.postMessage('close')
        },

        updatePlayers(players) {
            this.listaPlayer = players
            if(this.playerSelected != false) {
                for(const[k,v] of Object.entries(players)) {
                    if(v.id == this.playerSelected.id) {
                        this.playerSelected = v
                    }
                }
            }

            for(const[k,v] of Object.entries(this.azioni)) {
                if(v.id == 'adminjail' && this.playerSelected.inJail) {
                    v.label = this.config.lang.unjail
                    v.id = 'unjail'
                } else if(v.id == 'unjail' && !this.playerSelected.inJail) {
                    v.label = this.labelAdminJail
                    v.id = 'adminjail'
                }


                if(v.id == 'freeze' && this.playerSelected.freezed) {
                    v.label = this.config.lang.unfreeze
                    v.id = 'sfreeze'
                } else if(v.id == 'sfreeze' && !this.playerSelected.freezed) {
                    v.label = this.labelFreeze
                    v.id = 'freeze'
                }
            }
        },

        
        viewList1(id) {
            this.listType = id
            this.viewList = true
        },

        deleteWarn(index) {
            this.postMessage('deletewarn', {
                id : this.playerSelected.id,
                index : index
            })
        },

        setConfig(config) {
            this.config = config
            this.config.lang = config.Lang[config.Language]

            for(const[k,v] of Object.entries(this.infoDashboard)) {
                if(v.id == 'adminonline') {
                    v.label = this.config.lang['staff_online']
                } 
                if(v.id == 'playeronline') {
                    v.label = this.config.lang['player_online']
                }
                if(v.id == 'totalban') {
                    v.label = this.config.lang['ban_totali']
                }
                if(v.id == 'totalkick') {
                    v.label = this.config.lang['kick_totali']
                }
            }
        },

        setAzioni(azioni) {
            this.azioni = azioni

            for(const[k,v] of Object.entries(this.azioni)) {
                if(v.id == 'adminjail') {
                    this.labelAdminJail = v.label
                }
                if(v.id == 'freeze') {
                    this.labelFreeze = v.label
                }
            }
        },

        setAzioniPersonale(azioni) {
            this.azioniPersonale = azioni
        },

        close() {
            $("#app").fadeOut(500)
            this.postMessage('close')
        },

        redirectPage(url) {
            window.invokeNative('openUrl', url)
        },

        getValue(id) {
            if(id == 'totalban') {
                return this.listaBan.length
            } else if(id == 'adminonline') {
                return this.adminOnline
            } else if(id == 'playeronline') {
                return this.listaPlayer.length
            } else if(id == 'totalkick') {
                return this.kickTotali
            }
        }
    }

});

window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === "OPEN") {
        app.updateSelectedOption('dashboard')
        app.updatePlayers(data.players)
        $("#app").fadeIn(500)
    } else if(data.type === "UPDATE_PLAYERS") {
        app.updatePlayers(data.players)
    } else if(data.type === "SET_CONFIG") {
        app.setConfig(data.config)
    } else if(data.type === "SET_AZIONI") {
        app.setAzioni(data.azioni)
    } else if(data.type === "SET_AZIONI_PERSONALE") {
        app.setAzioniPersonale(data.azioni)
    } else if(data.type === "SET_INFO_STAFF") {
        app.infoStaff = data.info
    } else if(data.type === "SET_JOBS") {
        app.jobs = data.jobs
    } else if(data.type === "SET_ORARIO") {
        app.orario = data.orario
    } else if(data.type === "SET_ADMIN_GROUPS") {
        app.adminGroups = []
        app.adminGroups.push({
            label : app.config.lang['utente'],
            value : app.config.GroupUser
        })
        for(const[k,v] of Object.entries(data.groups)) {
            v.value = v.id
            if(v.rank <= app.infoStaff.rank) {
                app.adminGroups.push(v)
            }
        }
    } else if(data.type === "RESUME") {
        $("#app").fadeIn(500)
    } else if(data.type === "SET_BAN") {
        app.listaBan = data.ban
    } else if(data.type === "SET_ADMIN_ONLINE") {
        app.adminOnline = data.admin
    } else if(data.type === "SHOW_ANNOUNCE") {
        $(".message").fadeIn(500)
        $(".titleMsg").html(app.config.lang.annuncio)
        $(".subtitleMsg").html(data.text)
        setTimeout(function() {
            $(".message").fadeOut(500)
        }, 9000)
    } else if(data.type === "SHOW_DM_MESSAGE") {
        $(".message").fadeIn(500)
        $(".titleMsg").html(app.config.lang.dmmessage)
        $(".subtitleMsg").html(data.text)
        setTimeout(function() {
            $(".message").fadeOut(500)
        }, 9000)
    } else if(data.type === "SET_KICKS") {
        app.kickTotali = data.kicks
    } else if(data.type === "SET_SERVER_LOGO") {
        var logo = document.getElementsByClassName("serverLogo")[0]
        logo.style.backgroundImage= 'url("'+data.logo+'")'
    } else if(data.type === "SET_RADIUS") {
        app.radius = data.radius
    }
})


document.onkeyup = function (data) {
    if (data.key == 'Escape' && app.optionSelected == 'infopersona' && !app.viewList) {
        app.updateSelectedOption('listaplayer')
        app.playerSelected = false
    } else if(data.key == 'Escape' && app.viewList) {
        app.viewList = false
    } else if(data.key == 'Escape') {
        app.close()
    }

};
