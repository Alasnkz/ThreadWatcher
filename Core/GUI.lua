ThreadWatcher.GUI = ThreadWatcher.GUI or {}

local function UpdateTimerDisplay(elapsedTime)
    local seconds = math.floor(elapsedTime % 60)
    local minutes = math.floor((elapsedTime / 60) % 60)
    local hours = math.floor(elapsedTime / 3600)
    ThreadWatcher.GUI.main_frame:SetStatusText(string.format("%02d:%02d:%02d", hours, minutes, seconds))
end

ThreadWatcher.GUI.main_frame = AceGUI:Create("Frame")
ThreadWatcher.GUI.main_frame:SetTitle("ThreadWatcher")
ThreadWatcher.GUI.main_frame:SetWidth(425)
ThreadWatcher.GUI.main_frame:SetHeight(200)
ThreadWatcher.GUI.main_frame:SetLayout("Flow")
ThreadWatcher.GUI.main_frame.frame:SetScript("OnUpdate", function(elapsed)
    if ThreadWatcher.session.IsTimerActive() == true then
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
        ThreadWatcher.session.ResumeSession()
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
    ThreadWatcher.GUI.start_button:SetText("Start")
    ThreadWatcher.session.loot.DumpSessionInfo()
    ThreadWatcher.session.StopSession()
    ThreadWatcher.GUI.main_frame:SetStatusText("00:00:00")
end)
stopButton:SetAutoWidth(true)
ThreadWatcher.GUI.main_frame:AddChild(stopButton)

ThreadWatcher.GUI.main_frame:AddChild(ThreadWatcher.GUI.scroll_frame)
