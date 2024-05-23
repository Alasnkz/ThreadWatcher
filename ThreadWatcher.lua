ThreadWatcher = LibStub("AceAddon-3.0"):NewAddon("ThreadWatcher", "AceConsole-3.0")  
AceGUI = LibStub("AceGUI-3.0")

function TimeToString(elapsedTime)
    local seconds = math.floor(elapsedTime % 60)
    local minutes = math.floor((elapsedTime / 60) % 60)
    local hours = math.floor(elapsedTime / 3600)
    
    local timeParts = {}
    
    if hours > 0 then
        table.insert(timeParts, string.format("%d hour%s", hours, hours ~= 1 and "s" or ""))
    end
    
    if minutes > 0 then
        table.insert(timeParts, string.format("%d minute%s", minutes, minutes ~= 1 and "s" or ""))
    end
    
    if seconds > 0 then
        table.insert(timeParts, string.format("%d second%s", seconds, seconds ~= 1 and "s" or ""))
    end
    
    local formattedTime = table.concat(timeParts, ", ")
    
    return formattedTime
end

function ThreadWatcher:ThreadCommand()
    if ThreadWatcher.session.HadSession() == false and ThreadWatcher.session.IsTimerActive() == false then
        ThreadWatcher.session.StartSession()
        ThreadWatcher.GUI.start_button:SetText("Pause")
    end
    if ThreadWatcher.GUI.main_frame:IsShown() then
        ThreadWatcher.GUI.main_frame:Hide()
    else
        ThreadWatcher.GUI.main_frame:Show()
    end
    First_open = false
end

local threadwatcherStub = LibStub("LibDataBroker-1.1"):NewDataObject("ThreadWatcher", {  
	type = "launcher",  
	text = "ThreadWatcher", 
	icon = "Interface\\Icons\\inv_10_tailoring_embroiderythread_color1",  
	OnClick = function(displayFrame, buttonName)
        if buttonName == "RightButton" then
            InterfaceOptionsFrame_OpenToCategory("ThreadWatcher")
        else
            ThreadWatcher:ThreadCommand()
        end
    end,
    OnTooltipShow = function (tooltip)
        tooltip:AddLine("ThreadWatcher")
        tooltip:AddLine("|cFFFFFF00Click|r to open the window")        
        tooltip:AddLine("|cFFFFFF00Right click|r to open the options window")
        if ThreadWatcher.session.IsInSession() == true then
            local elapsedTime = ThreadWatcher.session.ElapsedTick()
            local seconds = math.floor(elapsedTime % 60)
            local minutes = math.floor((elapsedTime / 60) % 60)
            local hours = math.floor(elapsedTime / 3600)
            tooltip:AddLine(string.format("Session running for %02d:%02d:%02d", hours, minutes, seconds))

            if ThreadWatcher.session.IsTimerActive() == false then
                tooltip:AddLine("Session is currently |cFFFF0000paused|r")
            end 
        end
    end,  
})  
local icon = LibStub("LibDBIcon-1.0")  

