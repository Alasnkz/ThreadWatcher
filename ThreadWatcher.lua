local ThreadWatcher = LibStub("AceAddon-3.0"):NewAddon("ThreadWatcher", "AceConsole-3.0")  
local AceGUI = LibStub("AceGUI-3.0")
local lootList = {}

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
        { currency_id = 2778, stat_name = "Bronze", thread_id = 217174, thread_name = "Bronze", thread_count = -1, is_currency = true }
    },

    lesser_charm_of_good_fortune = {
        { currency_id = 738, stat_name = "Lesser Charm of Good Fortune", thread_id = 90458, thread_name = "Lesser Charm of Good Fortune", thread_count = -1, is_currency = true, item_link = "|cFFFFFFFF|Hcurrency:738|h[Lesser Charm of Good Fortune]|h|r" }
    },
}

Items = {
    gems = {
        { currency_id = 0, stat_name = "Chipped Masterful Amethyst", thread_id = 210715, thread_name = "Chipped Masterful Amethyst", thread_count = -1, is_gem = true },
        { currency_id = 0, stat_name = "Chipped Deadly Sapphire", thread_id = 210714, thread_name = "Chipped Deadly Sapphire", thread_count = -1, is_gem = true },
        { currency_id = 0, stat_name = "Chipped Quick Topaz", thread_id = 210681, thread_name = "Chipped Quick Topaz", thread_count = -1, is_gem = true },
        { currency_id = 0, stat_name = "Chipped Versatile Diamond", thread_id = 220371, thread_name = "Chipped Versatile Diamond", thread_count = -1, is_gem = true },
        { currency_id = 0, stat_name = "Chipped Stalwart Pearl", thread_id = 220367, thread_name = "Chipped Stalwart Pearl", thread_count = -1, is_gem = true },
        { currency_id = 0, stat_name = "Chipped Sustaining Emerald", thread_id = 211109, thread_name = "Chipped Sustaining Emerald", thread_count = -1, is_gem = true },
        { currency_id = 0, stat_name = "Chipped Hungering Ruby", thread_id = 210717, thread_name = "Chipped Hungering Ruby", thread_count = -1, is_gem = true },
        { currency_id = 0, stat_name = "Chipped Swift Opal", thread_id = 210716, thread_name = "Chipped Swift Opal", thread_count = -1, is_gem = true },
    }
}

local event_frame = CreateFrame("EventFrame", "ThreadWatcher")
event_frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
event_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
event_frame:RegisterEvent("CHAT_MSG_LOOT")
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
    start_time = 0
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

local scrollFrame = AceGUI:Create("ScrollFrame")
scrollFrame:SetFullWidth(true)
scrollFrame:SetFullHeight(true)
scrollFrame:SetLayout("Flow")


local inlineGroup = AceGUI:Create("InlineGroup")
inlineGroup:SetFullWidth(true)
inlineGroup:SetFullHeight(true)
inlineGroup:SetLayout("Flow")
scrollFrame:AddChild(inlineGroup)

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

local function UpdateLootDisplay()
    inlineGroup:ReleaseChildren()
    local offset = 0
    for i, loot in pairs(lootList) do
        local lootText = AceGUI:Create("Label")
        if loot.is_currency == true then
            lootText:SetText(loot.item_link .. " x" .. loot.amount)
        elseif loot.is_gem == true then
            lootText:SetText(loot.item_link .. " x" .. loot.amount .. " (+" .. loot.amount * 10 .. " bronze)")
        elseif loot.is_special == true then
            lootText:SetText(loot.item_link .. " x" .. loot.amount)
        else
            lootText:SetText(loot.item_link .. " x" .. loot.amount .. " (+" .. loot.thread_count .. " " .. loot.stat_name .. ")")
        end
        lootText:SetFullWidth(true)

        inlineGroup:AddChild(lootText)
    end
    inlineGroup:DoLayout()
    scrollFrame:DoLayout()
end

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

frame:AddChild(scrollFrame)

function table.empty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end

local button_frame_pool = CreateFramePool("Button")
local fontStringsCreated = {}

