ThreadWatcher.session = ThreadWatcher.session or {}

ThreadWatcher.session.current_session_index = 0
ThreadWatcher.session.had_session = false

function ThreadWatcher.session.StartSession(started_from_instance, session_name_override)
    ThreadWatcher.session.had_session = true
    ThreadWatcher.session.UpdateSessions(-1)
    ThreadWatcher.db.profile.sessions[1].start_time = 0
    ThreadWatcher.db.profile.sessions[1].elapsed_paused_time = 0
    ThreadWatcher.db.profile.sessions[1].timer_active = true
    ThreadWatcher.db.profile.sessions[1].pause_start_time = 0
    ThreadWatcher.db.profile.sessions[1].start_time = time()
    ThreadWatcher.db.profile.sessions[1].had_session = true
    ThreadWatcher.db.profile.sessions[1].started_from_instance = started_from_instance
    ThreadWatcher.db.profile.sessions[1].overriden_session_name = session_name_override
    ThreadWatcher.GUI.start_button:SetText("Pause")

    if started_from_instance == true then
        ThreadWatcher:Print(string.format("Instance session started for |cFF00FF00%s|r.", session_name_override))
    else
        ThreadWatcher:Print("Session started.")
    end
    ThreadWatcher.session.current_session_index = 1
    ThreadWatcher.session.BuildSessionList()
end

function ThreadWatcher.session.PauseSession()
    if ThreadWatcher.session.GetCurrentSession().timer_active then
        ThreadWatcher.session.GetCurrentSession().pause_start_time = time()
        ThreadWatcher.session.GetCurrentSession().timer_active = false
    end
end

function ThreadWatcher.session.ResumeSessionTick()
    if not ThreadWatcher.session.GetCurrentSession().timer_active then
        ThreadWatcher.session.GetCurrentSession().elapsed_paused_time = ThreadWatcher.session.GetCurrentSession().elapsed_paused_time + (time() - ThreadWatcher.session.GetCurrentSession().pause_start_time)
        ThreadWatcher.session.GetCurrentSession().timer_active = true
    end
end

function ThreadWatcher.session.StopSession()
    if ThreadWatcher.session.IsInSession() == false then
        return
    end
    ThreadWatcher.session.loot.DumpSessionInfo()
    ThreadWatcher.session.GetCurrentSession().elapsed_tick = ThreadWatcher.session.ElapsedTick()
    ThreadWatcher.session.GetCurrentSession().start_time = 0
    ThreadWatcher.session.GetCurrentSession().elapsed_paused_time = 0
    ThreadWatcher.session.GetCurrentSession().timer_active = false
    ThreadWatcher.session.GetCurrentSession().pause_start_time = 0
    ThreadWatcher.session.GetCurrentSession().started_from_instance = false
    ThreadWatcher.session.GetCurrentSession().had_session = false
    if next(ThreadWatcher.session.GetCurrentSession().loot_list) == nil then
        ThreadWatcher.session.GetCurrentSession().loot_list = nil
        ThreadWatcher.session.UpdateSessions(ThreadWatcher.session.current_session_index, true)
    end
    ThreadWatcher.session.current_session_index = 0
    ThreadWatcher.session.loot.UpdateLootDisplay()
    ThreadWatcher.GUI.start_button:SetText("Start")
    ThreadWatcher.GUI.main_frame:SetStatusText("00:00:00")

    
    ThreadWatcher.session.BuildSessionList()
end

function ThreadWatcher.session.ElapsedTick(session_index)
    if session_index ~= nil then
        return ThreadWatcher.db.profile.sessions[session_index].elapsed_tick
    end

    if ThreadWatcher.session.GetCurrentSession().timer_active then
        return time() - ThreadWatcher.session.GetCurrentSession().start_time - ThreadWatcher.session.GetCurrentSession().elapsed_paused_time
    else
        return ThreadWatcher.session.GetCurrentSession().pause_start_time - ThreadWatcher.session.GetCurrentSession().start_time - ThreadWatcher.session.GetCurrentSession().elapsed_paused_time
    end