local options = { 
	name = "ThreadWatcher",
	handler = ThreadWatcher,
	type = "group",
	args = {
		msg = {
			type = "toggle",
			name = "Session startup",
			desc = "Run a session on addon startup straight away.",
			get = "GetSessionStartup",
			set = "SetSessionStartup",
            order = 1,
		},
        new_session_each_instance = {
            width = "full",
            disabled = true,
            type = "toggle",
            name = "New session each instance",
            desc = "Run a new session every time an instance entry is detected.\nWill automatically stop the session once out of the instance.",
            get = "GetNewSessionInstanceToggle",
            set = "SetNewSessionInstanceToggle"
        },
        toggle_round_minute = {
            width = "full",
            type = "toggle",
            name = "Round to minute",
            desc = "Set to whether round a session under 60 seconds to a minute.",
            get = "GetRoundMinuteSetting",
            set = "SetRoundMinuteSetting"
        },
        bronze = {
            name = "Bronze Options",
            type = "group",
            args = {
                toggle_bronze_track = {
                    width = "full",
                    type = "toggle",
                    name = "Bronze tracking",
                    desc = "Enable or disable tracking bronze.",
                    get = "GetBronzeTrackingSetting",
                    set = "SetBronzeTrackingSetting",
                    order = 1,
                },
                
                toggle_bronze_dump = {
                    width = "full",
                    type = "toggle",
                    name = "Bronze dump output",
                    desc = "Enable or disable dumping bronze information.\nExamples include: amount made in the session, and the average amount made in a minute.",
                    get = "GetBronzeDumpSetting",
                    set = "SetBronzeDumpSetting"
                }
            }
        },
        charms = {
            name = "Lesser Charms Options",
            type = "group", 
            args = {
                toggle_lesser_charms_track = {
                    width = "full",
                    type = "toggle",
                    name = "Lesser Charms tracking",
                    desc = "Enable or disable tracking Lesser Charms of Good Fortune.",
                    get = "GetCharmsTrackingSetting",
                    set = "SetCharmsTrackingSetting",
                    order = 1,
                },
                
                toggle_lesser_charms_dump = {
                    width = "full",
                    type = "toggle",
                    name = "Lesser Charms dump output",
                    desc = "Enable or disable dumping Lesser Chamrs of Good Fortune information.\nExamples include: amount made in the session, and the average amount made in a minute.",
                    get = "GetCharmsDumpSetting",
                    set = "SetCharmsDumpSetting"
                }
            }
        },
        gems = {
            name = "Gem Options",
            type = "group",
            args = {
                toggle_gems_track = {
                    width = "full",
                    type = "toggle",
                    name = "Gem tracking",
                    desc = "Enable or disable tracking |cFFFF0000tier 1|r gems.",
                    get = "GetGemsTrackingSetting",
                    set = "SetGemsTrackingSetting",
                    order = 1
                },
                toggle_gems_dump = {
                    width = "full",
                    type = "toggle",
                    name = "Gem dump output",
                    desc = "Enable or disable dumping |cFFFF0000tier 1|r gems information.\nExamples include: amount made in the session, and the average amount made in a minute.",
                    get = "GetGemsDumpSetting",
                    set = "SetGemsDumpSetting",
                }
            }
        },
        gear = {
            name = "Gear Options",
            type = "group",
            args = {
                toggle_gear_track = {
                    width = "full",
                    type = "toggle",
                    name = "Gear tracking",
                    desc = "Enable or disable tracking gear (weapons & armour).",
                    get = "GetGearTrackingSetting",
                    set = "SetGearTrackingSetting",
                    order = 1
                },
                toggle_gear_dump = {
                    width = "full",
                    type = "toggle",
                    name = "Gear dump output",
                    desc = "Enable or disable dumping gear information.\nExamples include: amount made in the session, and the average amount made in a minute.",
                    get = "GetGearDumpSetting",
                    set = "SetGearDumpSetting"
                }
            }
        }
	},
}

function ThreadWatcher:ThreadTest()
    for i, thread in pairs(Threads) do 
        for index, thread_table in pairs(thread) do
            print(thread)
            local item = Item:CreateFromItemID(thread_table.thread_id)

            eventHandler(event_frame, "CURRENCY_DISPLAY_UPDATE", thread_table.currency_id, 100, thread_table.thread_count, 13, 13)
            eventHandler(event_frame, "CURRENCY_DISPLAY_UPDATE", thread_table.currency_id, 100, thread_table.thread_count, 13, 13)
        end
    end
end

function ThreadWatcher:CurrencyTest()
    --  currencyType, quantity, quantityChange, quantityGainSource, quantityLostSource = ...;
    -- { currency_id = 738, stat_name = "Lesser Charm of Good Fortune", thread_id = 217174, thread_name = "Lesser Charm of Good Fortune", thread_count = -1, is_currency = true }
    -- local text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons = ...;
        
    eventHandler(event_frame, "CURRENCY_DISPLAY_UPDATE", 738, 100, 4232, 13, 13)
    eventHandler(event_frame, "CURRENCY_DISPLAY_UPDATE", 2778, 100, 49693, 13, 13)
end

function ThreadWatcher:GemTest()
    for i, gem in pairs(Items.gems) do
        print(string.format("You receive loot: |cffffffff|Hitem:%i::::::::20:257::::::|h[Linen Cloth]|h|rx294", gem.thread_id))
        eventHandler(event_frame, "CHAT_MSG_LOOT", string.format("You receive loot: |cffffffff|Hitem:%i::::::::20:257::::::|h[Linen Cloth]|h|rx294", gem.thread_id), "", "", "", "", 0, 0, 0, 0, 0, 0, PlayerGUID, 0, 0, 0, 0, 0)
    end

    eventHandler(event_frame, "CHAT_MSG_LOOT", string.format("You receive loot: |cffffffff|Hitem:198695::::::::20:257::::::|h[Linen Cloth]|h|rx294"), "", "", "", "", 0, 0, 0, 0, 0, 0, PlayerGUID, 0, 0, 0, 0, 0)
    eventHandler(event_frame, "CHAT_MSG_LOOT", string.format("You receive loot: |cffffffff|Hitem:193760::::::::20:257::::::|h[Linen Cloth]|h|rx294"), "", "", "", "", 0, 0, 0, 0, 0, 0, PlayerGUID, 0, 0, 0, 0, 0)
    eventHandler(event_frame, "CHAT_MSG_LOOT", string.format("You receive loot: |cffffffff|Hitem:190502::::::::20:257::::::|h[Linen Cloth]|h|rx294"), "", "", "", "", 0, 0, 0, 0, 0, 0, PlayerGUID, 0, 0, 0, 0, 0)