local function AddThread(item, item_link, thread_table, quantity)
    -- get total thread count
    -- [item] x[amount] (+thread name)
    -- example: [Thread of Stanima] x5 (+5 stanima)
    if lootList[item] == nil then
        local inital_amount = 1
        local currency = false
        local gem = false
        local special = false
        if thread_table.is_currency == true or thread_table.is_gem == true or thread_table.is_special == true then
            inital_amount = quantity
            currency = thread_table.is_currency ~= nil
            gem = thread_table.is_gem ~= nil
            special = thread_table.is_special ~= nil
        end
        lootList[item] = {
            is_currency = currency,
            is_gem = gem,
            is_special = special,
            item_link = item_link,
            stat_name = thread_table.stat_name,
            thread_count = thread_table.thread_count,
            amount = inital_amount,
        }
    elseif lootList[item] ~= nil then
        local amount = 1

        if thread_table.is_currency == true or thread_table.is_gem == true or thread_table.is_special == true then
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

LOOT_NUM_GEM = 1
LOOT_NUM_UNCOMMON_GEAR = 2
LOOT_NUM_RARE_GEAR = 3
LOOT_NUM_EPIC_GEAR = 4

function DumpThreadResults() 
    local most_item_threads = 0
    local most_item_stat = ""
    local total_threads = 0
    local thread_counts = {}
    local item_count = 0
    local most_item = 0
    local most_item_link = ""
    local bronze = 0
    local charms = 0
    local gems = 0
    for i, loot in pairs(lootList) do
        if thread_counts[loot.stat_name] == nil then
            thread_counts[loot.stat_name] = 0
        end
        
        if loot.is_currency ~= true and loot.is_special ~= true and loot.is_gem ~= true then
            thread_counts[loot.stat_name] = loot.thread_count + thread_counts[loot.stat_name]
            total_threads = total_threads + loot.thread_count

            item_count = item_count + 1

            if most_item < loot.amount then
                most_item = loot.amount
                most_item_link = loot.item_link
                most_item_threads = loot.thread_count
                most_item_stat = loot.stat_name
            end
        elseif loot.is_currency == true then
            if loot.stat_name == "Bronze" then 
                bronze = loot.amount
            elseif loot.stat_name == "Lesser Charm of Good Fortune" then
                charms = loot.amount
            end
        end
    end

    local elapsedTime = ElapsedTick()
    local seconds = math.floor(elapsedTime % 60)
    local minutes = math.floor((elapsedTime / 60) % 60)
    local hours = math.floor(elapsedTime / 3600)
    local minutes_conv = math.floor((elapsedTime / 60) % 60) + math.floor(elapsedTime / 3600) * 60 + math.floor(elapsedTime % 60 / 60)
    

    if bronze ~= 0 and ThreadWatcher.db.profile.bronze.dump_bronze_info == true then
        ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r bronze in |cFFFFFF00%s|r!", bronze, TimeToString(elapsedTime)))
        if minutes > 0 or hours > 0 then
            ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r bronze every minute!", bronze / minutes_conv))
        else
            ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r bronze every second!", bronze / seconds))
        end
    end

    if charms ~= 0 and ThreadWatcher.db.profile.lesser_charms.dump_charm_info == true then
        ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r lesser charms in |cFFFFFF00%s|r!", charms, TimeToString(elapsedTime)))
        if minutes > 0 or hours > 0 then
            ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r lesser charms every minute!", charms / minutes_conv))
        else
            ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r lesser charms every second!", charms / seconds))
        end
    end

    -- GEMS
    local gem_data = lootList[LOOT_NUM_GEM]
    if gem_data ~= nil and gem_data.amount ~= 0 and ThreadWatcher.db.profile.gems.dump_gem_info == true then
        ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r tier 1 gems (+%i bronze) in |cFFFFFF00%s|r!", gem_data.amount, gem_data.amount * 10, TimeToString(elapsedTime)))
        if minutes > 0 or hours > 0 then
            ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r gems (+%i bronze) every minute!", gem_data.amount / minutes_conv, (gem_data.amount / minutes_conv) * 10))
        else
            ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r gems (+%i bronze) every second!", gem_data.amount / seconds, (gem_data.amount / seconds) * 10))
        end
    end
    -- END

    -- GEAR
    if ThreadWatcher.db.profile.gear.dump_gear_info == true then
        local uncommon_gear = lootList[LOOT_NUM_UNCOMMON_GEAR]
        local rare_gear = lootList[LOOT_NUM_RARE_GEAR]
        local epic_gear = lootList[LOOT_NUM_EPIC_GEAR]

        if uncommon_gear ~= nil and uncommon_gear.amount ~= 0 then
            ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r uncommon gear drops in |cFFFFFF00%s|r!", uncommon_gear.amount, TimeToString(elapsedTime)))
            if minutes > 0 or hours > 0 then
                ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r uncommon gear drops every minute!", uncommon_gear.amount / minutes_conv))
            else
                ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r uncommon gear drops every second!", uncommon_gear.amount / seconds))
            end
        end

        if rare_gear ~= nil and rare_gear.amount ~= 0 then 
            ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r rare gear drops in |cFFFFFF00%s|r!", rare_gear.amount, TimeToString(elapsedTime)))
            if minutes > 0 or hours > 0 then
                ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r rare gear drops every minute!", rare_gear.amount / minutes_conv))
            else
                ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r rare gear drops every second!", rare_gear.amount / seconds))
            end
        end

        if epic_gear ~= nil and epic_gear.amount ~= 0 then 
            ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r epic gear drops in |cFFFFFF00%s|r!", epic_gear.amount, TimeToString(elapsedTime)))
            if minutes > 0 or hours > 0 then
                ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r epic gear drops every minute!", epic_gear.amount / minutes_conv))
            else
                ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r epic gear drops every second!", epic_gear.amount / seconds))
            end
        end
    end
    -- END

    if total_threads > 0 and most_item_link ~= "" then
        ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r stat upgrades in |cFFFFFF00%s|r!", total_threads, TimeToString(elapsedTime)))
        ThreadWatcher:Print(string.format("Your most common thread drop was %s for |cFF00FF00%i|r %s upgrades!", most_item_link, most_item_threads, most_item_stat))
        
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
    if First_open == true and timer_active == false then
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

