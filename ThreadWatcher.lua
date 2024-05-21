local ThreadWatcher = LibStub("AceAddon-3.0"):NewAddon("ThreadWatcher", "AceConsole-3.0")  
local AceGUI = LibStub("AceGUI-3.0")

Threads =
{
    -- item id, item name, thread count 
    experience = {
        { currency_id = 3001, stat_name = "% experience", thread_id = 217722, thread_name = "Thread of Experience", thread_count = 1 },
        { currency_id = 3001, stat_name = "% experience", thread_id = 219264, thread_name = "Temporal Thread of Experience", thread_count = 3 },
        { currency_id = 3001, stat_name = "% experience", thread_id = 219273, thread_name = "Perpetual Thread of Experience", thread_count = 7 },
        { currency_id = 3001, stat_name = "% experience", thread_id = 219282, thread_name = "Infinite Thread of Experience", thread_count = 12 }
    },

    power = {
        { currency_id = 2853, stat_name = "main stat", thread_id = 210982, thread_name = "Thread of Power", thread_count = 1 },
        { currency_id = 2853, stat_name = "main stat", thread_id = 219256, thread_name = "Temporal Thread of Power", thread_count = 3 },
        { currency_id = 2853, stat_name = "main stat", thread_id = 219265, thread_name = "Perpetual Thread of Power", thread_count = 7 },
        { currency_id = 2853, stat_name = "main stat", thread_id = 219274, thread_name = "Infinite Thread of Power", thread_count = 12 }
    },

    critical_strike = {
        { currency_id = 2855, stat_name = "crit chance", thread_id = 210984, thread_name = "Thread of Critical Strike", thread_count = 1 },
        { currency_id = 2855, stat_name = "crit chance", thread_id = 219258, thread_name = "Temporal Thread of Critical Strike", thread_count = 3 },
        { currency_id = 2855, stat_name = "crit chance", thread_id = 219267, thread_name = "Perpetual Thread of Critical Strike", thread_count = 7 },
        { currency_id = 2855, stat_name = "crit chance", thread_id = 219276, thread_name = "Infinite Thread of Critical Strike", thread_count = 12 }
    },

    haste = {
        { currency_id = 2856, stat_name = "haste", thread_id = 210985, thread_name = "Thread of Haste", thread_count = 1 },
        { currency_id = 2856, stat_name = "haste", thread_id = 219259, thread_name = "Temporal Thread of Haste", thread_count = 3 },
        { currency_id = 2856, stat_name = "haste", thread_id = 219268, thread_name = "Perpetual Thread of Haste", thread_count = 7 },
        { currency_id = 2856, stat_name = "haste", thread_id = 219277, thread_name = "Infinite Thread of Haste", thread_count = 12 }
    },

    leech = {
        { currency_id = 2857, stat_name = "leech", thread_id = 210987, thread_name = "Thread of Leech", thread_count = 1 },
        { currency_id = 2857, stat_name = "leech", thread_id = 219261, thread_name = "Temporal Thread of Leech", thread_count = 3 },
        { currency_id = 2857, stat_name = "leech", thread_id = 219270, thread_name = "Perpetual Thread of Leech", thread_count = 7 },
        { currency_id = 2857, stat_name = "leech", thread_id = 219279, thread_name = "Infinite Thread of Leech", thread_count = 12 }        
    },

    mastery = {
        { currency_id = 2858, stat_name = "mastery", thread_id = 210989, thread_name = "Thread of Mastery", thread_count = 1 },
        { currency_id = 2858, stat_name = "mastery", thread_id = 219262, thread_name = "Temporal Thread of Mastery", thread_count = 3 },
        { currency_id = 2858, stat_name = "mastery", thread_id = 219271, thread_name = "Perpetual Thread of Mastery", thread_count = 7 },
        { currency_id = 2858, stat_name = "mastery", thread_id = 219280, thread_name = "Infinite Thread of Mastery", thread_count = 12 }     
    },

    speed = {
        { currency_id = 2859, stat_name = "speed", thread_id = 210986, thread_name = "Thread of Speed", thread_count = 1 },
        { currency_id = 2859, stat_name = "speed", thread_id = 219260, thread_name = "Temporal Thread of Speed", thread_count = 3 },
        { currency_id = 2859, stat_name = "speed", thread_id = 219269, thread_name = "Perpetual Thread of Speed", thread_count = 7 },
        { currency_id = 2859, stat_name = "speed", thread_id = 219278, thread_name = "Infinite Thread of Speed", thread_count = 12 }        
    },

    stamina = {
        { currency_id = 2854, stat_name = "stamina", thread_id = 210983, thread_name = "Thread of Stamina", thread_count = 2 },
        { currency_id = 2854, stat_name = "stamina", thread_id = 219257, thread_name = "Temporal Thread of Stamina", thread_count = 6 },
        { currency_id = 2854, stat_name = "stamina", thread_id = 219266, thread_name = "Perpetual Thread of Stamina", thread_count = 14 },
        { currency_id = 2854, stat_name = "stamina", thread_id = 219275, thread_name = "Infinite Thread of Stamina", thread_count = 24 }        
    },

    versatility = {
        { currency_id = 2860, stat_name = "versatility", thread_id = 210990, thread_name = "Thread of Versatility", thread_count = 1 },
        { currency_id = 2860, stat_name = "versatility", thread_id = 219263, thread_name = "Temporal Thread of Versatility", thread_count = 3 },
        { currency_id = 2860, stat_name = "versatility", thread_id = 219272, thread_name = "Perpetual Thread of Versatility", thread_count = 7 },
        { currency_id = 2860, stat_name = "versatility", thread_id = 219281, thread_name = "Infinite Thread of Versatility", thread_count = 12 }
    },

    bronze = {
        { currency_id = 2778, stat_name = "Bronze", thread_id = 217174, thread_name = "Bronze", thread_count = -1 }
    }
}
local event_frame = CreateFrame("EventFrame", "ThreadWatcher")
event_frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
event_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
event_frame:RegisterEvent("ADDON_LOADED")