end

function ThreadWatcher.session.UpdateSessions(removed_session_index, dont_want_new)
    if removed_session_index ~= -1 then
        local fill = {}
        for index = removed_session_index, 9 do
            fill[index - removed_session_index + 1] = ThreadWatcher.db.profile.sessions[index + 1]
        end
        for index = removed_session_index, 9 do
            ThreadWatcher.db.profile.sessions[index] = fill[index - removed_session_index + 1]
        end
        ThreadWatcher.db.profile.sessions[10] = nil
    end
    
    if dont_want_new ~= true then
        for index = 9, 1, -1 do
            if ThreadWatcher.db.profile.sessions[index] ~= nil then
                ThreadWatcher.db.profile.sessions[index].had_session = false
                ThreadWatcher.db.profile.sessions[index + 1] = ThreadWatcher.db.profile.sessions[index]
            end
        end

        ThreadWatcher.db.profile.sessions[1] = {
            loot_list = {},
            start_time = 0,
            elapsed_paused_time = 0,
            timer_active = false,
            pause_start_time = 0,
            had_session = false,
            started_from_instance = false,
            current_session_index = 0,
            elapsed_tick = 0
        }
    end 
    ThreadWatcher.session.BuildSessionList()
end

function ThreadWatcher.session.ResumeSession(id) 
    local tmp = ThreadWatcher.db.profile.sessions[id]
    ThreadWatcher.session.UpdateSessions(id)
    ThreadWatcher.db.profile.sessions[1] = tmp
    ThreadWatcher.session.current_session_index = 1
    ThreadWatcher.session.had_session = true
    ThreadWatcher.session.loot.UpdateLootDisplay()
    ThreadWatcher.GUI.start_button:SetText("Pause")
    ThreadWatcher.session.BuildSessionList()
end

function ThreadWatcher.session.PeekSession(id)
    ThreadWatcher.session.StopSession()
    ThreadWatcher.session.current_session_index = id
    ThreadWatcher.session.loot.UpdateLootDisplay(true)
end

function ThreadWatcher.session.IsTimerActive()
    return ThreadWatcher.session.GetCurrentSession().timer_active
end

function ThreadWatcher.session.IsInSession()
    return ThreadWatcher.session.GetCurrentSession().start_time ~= 0
end

function ThreadWatcher.session.HadSession()
    return ThreadWatcher.session.had_session
end

function ThreadWatcher.session.StartedByInstance()
    return ThreadWatcher.session.GetCurrentSession().started_from_instance
end

function ThreadWatcher.session.HadPreviousSession()
    return ThreadWatcher.db.profile.sessions[1] ~= nil and ThreadWatcher.db.profile.sessions[1].had_session == true
end

function ThreadWatcher.session.GetCurrentSession()
    if ThreadWatcher.session.current_session_index == 0 then
        return {
            loot_list = {},
            start_time = 0,
            elapsed_paused_time = 0,
            timer_active = false,
            pause_start_time = 0,
            had_session = false,
            started_from_instance = false,
            current_session_index = 0,
            overriden_session_name = nil,
            elapsed_tick = 0,
        }
    else
        return ThreadWatcher.db.profile.sessions[ThreadWatcher.session.current_session_index]
    end
end