PlayerGUID = UnitGUID("player")
local function eventHandler(self, event, ...) 
    if event == "CURRENCY_DISPLAY_UPDATE" and timer_active == true then 
        local currencyType, quantity, quantityChange, quantityGainSource, quantityLostSource = ...;

        if currencyType == nil or quantityChange == nil or quantityChange < 0 then
            return
        end
        for i, thread in pairs(Threads) do 
            for index, thread_table in pairs(thread) do
                if thread_table.currency_id == currencyType and (thread_table.thread_count == quantityChange or thread_table.thread_count == -1) then
                    
                    if thread_table.thread_name == "Bronze" and ThreadWatcher.db.profile.bronze.track_bronze == false then
                        return
                    elseif thread_table.thread_name == "Lesser Charm of Good Fortune" and ThreadWatcher.db.profile.lesser_charms.track_charms == false then
                        return
                    end

                    -- Some currencies, like Lesser Charms don't have an item associated with it.
                    if thread_table.item_link == nil then
                        local item = Item:CreateFromItemID(thread_table.thread_id)
                        item:ContinueOnItemLoad(function()
                            AddThread(thread_table.thread_id, item:GetItemLink(), thread_table, quantityChange)
                        end)
                    else
                        AddThread(thread_table.thread_id, thread_table.item_link, thread_table, quantityChange)
                    end
                elseif quantityChange > thread_table.thread_count and thread_table.currency_id == currencyType and index >= 4 then
                    local remaining = quantityChange
                    local result = {}

                    table.sort(thread, function(a, b) return a.thread_count > b.thread_count end)

                    for _, t in ipairs(thread) do
                        if t.thread_count <= remaining and t.thread_count > 0 then
                            local count = math.floor(remaining / t.thread_count)
                            remaining = remaining - (count * t.thread_count)
                            result[t.thread_id] = { count = count, thread_table = t }
                        end
                    end

                    for thread_id, remain_table in pairs(result) do
                        local item = Item:CreateFromItemID(thread_id)
                        item:ContinueOnItemLoad(function()
                            for _ = 1, remain_table.count do
                                AddThread(thread_id, item:GetItemLink(), remain_table.thread_table, 1)
                            end
                        end)
                    end
                end
            end
        end
    elseif event == "CHAT_MSG_LOOT" and timer_active == true then
        
        local text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons = ...;
        if guid ~= PlayerGUID then
            return
        end
        local number_r = string.match(text, "Hitem:(%d+)") 
        local quantity_r = string.match(text, "|rx(%d+)")
        local item_id = number_r and tonumber(number_r) or ""
        local quantity = (quantity_r and tonumber(quantity_r)) or 1

        local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expansionID, setID, isCraftingReagent = C_Item.GetItemInfo(item_id)
        if itemType == "Gem" and ThreadWatcher.db.profile.gems.track_gems == true then
            for i, table in pairs(Items) do
                for index, item_table in pairs(table) do
                    if item_table.thread_id == item_id then
                        AddThread(1, "|cFF1EFF00[Tier 1 Gem]|r", item_table, quantity)
                    end
                end
            end
        elseif (itemType == "Armor" or itemType == "Weapon") and ThreadWatcher.db.profile.gear.track_gear == true then
            local temp_table = {
                is_special = true,
                stat_name = "Armor",
                thread_count = -1
            }

            if itemQuality == Enum.ItemQuality.Uncommon then
                AddThread(2, "|cFF1EFF00[Uncommon Gear]|r", temp_table, quantity)
            elseif itemQuality == Enum.ItemQuality.Rare then
                AddThread(3, "|cFF0070DD[Rare Gear]|r", temp_table, quantity)
            elseif itemQuality == Enum.ItemQuality.Epic then
                AddThread(4, "|cFFA335EE[Epic Gear]|r", temp_table, quantity)
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
        if start_time ~= 0 then
            local elapsedTime = ElapsedTick()
            local seconds = math.floor(elapsedTime % 60)
            local minutes = math.floor((elapsedTime / 60) % 60)
            local hours = math.floor(elapsedTime / 3600)
            tooltip:AddLine(string.format("Session running for %02d:%02d:%02d", hours, minutes, seconds))

            if timer_active == false then
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

            item:ContinueOnItemLoad(function()
                AddThread(thread_table.thread_id, item:GetItemLink(), thread_table, thread_table.thread_count)
            end)
        end
    end