local start_time = 0
local elapsed_paused_time = 0
local timer_active = false
local pause_start_time = 0

function StartTick()
    start_time = 0
    elapsed_paused_time = 0
    timer_active = true
    pause_start_time = 0
    start_time = time()
end

function PauseTick()
    if timer_active then
        pause_start_time = time()
        timer_active = false
    end
end

function ResumeTick()
    if not timer_active then
        elapsed_paused_time = elapsed_paused_time + (time() - pause_start_time)
        timer_active = true
    end
end

function StopTick()
    elapsed_paused_time = 0
    timer_active = false
    pause_start_time = 0
end

function ElapsedTick()
    if timer_active then
        return time() - start_time - elapsed_paused_time
    else
        return pause_start_time - start_time - elapsed_paused_time
    end
end
local frame = AceGUI:Create("Frame")
local function UpdateTimerDisplay(elapsedTime)
    local seconds = math.floor(elapsedTime % 60)
    local minutes = math.floor((elapsedTime / 60) % 60)
    local hours = math.floor(elapsedTime / 3600)
    frame:SetStatusText(string.format("%02d:%02d:%02d", hours, minutes, seconds))
end


frame:SetTitle("ThreadWatcher")
frame:SetWidth(425)
frame:SetHeight(200)
frame:SetLayout("Flow")
frame.frame:SetScript("OnUpdate", function(elapsed)
    if timer_active == true then
        UpdateTimerDisplay(ElapsedTick())
    end
end)
frame:Hide()

local inlineGroup = AceGUI:Create("InlineGroup")
inlineGroup:SetFullWidth(true)
inlineGroup:SetFullHeight(true)
inlineGroup:SetLayout("Flow")

local startButton = AceGUI:Create("Button")
startButton:SetText("Start")
startButton:SetCallback("OnClick", function()
    if timer_active == false and start_time == 0 then
        StartTick()
        startButton:SetText("Pause")
    elseif timer_active == false and start_time ~= 0 then
        ResumeTick()
        startButton:SetText("Pause")
    elseif timer_active == true then
        PauseTick()
        startButton:SetText("Resume")
    end
end)
startButton:SetAutoWidth(true)
frame:AddChild(startButton)