end
function ThreadWatcher:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ThreadWatcherDB", {
		profile = {
			minimap = {
				hide = false,
			},
            
            start_on_launch = false,
            new_session_each_instance = false,
            round_to_minute = true,

            bronze = {
                track_bronze = true,
                dump_bronze_info = true
            },

            lesser_charms = {
                track_charms = true,
                dump_charm_info = false
            },

            gems = {
                track_gems = true,
                dump_gem_info = false
            },

            gear = {
                track_gear = false,
                dump_gear_info = false,
            },

            sessions = {}
		},
	})
	icon:Register("ThreadWatcher", threadwatcherStub, self.db.profile.minimap)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("ThreadWatcher", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ThreadWatcher", "ThreadWatcher")
    self:RegisterChatCommand("threadwatcher", "ThreadCommand")
    --self:RegisterChatCommand("threadtest", "ThreadTest")
    --self:RegisterChatCommand("currencytest", "CurrencyTest")
    --self:RegisterChatCommand("gemtest", "GemTest")
    self:Print("ThreadWatcher loaded! Use the minimap icon or |cFFFFFF00/threadwatcher|r to open the ThreadWatcher window!")
    if self.db.profile.start_on_launch == true then
        ThreadWatcher.session.StartSession()
        ThreadWatcher.GUI.start_button:SetText("Pause")
    end

    if self.db.profile.sessions[0] ~= nil then
        --ThreadWatcher.session.loot.loot_list = self.db.profile.sessions[0].loot_list
        --ThreadWatcher.session.loot.UpdateLootDisplay()
    end
end

function ThreadWatcher:GetSessionStartup(info)
    return self.db.profile.start_on_launch
end

function ThreadWatcher:SetSessionStartup(info, value)
    self.db.profile.start_on_launch = value
end


function ThreadWatcher:GetNewSessionInstanceToggle(info)
    return self.db.profile.new_session_each_instance
end

function ThreadWatcher:SetNewSessionInstanceToggle(info, value)
    self.db.profile.new_session_each_instance = value
end

function ThreadWatcher:GetRoundMinuteSetting(info)
    return self.db.profile.round_to_minute
end

function ThreadWatcher:SetRoundMinuteSetting(info, value)
    self.db.profile.round_to_minute = value
end

---------------------------------------------- BRONZE
function ThreadWatcher:GetBronzeTrackingSetting(info)
    return self.db.profile.bronze.track_bronze
end

function ThreadWatcher:SetBronzeTrackingSetting(info, value)
    self.db.profile.bronze.track_bronze = value
end

function ThreadWatcher:GetBronzeDumpSetting(info)
    return self.db.profile.bronze.dump_bronze_info
end

function ThreadWatcher:SetBronzeDumpSetting(info, value)
    self.db.profile.bronze.dump_bronze_info = value
end

----------------------------------------- CHARMS
function ThreadWatcher:GetCharmsTrackingSetting(info)
    return self.db.profile.lesser_charms.track_charms
end

function ThreadWatcher:SetCharmsTrackingSetting(info, value)
    self.db.profile.lesser_charms.track_charms = value
end

function ThreadWatcher:GetCharmsDumpSetting(info)
    return self.db.profile.lesser_charms.dump_charm_info
end

function ThreadWatcher:SetCharmsDumpSetting(info, value)
    self.db.profile.lesser_charms.dump_charm_info = value
end

-------------------------------------------- GEMS
function ThreadWatcher:GetGemsTrackingSetting(info)
    return self.db.profile.gems.track_gems
end

function ThreadWatcher:SetGemsTrackingSetting(info, value)
    self.db.profile.gems.track_gems = value
end

function ThreadWatcher:GetGemsDumpSetting(info)
    return self.db.profile.gems.dump_gem_info
end

function ThreadWatcher:SetGemsDumpSetting(info, value)
    self.db.profile.gems.dump_gem_info = value
end

---------------------------------------------- GEAR
function ThreadWatcher:GetGearTrackingSetting(info) 
    return self.db.profile.gear.track_gear
end

function ThreadWatcher:SetGearTrackingSetting(info, value)
    self.db.profile.gear.track_gear = value
end

function ThreadWatcher:GetGearDumpSetting(info)
    return self.db.profile.gear.dump_gear_info
end

function ThreadWatcher:SetGearDumpSetting(info, value)
    self.db.profile.gear.dump_gear_info = value
end