end

function ThreadWatcher:CurrencyTest()
    --  currencyType, quantity, quantityChange, quantityGainSource, quantityLostSource = ...;
    -- { currency_id = 738, stat_name = "Lesser Charm of Good Fortune", thread_id = 217174, thread_name = "Lesser Charm of Good Fortune", thread_count = -1, is_currency = true }
    -- local text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons = ...;
        
    eventHandler(event_frame, "CURRENCY_DISPLAY_UPDATE", 738, 100, 4, 13, 13)
    
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
            }
		},
	})
	icon:Register("ThreadWatcher", threadwatcherStub, self.db.profile.minimap)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("ThreadWatcher", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ThreadWatcher", "ThreadWatcher")
    self:RegisterChatCommand("threadwatcher", "ThreadCommand")
    --self:RegisterChatCommand("threadtest", "ThreadTest")
    self:RegisterChatCommand("currencytest", "CurrencyTest")
    self:RegisterChatCommand("gemtest", "GemTest")
    self:Print("ThreadWatcher loaded! Use the minimap icon or |cFFFFFF00/threadwatcher|r to open the ThreadWatcher window!")
    if self.db.profile.start_on_launch == true then
        self:Print("Session started.")
        StartTick()
        startButton:SetText("Pause")
    end
end

function ThreadWatcher:GetSessionStartup(info)
    return self.db.profile.start_on_launch
end

function ThreadWatcher:SetSessionStartup(info, value)
    self.db.profile.start_on_launch = value
end

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