local dump_button = AceGUI:Create("Button")
dump_button:SetText("Dump Results")
dump_button:SetCallback("OnClick", function() 
    DumpThreadResults()
end)
dump_button:SetAutoWidth(true)
frame:AddChild(dump_button)


local optionsButton = AceGUI:Create("Button")
optionsButton:SetText("Options")
optionsButton:SetCallback("OnClick", function()
    InterfaceOptionsFrame_OpenToCategory("ThreadWatcher")
end)
optionsButton:SetAutoWidth(true)
frame:AddChild(optionsButton)


local stopButton = AceGUI:Create("Button")
stopButton:SetText("Stop")
stopButton:SetCallback("OnClick", function()
    startButton:SetText("Start")
    DumpThreadResults()
    StopTick()
    lootList = {}
    UpdateLootDisplay()
    frame:SetStatusText("00:00:00")
end)
stopButton:SetAutoWidth(true)
frame:AddChild(stopButton)

frame:AddChild(inlineGroup)

local lootList = {}

function table.empty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

local button_frame_pool = CreateFramePool("Button")
local fontStringsCreated = {}

local function UpdateLootDisplay()
    inlineGroup:ReleaseChildren()


    local offset = 0
    for i, loot in pairs(lootList) do
        local lootText = AceGUI:Create("Label")
        if loot.stat_name == "Bronze" then
            lootText:SetText(loot.item_link .. " x" .. loot.amount)
        else
            lootText:SetText(loot.item_link .. " x" .. loot.amount .. " (+" .. loot.thread_count .. " " .. loot.stat_name .. ")")
        end
        lootText:SetFullWidth(true)

        inlineGroup:AddChild(lootText)
    end
end

local function AddThread(item, item_link, thread_table, quantity)
    -- get total thread count
    -- [item] x[amount] (+thread name)
    -- example: [Thread of Stanima] x5 (+5 stanima)
    if lootList[item] == nil then
        local inital_amount = 1

        if thread_table.stat_name == "Bronze" then
            inital_amount = quantity
        end
        lootList[item] = {
            item_link = item_link,
            stat_name = thread_table.stat_name,
            thread_count = thread_table.thread_count,
            amount = inital_amount,
        }
    elseif lootList[item] ~= nil then
        local amount = 1

        if thread_table.stat_name == "Bronze" then
            amount = quantity
        end
        lootList[item].amount = lootList[item].amount + amount
        lootList[item].thread_count = lootList[item].thread_count + thread_table.thread_count
    end
    UpdateLootDisplay()
end

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

function DumpThreadResults() 
    local most_threads = 0
    local total_threads = 0
    local thread_counts = {}
    local item_count = 0
    local most_item = 0
    local most_item_link = ""
    local bronze = 0
    for i, loot in pairs(lootList) do
        if thread_counts[loot.stat_name] == nil then
            thread_counts[loot.stat_name] = 0
        end
        
        if loot.stat_name ~= "Bronze" then
            thread_counts[loot.stat_name] = loot.thread_count + thread_counts[loot.stat_name]
            total_threads = total_threads + loot.thread_count

            item_count = item_count + 1

            if most_item < loot.amount then
                most_item = loot.amount
                most_item_link = loot.item_link
            end
        else
            bronze = loot.amount
        end
    end

    for name, threads in pairs(thread_counts) do
        if most_threads < threads then
            most_threads = threads
        end
    end

    local elapsedTime = ElapsedTick()
    local seconds = math.floor(elapsedTime % 60)
    local minutes = math.floor((elapsedTime / 60) % 60)
    local hours = math.floor(elapsedTime / 3600)
    local minutes_conv = math.floor((elapsedTime / 60) % 60) + math.floor(elapsedTime / 3600) * 60 + math.floor(elapsedTime % 60 / 60)
    

    if bronze ~= 0 then
        ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r bronze in |cFFFFFF00%s|r!", bronze, TimeToString(elapsedTime)))
        if minutes > 0 or hours > 0 then
            ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r bronze every minute!", bronze / minutes_conv))
        else
            ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r bronze every second!", bronze / seconds))
        end
    end

    if total_threads > 0 and most_item_link ~= "" then
        ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r stat upgrades in |cFFFFFF00%s|r!", total_threads, TimeToString(elapsedTime)))
        ThreadWatcher:Print(string.format("Your most common thread drop was %s for |cFF00FF00%i|r stat upgrades!", most_item_link, most_threads))
        
        if minutes > 0 or hours > 0 then
            local threads_per_min = total_threads / minutes_conv
            local item_drops = item_count / minutes_conv
            ThreadWatcher:Print(string.format("You gained |cFF00FF00%0.2f|r stat upgrades or |cFF00FF00%0.2f|r thread drops every minute!", threads_per_min, item_drops))
        else
            local threads_per_sec = total_threads / seconds
            local item_drops = item_count / seconds
            ThreadWatcher:Print(string.format("You gained |cFF00FF00%0.2f|r stat upgrades or |cFF00FF00%0.2f|r thread drops every second!", threads_per_sec, item_drops))
        end
    end
