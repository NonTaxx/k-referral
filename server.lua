lib.locale()

lib.callback.register('k-referral:getConfig', function()
    return Config
end)

lib.callback.register('k-referral:hasCode', function(_)
    local identifier = Framework.GetIdentifier(source)
    local results = MySQL.Sync.fetchAll("SELECT * FROM referral WHERE identifier=@identifier;", {['@identifier'] = identifier})
    if results[1] then
        return results[1].own_code, results[1].used_code
    end
end)

lib.callback.register('k-referral:codeExists', function(_, code)
    local results = MySQL.Sync.fetchAll("SELECT * FROM referral WHERE own_code=@own_code;", {['@own_code'] = code})
    if #results == 0 then return false else return true end
end)

lib.callback.register('k-referral:insertCode', function(_, code)
    local identifier = Framework.GetIdentifier(source)
    MySQL.Async.execute('UPDATE referral SET own_code = @own_code WHERE identifier = @identifier', {
        ['@own_code'] = code,
        ['@identifier'] = identifier
    })
    SendToDiscord(Config.DiscordWebhooks.create_code, locale('create_code_title'), locale('create_code_description', source, identifier, code))
end)

lib.callback.register('k-referral:claimCode', function(source, code)
    local identifier = Framework.GetIdentifier(source)
    local results = MySQL.Sync.fetchAll("SELECT * FROM referral WHERE own_code=@own_code;", {['@own_code'] = code})
    MySQL.Async.execute('UPDATE referral SET uses = @uses, unclaimed_uses = @unclaimed_uses WHERE own_code = @own_code', {
        ['@uses'] = results[1].uses+1,
        ['@unclaimed_uses'] = results[1].unclaimed_uses+1,
        ['@own_code'] = code
    })
    MySQL.Async.execute('UPDATE referral SET used_code = @used_code WHERE identifier = @identifier', {
        ['@used_code'] = code,
        ['@identifier'] = identifier
    })
    SendToDiscord(Config.DiscordWebhooks.claim, locale('claim_title'), locale('claim_description', source, identifier, code))
    exports.ox_inventory:AddItem(source, 'money', Config.MoneyAmount.redeem)
end)

lib.callback.register('k-referral:claimRewards', function(source)
    local identifier = Framework.GetIdentifier(source)
    local results = MySQL.Sync.fetchAll("SELECT unclaimed_uses, own_code FROM referral WHERE identifier=@identifier;", {['@identifier'] = identifier})
    if results[1].unclaimed_uses >= 1 and exports.ox_inventory:AddItem(source, 'money', Config.MoneyAmount.receive*results[1].unclaimed_uses) then
        SendToDiscord(Config.DiscordWebhooks.claim_rewards, locale('claim_rewards_title'), locale('claim_rewards_description', source, identifier, results[1].own_code, results[1].unclaimed_uses))
        MySQL.Async.execute('UPDATE referral SET unclaimed_uses = @unclaimed_uses WHERE identifier = @identifier', {
            ['@unclaimed_uses'] = 0,
            ['@identifier'] = identifier
        })
        return true
    elseif results[1].unclaimed_uses < 1 then return 'norewards' else return false end
end)

lib.callback.register('k-referral:getUseCount', function(_, code)
    local results = MySQL.Sync.fetchAll("SELECT uses FROM referral WHERE own_code=@own_code;", {['@own_code'] = code})
    return results[1].uses
end)

lib.callback.register('k-referral:getUnclaimedUseCount', function(_, code)
    local results = MySQL.Sync.fetchAll("SELECT unclaimed_uses FROM referral WHERE own_code=@own_code;", {['@own_code'] = code})
    return results[1].unclaimed_uses
end)

lib.callback.register('k-referral:firstTime', function(source)
    local identifier = Framework.GetIdentifier(source)
    MySQL.Async.fetchAll("SELECT * FROM referral WHERE identifier=@identifier;", {["@identifier"] = identifier}, function(results)
        if not results[1] then 
            MySQL.Async.execute('INSERT INTO referral (identifier) VALUES (@identifier)', {
                ['@identifier'] = identifier
            })
        end
    end)
end)

SendToDiscord = function(webhook, title, msg)
    local embed = {
        {
            ["color"] = 0,
            ["title"] = title,
            ["description"] = msg,
            ["footer"] = {
                ["text"] = os.date("%c") .. " | "..locale('referral_sys'),
            },
        }
    }
    local data = {
        ["embeds"] = embed
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end