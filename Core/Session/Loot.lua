ThreadWatcher.session.loot = ThreadWatcher.session.loot or {}
function ThreadWatcher.session.loot.UpdateLootDisplay(peeking)
    ThreadWatcher.GUI.inline_group:ReleaseChildren()
    if ThreadWatcher.session.IsInSession() == false and (peeking == nil or peeking ~= true) then
        return
    end

    if ThreadWatcher.session.IsInSession() == true and ThreadWatcher.session.GetCurrentSession().loot_list == nil then
        ThreadWatcher.session.GetCurrentSession().loot_list = {}
    end

    local offset = 0
    for i, loot in pairs(ThreadWatcher.session.GetCurrentSession().loot_list) do
        local lootText = AceGUI:Create("Label")
        if loot.is_currency == true then
            lootText:SetText(loot.item_link .. " x" .. loot.amount)
        elseif loot.is_gem == true then
            lootText:SetText(loot.item_link .. " x" .. loot.amount .. " (+" .. loot.amount * 10 .. " bronze)")
        elseif loot.is_item == true then
            lootText:SetText(loot.item_link .. " x" .. loot.amount)
        elseif loot.is_thread == true then
            lootText:SetText(loot.item_link .. " x" .. loot.amount .. " (+" .. loot.thread_count .. " " .. loot.stat_name .. ")")
        end
        lootText:SetFullWidth(true)

        ThreadWatcher.GUI.inline_group:AddChild(lootText)
    end
    ThreadWatcher.GUI.inline_group:DoLayout()
    ThreadWatcher.GUI.scroll_frame:DoLayout()
end

function ThreadWatcher.session.loot.AddThread(item, item_link, thread_table)
    -- get total thread count
    -- [item] x[amount] (+thread name)
    -- example: [Thread of Stanima] x5 (+5 stanima)

    if ThreadWatcher.session.GetCurrentSession().loot_list[item] == nil then
        -- new item
        ThreadWatcher.session.GetCurrentSession().loot_list[item] = {
            is_thread = true,
            item_link = item_link,
            stat_name = thread_table.stat_name,
            thread_count = thread_table.thread_count,
            amount = 1
        }
    elseif ThreadWatcher.session.GetCurrentSession().loot_list[item] ~= nil then
        ThreadWatcher.session.GetCurrentSession().loot_list[item].amount = ThreadWatcher.session.GetCurrentSession().loot_list[item].amount + 1
        ThreadWatcher.session.GetCurrentSession().loot_list[item].thread_count = ThreadWatcher.session.GetCurrentSession().loot_list[item].thread_count + thread_table.thread_count
    end
    
    ThreadWatcher.session.loot.UpdateLootDisplay()
end

-- Typically, AddItem will just use a pre-defined number, like 2 for uncommon gear.
function ThreadWatcher.session.loot.AddItem(identifier, item_link, amount)
    if ThreadWatcher.session.GetCurrentSession().loot_list[identifier] == nil then
        ThreadWatcher.session.GetCurrentSession().loot_list[identifier] = {
            is_item = true,
            item_link = item_link,
            amount = amount,
        }
    elseif ThreadWatcher.session.GetCurrentSession().loot_list[identifier] ~= nil then
        ThreadWatcher.session.GetCurrentSession().loot_list[identifier].amount = ThreadWatcher.session.GetCurrentSession().loot_list[identifier].amount + amount
    end

    ThreadWatcher.session.loot.UpdateLootDisplay()
end

function ThreadWatcher.session.loot.AddGem(identifier, item_link, amount)
    if ThreadWatcher.session.GetCurrentSession().loot_list[identifier] == nil then
        ThreadWatcher.session.GetCurrentSession().loot_list[identifier] = {
            is_gem = true,
            item_link = item_link,
            amount = amount,
        }
    elseif ThreadWatcher.session.GetCurrentSession().loot_list[identifier] ~= nil then
        ThreadWatcher.session.GetCurrentSession().loot_list[identifier].amount = ThreadWatcher.session.GetCurrentSession().loot_list[identifier].amount + amount
    end

    ThreadWatcher.session.loot.UpdateLootDisplay()
end

