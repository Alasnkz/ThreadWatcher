ThreadWatcher.session = ThreadWatcher.session or {}

ThreadWatcher.session.start_time = 0
ThreadWatcher.session.elapsed_paused_time = 0
ThreadWatcher.session.timer_active = false
ThreadWatcher.session.pause_start_time = 0
ThreadWatcher.session.had_session = false

function ThreadWatcher.session.StartSession()
    ThreadWatcher.session.start_time = 0
    ThreadWatcher.session.elapsed_paused_time = 0
    ThreadWatcher.session.timer_active = true
    ThreadWatcher.session.pause_start_time = 0
    ThreadWatcher.session.start_time = time()
    ThreadWatcher.session.had_session = true
    ThreadWatcher:Print("Session started.")
end

function ThreadWatcher.session.PauseSession()
    if ThreadWatcher.session.timer_active then
        ThreadWatcher.session.pause_start_time = time()
        ThreadWatcher.session.timer_active = false
    end
end

function ThreadWatcher.session.ResumeSession()
    if not ThreadWatcher.session.timer_active then
        ThreadWatcher.session.elapsed_paused_time = ThreadWatcher.session.elapsed_paused_time + (time() - ThreadWatcher.session.pause_start_time)
        ThreadWatcher.session.timer_active = true
    end
end

function ThreadWatcher.session.StopSession()
    ThreadWatcher.session.start_time = 0
    ThreadWatcher.session.elapsed_paused_time = 0
    ThreadWatcher.session.timer_active = false
    ThreadWatcher.session.pause_start_time = 0
    --ThreadWatcher.session.UpdateSessions()
    ThreadWatcher.session.loot.loot_list = {}
    ThreadWatcher.session.loot.UpdateLootDisplay()
end

function ThreadWatcher.session.ElapsedTick()
    if ThreadWatcher.session.timer_active then
        return time() - ThreadWatcher.session.start_time - ThreadWatcher.session.elapsed_paused_time
    else
        return ThreadWatcher.session.pause_start_time - ThreadWatcher.session.start_time - ThreadWatcher.session.elapsed_paused_time
    end
end

function ThreadWatcher.session.UpdateSessions()
    for index = 9, 1, -1 do
        if ThreadWatcher.db.profile.sessions[index] ~= nil then
            ThreadWatcher.db.profile.sessions[index + 1] = ThreadWatcher.db.profile.sessions[index]
        end
    end

    -- Just give start/pause/end then calcualte it??
    ThreadWatcher.db.profile.sessions[0] = {
        loot_list = ThreadWatcher.session.loot.loot_list,
        tick = ThreadWatcher.session.ElapsedTick()
    }
end

function ThreadWatcher.session.IsTimerActive()
    return ThreadWatcher.session.timer_active
end

function ThreadWatcher.session.IsInSession()
    return ThreadWatcher.session.start_time ~= 0
end

function ThreadWatcher.session.HadSession()
    return ThreadWatcher.session.had_session
end