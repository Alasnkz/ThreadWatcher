ThreadWatcher.GUI = ThreadWatcher.GUI or {}

local function UpdateTimerDisplay(elapsedTime)
    local seconds = math.floor(elapsedTime % 60)
    local minutes = math.floor((elapsedTime / 60) % 60)
    local hours = math.floor(elapsedTime / 3600)
    ThreadWatcher.GUI.main_frame:SetStatusText(string.format("%02d:%02d:%02d", hours, minutes, seconds))
end

ThreadWatcher.GUI.main_frame = AceGUI:Create("Frame")
ThreadWatcher.GUI.main_frame:SetTitle("ThreadWatcher")
ThreadWatcher.GUI.main_frame:SetWidth(500)
ThreadWatcher.GUI.main_frame:SetHeight(200)
ThreadWatcher.GUI.main_frame:SetLayout("Flow")
ThreadWatcher.GUI.main_frame.frame:SetScript("OnUpdate", function(elapsed)
    if ThreadWatcher.GUI.main_frame.frame:IsShown() and ThreadWatcher.session.IsTimerActive() == true then
        UpdateTimerDisplay(ThreadWatcher.session.ElapsedTick())
    end
end)
ThreadWatcher.GUI.main_frame:Hide()

ThreadWatcher.GUI.scroll_frame = AceGUI:Create("ScrollFrame")
ThreadWatcher.GUI.scroll_frame:SetFullWidth(true)
ThreadWatcher.GUI.scroll_frame:SetFullHeight(true)
ThreadWatcher.GUI.scroll_frame:SetLayout("Flow")


ThreadWatcher.GUI.inline_group = AceGUI:Create("InlineGroup")
ThreadWatcher.GUI.inline_group:SetFullWidth(true)
ThreadWatcher.GUI.inline_group:SetFullHeight(true)
ThreadWatcher.GUI.inline_group:SetLayout("Flow")
ThreadWatcher.GUI.scroll_frame:AddChild(ThreadWatcher.GUI.inline_group)


ThreadWatcher.GUI.start_button = AceGUI:Create("Button")
ThreadWatcher.GUI.start_button:SetText("Start")
ThreadWatcher.GUI.start_button:SetCallback("OnClick", function()
    if ThreadWatcher.session.IsTimerActive() == false and ThreadWatcher.session.IsInSession() == false then
        ThreadWatcher.session.StartSession()
        ThreadWatcher.GUI.start_button:SetText("Pause")
    elseif ThreadWatcher.session.IsTimerActive() == false and ThreadWatcher.session.IsInSession() == true then
        ThreadWatcher.session.ResumeSessionTick()
        ThreadWatcher.GUI.start_button:SetText("Pause")
    elseif ThreadWatcher.session.IsTimerActive() == true then
        ThreadWatcher.session.PauseSession()
        ThreadWatcher.GUI.start_button:SetText("Resume")
    end
end)
ThreadWatcher.GUI.start_button:SetAutoWidth(true)
ThreadWatcher.GUI.main_frame:AddChild(ThreadWatcher.GUI.start_button)

local dump_button = AceGUI:Create("Button")
dump_button:SetText("Dump Results")
dump_button:SetCallback("OnClick", function() 
    ThreadWatcher.session.loot.DumpSessionInfo()
end)
dump_button:SetAutoWidth(true)
ThreadWatcher.GUI.main_frame:AddChild(dump_button)


local optionsButton = AceGUI:Create("Button")
optionsButton:SetText("Options")
optionsButton:SetCallback("OnClick", function()
    InterfaceOptionsFrame_OpenToCategory("ThreadWatcher")
end)
optionsButton:SetAutoWidth(true)
ThreadWatcher.GUI.main_frame:AddChild(optionsButton)


local stopButton = AceGUI:Create("Button")
stopButton:SetText("Stop")
stopButton:SetCallback("OnClick", function()
    ThreadWatcher.session.StopSession()
    
end)
stopButton:SetAutoWidth(true)
ThreadWatcher.GUI.main_frame:AddChild(stopButton)