function ThreadWatcher.session.loot.AddCurrency(currency_id, currency_link, amount, currency_name)
    if ThreadWatcher.session.GetCurrentSession().loot_list[currency_id] == nil then
        ThreadWatcher.session.GetCurrentSession().loot_list[currency_id] = {
            currency_name = currency_name,
            is_currency = true,
            item_link = currency_link,
            amount = amount,
        }
    elseif ThreadWatcher.session.GetCurrentSession().loot_list[currency_id] ~= nil then
        ThreadWatcher.session.GetCurrentSession().loot_list[currency_id].amount = ThreadWatcher.session.GetCurrentSession().loot_list[currency_id].amount + amount
    end

    ThreadWatcher.session.loot.UpdateLootDisplay()
end

LOOT_NUM_GEM = 1
LOOT_NUM_UNCOMMON_GEAR = 2
LOOT_NUM_RARE_GEAR = 3
LOOT_NUM_EPIC_GEAR = 4

function ThreadWatcher.session.loot.DumpSessionInfo(session_index) 
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
    local has_loot = false

    local tmp_session = ThreadWatcher.session.GetCurrentSession()
    if session_index ~= nil then
        tmp_session = ThreadWatcher.db.profile.sessions[session_index]
    end

    if tmp_session.loot_list == nil then
        tmp_session.loot_list = {}
    end

    -- THREAD
    for _, loot in pairs(tmp_session.loot_list) do
        has_loot = true
        if loot.is_thread ~= true and loot.is_currency == true then
            if loot.currency_name == "Bronze" then 
                bronze = loot.amount
            elseif loot.currency_name == "Lesser Charm of Good Fortune" then
                charms = loot.amount
            end
        elseif loot.is_thread == true then
            if thread_counts[loot.stat_name] == nil then
                thread_counts[loot.stat_name] = 0
            end
    
            thread_counts[loot.stat_name] = loot.thread_count + thread_counts[loot.stat_name]
            total_threads = total_threads + loot.thread_count
            item_count = item_count + loot.amount
            if most_item < loot.amount then
                most_item = loot.amount
                most_item_link = loot.item_link
                most_item_threads = loot.thread_count
                most_item_stat = loot.stat_name
            end
        end
    end


    local elapsedTime = ThreadWatcher.session.ElapsedTick(session_index)
    local seconds = math.floor(elapsedTime % 60)
    local minutes = math.floor((elapsedTime / 60) % 60)
    local hours = math.floor(elapsedTime / 3600)
    local minutes_conv = minutes + hours * 60
    
    if seconds < 60 and minutes == 0 and ThreadWatcher.db.profile.round_to_minute == true then
        minutes = 1
        seconds = 0
        minutes_conv = 1
    end
    
    if has_loot == true and tmp_session.overriden_session_name ~= nil then
        ThreadWatcher:Print(string.format("Session results for |cFF00FF00%s|r.", tmp_session.overriden_session_name))
    end
    
    if bronze ~= 0 and ThreadWatcher.db.profile.bronze.dump_bronze_info == true then
        if ThreadWatcher.db.profile.compact_dump_output == true then
            if minutes > 0 or hours > 0 then
                ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r bronze in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r bronze/minute)", bronze, TimeToString(elapsedTime), bronze / minutes_conv))
            else
                ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r bronze in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r bronze/second)", bronze, TimeToString(elapsedTime), bronze / seconds))
            end
        else
            ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r bronze in |cFFFFFF00%s|r!", bronze, TimeToString(elapsedTime)))
            if minutes > 0 or hours > 0 then
                ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r bronze every minute!", bronze / minutes_conv))
            else
                ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r bronze every second!", bronze / seconds))
            end
        end
    end

    if charms ~= 0 and ThreadWatcher.db.profile.lesser_charms.dump_charm_info == true then
        if ThreadWatcher.db.profile.compact_dump_output == true then
            if minutes > 0 or hours > 0 then
                ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r lesser charms in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r charms/minute)", charms, TimeToString(elapsedTime), charms / minutes_conv))
            else
                ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r lesser charms in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r charms/second)", charms, TimeToString(elapsedTime), charms / seconds))
            end
        else
            ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r lesser charms in |cFFFFFF00%s|r!", charms, TimeToString(elapsedTime)))
            if minutes > 0 or hours > 0 then
                ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r lesser charms every minute!", charms / minutes_conv))
            else
                ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r lesser charms every second!", charms / seconds))
            end
        end
    end

    -- GEMS
    local gem_data = tmp_session.loot_list[LOOT_NUM_GEM]
    if gem_data ~= nil and gem_data.amount ~= 0 and ThreadWatcher.db.profile.gems.dump_gem_info == true then
        if ThreadWatcher.db.profile.compact_dump_output == true then
            if minutes > 0 or hours > 0 then
                ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r tier 1 gems (+%i bronze) in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r gems/minute)", gem_data.amount, gem_data.amount * 10, TimeToString(elapsedTime), gem_data.amount / minutes_conv))
            else
                ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r tier 1 gems (+%i bronze) in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r gems/second)", gem_data.amount, gem_data.amount * 10, TimeToString(elapsedTime), gem_data.amount / seconds))
            end
        else
            ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r tier 1 gems (+%i bronze) in |cFFFFFF00%s|r!", gem_data.amount, gem_data.amount * 10, TimeToString(elapsedTime)))
            if minutes > 0 or hours > 0 then
                ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r gems (+%i bronze) every minute!", gem_data.amount / minutes_conv, (gem_data.amount / minutes_conv) * 10))
            else
                ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r gems (+%i bronze) every second!", gem_data.amount / seconds, (gem_data.amount / seconds) * 10))
            end
        end
    end
    -- END

    -- GEAR
    if ThreadWatcher.db.profile.gear.dump_gear_info == true then
        local uncommon_gear = tmp_session.loot_list[LOOT_NUM_UNCOMMON_GEAR]
        local rare_gear = tmp_session.loot_list[LOOT_NUM_RARE_GEAR]
        local epic_gear = tmp_session.loot_list[LOOT_NUM_EPIC_GEAR]
   
        if uncommon_gear ~= nil and uncommon_gear.amount ~= 0 then
            if ThreadWatcher.db.profile.compact_dump_output == true then
                if minutes > 0 or hours > 0 then
                    ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r uncommon gear drops in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r/minute)", uncommon_gear.amount, TimeToString(elapsedTime), uncommon_gear.amount / minutes_conv))
                else
                    ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r uncommon gear drops in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r/second)", uncommon_gear.amount, TimeToString(elapsedTime), uncommon_gear.amount / seconds))
                end
            else
                ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r uncommon gear drops in |cFFFFFF00%s|r!", uncommon_gear.amount, TimeToString(elapsedTime)))
                if minutes > 0 or hours > 0 then
                    ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r uncommon gear drops every minute!", uncommon_gear.amount / minutes_conv))
                else
                    ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r uncommon gear drops every second!", uncommon_gear.amount / seconds))
                end
            end
        end

        if rare_gear ~= nil and rare_gear.amount ~= 0 then
            if ThreadWatcher.db.profile.compact_dump_output == true then
                if minutes > 0 or hours > 0 then
                    ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r rare gear drops in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r/minute)", rare_gear.amount, TimeToString(elapsedTime), rare_gear.amount / minutes_conv))
                else
                    ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r rare gear drops in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r/second)", rare_gear.amount, TimeToString(elapsedTime), rare_gear.amount / seconds))
                end
            else
                ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r rare gear drops in |cFFFFFF00%s|r!", rare_gear.amount, TimeToString(elapsedTime)))
                if minutes > 0 or hours > 0 then
                    ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r rare gear drops every minute!", rare_gear.amount / minutes_conv))
                else
                    ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r rare gear drops every second!", rare_gear.amount / seconds))
                end
            end
        end

        if epic_gear ~= nil and epic_gear.amount ~= 0 then 
            if ThreadWatcher.db.profile.compact_dump_output == true then
                if minutes > 0 or hours > 0 then
                    ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r epic gear drops in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r/minute)", epic_gear.amount, TimeToString(elapsedTime), epic_gear.amount / minutes_conv))
                else
                    ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r epic gear drops in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r/second)", epic_gear.amount, TimeToString(elapsedTime), epic_gear.amount / seconds))
                end
            else
                ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r epic gear drops in |cFFFFFF00%s|r!", epic_gear.amount, TimeToString(elapsedTime)))
                if minutes > 0 or hours > 0 then
                    ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r epic gear drops every minute!", epic_gear.amount / minutes_conv))
                else
                    ThreadWatcher:Print(string.format("That's |cFF00FF00%0.2f|r epic gear drops every second!", epic_gear.amount / seconds))
                end
            end
        end
    end
    -- END

    if total_threads > 0 and most_item_link ~= "" then
        if ThreadWatcher.db.profile.compact_dump_output == true then
            if minutes > 0 or hours > 0 then
                ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r stat upgrades in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r thread drops/minute)", total_threads, TimeToString(elapsedTime), item_count / minutes_conv))
            else
                ThreadWatcher:Print(string.format("You have gained |cFF00FF00%i|r stat upgrades in |cFFFFFF00%s|r! (|cFF00FF00%0.2f|r thread drops/second)", total_threads, TimeToString(elapsedTime), item_count / seconds))
            end
        else
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
end