end

First_open = true
function ThreadWatcher:ThreadCommand()
    if First_open == true then
        StartTick()
        startButton:SetText("Pause")
        self:Print("Session started.")
    end
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
    First_open = false
end

local function eventHandler(self, event, ...) 
    if event == "CURRENCY_DISPLAY_UPDATE" and timer_active == true then 
        local currencyType, quantity, quantityChange, quantityGainSource, quantityLostSource = ...;
        for i, thread in pairs(Threads) do 
            for thread_table_name, thread_table in pairs(thread) do
                if thread_table.currency_id == currencyType and (thread_table.thread_count == quantityChange or thread_table.thread_count == -1) then
                    local item = Item:CreateFromItemID(thread_table.thread_id)

                    item:ContinueOnItemLoad(function()
                        AddThread(thread_table.thread_id, item:GetItemLink(), thread_table, quantityChange)
                    end)
                    
                end
            end
        end
    end
end
event_frame:SetScript("OnEvent", eventHandler)

local threadwatcherStub = LibStub("LibDataBroker-1.1"):NewDataObject("ThreadWatcher", {  
	type = "launcher",  
	text = "ThreadWatcher",  
	icon = "Interface\\Icons\\inv_10_tailoring_embroiderythread_color1",  
	OnClick = function()
        ThreadWatcher:ThreadCommand()
    end,
    OnTooltipShow = function (tooltip)
        tooltip:AddLine("ThreadWatcher")
        tooltip:AddLine("|cFFFFFF00Click|r to open the window")        
        if timer_active ~= false then
            local seconds = math.floor(elapsedTime % 60)
            local minutes = math.floor((elapsedTime / 60) % 60)
            local hours = math.floor(elapsedTime / 3600)
            tooltip:AddLine(string.format("Session running for %02d:%02d:%02d", hours, minutes, seconds))
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
		},
	},
}

function ThreadWatcher:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ThreadWatcherDB", {
		profile = {
			minimap = {
				hide = false,
			},
            start_on_launch = false
		},
	})
	icon:Register("ThreadWatcher", threadwatcherStub, self.db.profile.minimap)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("ThreadWatcher", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ThreadWatcher", "ThreadWatcher")
    self:RegisterChatCommand("threadwatcher", "ThreadCommand")

    self:Print("ThreadWatcher loaded! Use the minimap icon or |cFFFFFF00/threadwatcher|r to open the ThreadWatcher window!")
    if self.db.profile.start_on_launch == true then
        self:Print("Starting session.")
        timer_active = true
        startButton:SetText("Pause")
    end
end

function ThreadWatcher:GetSessionStartup(info)
    return self.db.profile.start_on_launch
end

function ThreadWatcher:SetSessionStartup(info, value)
    self.db.profile.start_on_launch = value
end