local toggleButton = AceGUI:Create("Button")
toggleButton:SetText("Sessions")
toggleButton:SetAutoWidth(true)

ThreadWatcher.GUI.session_list = AceGUI:Create("SimpleGroup")
ThreadWatcher.GUI.session_list.frame:Hide()
ThreadWatcher.GUI.session_list:SetWidth(250)
ThreadWatcher.GUI.session_list:SetLayout("Flow")
ThreadWatcher.GUI.session_list.frame.backdrop = CreateFrame("Frame", nil, ThreadWatcher.GUI.session_list.frame, "BackdropTemplate")
ThreadWatcher.GUI.session_list.frame.backdrop:SetAllPoints(ThreadWatcher.GUI.session_list.frame, true)
ThreadWatcher.GUI.session_list.frame.backdrop:SetBackdrop({
   bgFile = "Interface/Tooltips/UI-Tooltip-Background",
   tile = false,
   tileSize = 0,
   edgeSize = 0,
   insets = { left = 0, right = 0, top = 0, bottom = 0 }
})
ThreadWatcher.GUI.session_list.frame.backdrop:SetBackdropColor(0, 0, 0, 1)

toggleButton.frame:SetScript("OnEnter", function()
    local screenWidth = GetScreenWidth()
    local screenHeight = GetScreenHeight()
    local buttonLeft = toggleButton.frame:GetLeft()
    local buttonRight = toggleButton.frame:GetRight()
    local buttonTop = toggleButton.frame:GetTop()
    local buttonBottom = toggleButton.frame:GetBottom()
    local buttonCenterY = (buttonTop + buttonBottom) / 2
    local mainFrameHeight = ThreadWatcher.GUI.main_frame.frame:GetHeight()
    local offset = (mainFrameHeight - toggleButton.frame:GetHeight()) / 2
    local popoutX = buttonRight + 10
    local popoutY = buttonCenterY - ThreadWatcher.GUI.session_list.frame:GetHeight() / 2 + offset

    if popoutX + ThreadWatcher.GUI.session_list.frame:GetWidth() > screenWidth then
        popoutX = buttonLeft - ThreadWatcher.GUI.session_list.frame:GetWidth() - 10
    end

    if popoutY < 0 then
        popoutY = 0
    end

    if popoutY + ThreadWatcher.GUI.session_list.frame:GetHeight() > screenHeight then
        popoutY = screenHeight - ThreadWatcher.GUI.session_list.frame:GetHeight()
    end

    ThreadWatcher.GUI.session_list.frame:ClearAllPoints()
    ThreadWatcher.GUI.session_list.frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", popoutX, popoutY)
    ThreadWatcher.GUI.session_list.frame:Show()
    ThreadWatcher.GUI.session_list.frame:SetFrameStrata("DIALOG")
end)

local function hidePopoutList()
    if not toggleButton.frame:IsMouseOver() and not ThreadWatcher.GUI.session_list.frame:IsMouseOver() then
        C_Timer.After(0.3, function ()
            if not toggleButton.frame:IsMouseOver() and not ThreadWatcher.GUI.session_list.frame:IsMouseOver() then
                ThreadWatcher.GUI.session_list.frame:Hide()
            end
        end)
    end
end

toggleButton.frame:SetScript("OnUpdate", hidePopoutList)
ThreadWatcher.GUI.session_list.frame:SetScript("OnUpdate", hidePopoutList)
ThreadWatcher.GUI.main_frame:AddChild(toggleButton)
ThreadWatcher.GUI.session_list.frame:SetParent(UIParent)

ThreadWatcher.GUI.main_frame:AddChild(ThreadWatcher.GUI.scroll_frame)
ThreadWatcher.GUI.main_frame.frame:SetFrameStrata("MEDIUM")