function ThreadWatcher.session.BuildSessionList() 
    ThreadWatcher.GUI.session_list:ReleaseChildren()
    for index = 10, 1, -1 do
        if ThreadWatcher.db.profile.sessions[index] ~= nil then
            local session_label = AceGUI:Create("InteractiveLabel")
            local session_active = index == ThreadWatcher.session.current_session_index
            local session_name = ThreadWatcher.db.profile.sessions[index].overriden_session_name ~= nil and ThreadWatcher.db.profile.sessions[index].overriden_session_name or string.format("Session %i", index)
            
            if session_active == true then
                session_label:SetText(string.format("|cFF00FF00 %s|r", session_name))
            else
                session_label:SetText(" " .. session_name)
            end

            session_label:SetWidth(240)
            -- local current_time = time()
            -- local new_start_time = current_time - ThreadWatcher.db.profile.sessions[index].elapsed_tick
            session_label.frame:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:AddLine(session_name)

                if ThreadWatcher.db.profile.sessions[index].elapsed_tick ~= nil then
                    local tick = ThreadWatcher.db.profile.sessions[index].elapsed_tick
                    local seconds = math.floor(tick % 60)
                    local minutes = math.floor((tick / 60) % 60)
                    local hours = math.floor(tick / 3600)
                    GameTooltip:AddLine(string.format("Session time: |cFFFFFFFF%02d:%02d:%02d|r", hours, minutes, seconds))
                end

                local total_threads = 0
                local item_count = 0
                local bronze = 0
                local has_loot = false
                local charms = 0
                
                for _, loot in pairs(ThreadWatcher.db.profile.sessions[index].loot_list) do
                    has_loot = true
                    if loot.is_thread ~= true and loot.is_currency == true then
                        if loot.currency_name == "Bronze" then 
                            bronze = loot.amount
                        elseif loot.currency_name == "Lesser Charm of Good Fortune" then
                            charms = loot.amount
                        end
                    elseif loot.is_thread == true then           
                        total_threads = total_threads + loot.thread_count
                        item_count = item_count + loot.amount
                    end
                end

                if has_loot == true then
                    if total_threads > 0 then
                        GameTooltip:AddLine(string.format("Stat upgrades: |cFFFFFFFF%i|r", total_threads))
                        GameTooltip:AddLine(string.format("Thread drops: |cFFFFFFFF%i|r", item_count))
                    end

                    if bronze ~= 0 then
                        GameTooltip:AddLine(string.format("Bronze earned: |cFFFFFFFF%i|r", bronze))
                    end

                    if charms ~= 0 then
                        GameTooltip:AddLine(string.format("Charms earned: |cFFFFFFFF%i|r", charms))
                    end

                    local gem_data = ThreadWatcher.db.profile.sessions[index].loot_list[LOOT_NUM_GEM]
                    if gem_data ~= nil and gem_data.amount ~= 0 and ThreadWatcher.db.profile.gems.dump_gem_info == true then
                        GameTooltip:AddLine(string.format("Gems earned: |cFFFFFFFF%i|r", gem_data.amount))
                    end
                    
                    local uncommon_gear = ThreadWatcher.db.profile.sessions[index].loot_list[LOOT_NUM_UNCOMMON_GEAR]
                    local rare_gear = ThreadWatcher.db.profile.sessions[index].loot_list[LOOT_NUM_RARE_GEAR]
                    local epic_gear = ThreadWatcher.db.profile.sessions[index].loot_list[LOOT_NUM_EPIC_GEAR]

                    if uncommon_gear ~= nil and uncommon_gear.amount ~= 0 then
                        GameTooltip:AddLine(string.format("|cFF1EFF00Uncommon gear|r: |cFFFFFFFF%i|r", uncommon_gear.amount))
                    end

                    if rare_gear ~= nil and rare_gear.amount ~= 0 then
                        GameTooltip:AddLine(string.format("|cFF0070DDRare gear|r: |cFFFFFFFF%i|r", rare_gear.amount))
                    end

                    if epic_gear ~= nil and epic_gear.amount ~= 0 then 
                        GameTooltip:AddLine(string.format("|cFFA335EEEpic gear|r: |cFFFFFFFF%i|r", epic_gear.amount))
                    end
                end
                GameTooltip:Show()
            end)

            session_label.frame:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)

            session_label:SetCallback("OnClick", function(widget, event, ...)
                local button = ...
                if button == "LeftButton" then
                    ThreadWatcher.session.loot.DumpSessionInfo(index)
                elseif button == "RightButton" then
                    ThreadWatcher.session.PeekSession(index)
                end
            end)

            ThreadWatcher.GUI.session_list:AddChild(session_label)
        end
    end
    local empty = AceGUI:Create("InteractiveLabel")
    ThreadWatcher.GUI.session_list:AddChild(empty)
end
