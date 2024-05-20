ThreadWatcher = {}

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
        { currency_id = 2853, stat_name = "power", thread_id = 210982, thread_name = "Thread of Power", thread_count = 1 },
        { currency_id = 2853, stat_name = "power", thread_id = 219256, thread_name = "Temporal Thread of Power", thread_count = 3 },
        { currency_id = 2853, stat_name = "power", thread_id = 219265, thread_name = "Perpetual Thread of Power", thread_count = 7 },
        { currency_id = 2853, stat_name = "power", thread_id = 219274, thread_name = "Infinite Thread of Power", thread_count = 12 }
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
    }
}
local event_frame = CreateFrame("EventFrame", "ThreadWatcher")
event_frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
event_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
event_frame:RegisterEvent("ADDON_LOADED")

local frame = CreateFrame("Frame", "LootFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(200, 200)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

frame:SetResizable(true)
frame:Hide()

local MIN_WIDTH = 200
local MIN_HEIGHT = 200

local resizeButton = CreateFrame("Button", nil, frame)
resizeButton:SetSize(16, 16)
resizeButton:SetPoint("BOTTOMRIGHT", -4, 4)
resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

resizeButton:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
        frame:StartSizing("BOTTOMRIGHT")
    end
end)
resizeButton:SetScript("OnMouseUp", function(self, button)
    frame:StopMovingOrSizing()
    local width, height = frame:GetSize()
    if width < MIN_WIDTH then
        frame:SetWidth(MIN_WIDTH)
    end
    if height < MIN_HEIGHT then
        frame:SetHeight(MIN_HEIGHT)
    end
end)

local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -30)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 50)

local content = CreateFrame("Frame", nil, scrollFrame)
content:SetSize(260, 400)
scrollFrame:SetScrollChild(content)

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
    button_frame_pool:ReleaseAll()

    local offset = 0
    for i, loot in pairs(lootList) do
        local lootButton = button_frame_pool:Acquire()
        
        lootButton:SetParent(content)
        lootButton:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -offset)
        lootButton:SetSize(200, 20)
        lootButton:Show()

        local lootText = fontStringsCreated[lootButton]
        if not lootText then
            lootText = lootButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            fontStringsCreated[lootButton] = lootText
        end

        lootText:SetPoint("LEFT", lootButton, "LEFT", 5, 0)
        lootText:SetText(loot.item_link .. " x" .. loot.amount .. " (+" .. loot.thread_count .. " " .. loot.stat_name .. ")")

        offset = offset + 20
    end

    content:SetHeight(offset)
end

local function AddThread(item, item_link, thread_table)
    -- get total thread count
    -- [item] x[amount] (+thread name)
    -- example: [Thread of Stanima] x5 (+5 stanima)
    if lootList[item] == nil then
        lootList[item] = {
            item_link = item_link,
            stat_name = thread_table.stat_name,
            thread_count = thread_table.thread_count,
            amount = 1,
        }
    elseif lootList[item] ~= nil then
        lootList[item].amount = lootList[item].amount + 1
        lootList[item].thread_count = lootList[item].thread_count + thread_table.thread_count
    end
    UpdateLootDisplay()
end

local timerActive = false
local elapsedTime = 0

local startButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
startButton:SetPoint("BOTTOMLEFT", 10, 10)
startButton:SetSize(80, 30)
startButton:SetText("Start")
startButton:SetScript("OnClick", function()
    if timerActive == false then 
        timerActive = true
        startButton:SetText("Pause")
    else
        timerActive = false
        startButton:SetText("Resume")
    end
    
end)

local stopButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
stopButton:SetPoint("BOTTOMRIGHT", -10, 10)
stopButton:SetSize(80, 30)
stopButton:SetText("Stop")
stopButton:SetScript("OnClick", function()
    timerActive = false

    local most_threads = 0
    local most_thread_stat = ""
    local total_threads = 0
    local thread_counts = {}
    local item_count = 0
    local most_item = 0
    local most_item_link = ""
    for i, loot in pairs(lootList) do
        if thread_counts[loot.stat_name] == nil then
            thread_counts[loot.stat_name] = 0
        end
        
        thread_counts[loot.stat_name] = loot.thread_count + thread_counts[loot.stat_name]
        total_threads = total_threads + loot.thread_count

        item_count = item_count + 1

        if most_item < loot.amount then
            most_item = loot.amount
            most_item_link = loot.item_link
        end
    end

    for name, threads in pairs(thread_counts) do
        if most_threads < threads then
            most_threads = threads
        end
    end

    local seconds = math.floor(elapsedTime % 60)
    local minutes = math.floor((elapsedTime / 60) % 60)
    local hours = math.floor(elapsedTime / 3600)
    
    
    local item_drops = item_count / minutes
    print(string.format("ThreadWatcher: You have gained |cFF00FF00%i|r stat upgrades in |cFFFFFF00%02d:%02d:%02d|r!", total_threads, hours, minutes, seconds))

    
    if total_threads > 0 and most_item_link ~= "" then
        print(string.format("ThreadWatcher: Your most common thread drop was %s for |cFF00FF00%i|r stat upgrades!", most_item_link, most_threads))
    end

    local minutes = math.floor((elapsedTime / 60) % 60) + math.floor(elapsedTime / 3600) * 60 + math.floor(elapsedTime % 60 / 60)
    local threads_per_min = total_threads / minutes
    print(string.format("ThreadWatcher: You gained |cFF00FF00%0.2f|r stat upgrades or |cFF00FF00%0.2f|r thread drops every minute!", threads_per_min, item_drops))
    
    timerActive = false
    lootList = {}
    UpdateLootDisplay()
    elapsedTime = 0
    startButton:SetText("Start")
end)

local info_text = frame:CreateFontString("nil", "OVERLAY", "GameTooltipText")
info_text:SetPoint("BOTTOM", -10, 10)

local timerText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
timerText:SetPoint("TOP", frame, "TOP", 0, -5)
timerText:SetText("00:00:00")


local function UpdateTimerDisplay(elapsedTime)
    local seconds = math.floor(elapsedTime % 60)
    local minutes = math.floor((elapsedTime / 60) % 60)
    local hours = math.floor(elapsedTime / 3600)
    timerText:SetText(string.format("%02d:%02d:%02d", hours, minutes, seconds))
end

local function OnUpdate(self, elapsed)
    if timerActive then
        elapsedTime = elapsedTime + elapsed
        UpdateTimerDisplay(elapsedTime)
    end
end

local timer_frame = CreateFrame("Frame")
timer_frame:SetScript("OnUpdate", OnUpdate)
SLASH_THREADWATCHER1 = "/threadwatcher"
SlashCmdList["THREADWATCHER"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

local function eventHandler(self, event, ...) 
    if event == "CURRENCY_DISPLAY_UPDATE" then 
        local currencyType, quantity, quantityChange, quantityGainSource, quantityLostSource = ...;
        for i, thread in pairs(Threads) do 
            for thread_table_name, thread_table in pairs(thread) do
                if thread_table.currency_id == currencyType and thread_table.thread_count == quantityChange then
                    local item = Item:CreateFromItemID(thread_table.thread_id)

                    item:ContinueOnItemLoad(function()
                        AddThread(thread_table.thread_id, item:GetItemLink(), thread_table)
                    end)
                    
                end
            end
        end
    end
    if event == "PLAYER_ENTERING_WORLD" then
        local login, reload = ...;
        if login and reload ~= false then
            print("ThreadWatcher: ThreadWatcher loaded! Use /threadwatcher to open the window.")
        end
    end
end
event_frame:SetScript("OnEvent", eventHandler)