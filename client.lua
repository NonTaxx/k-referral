local cfg = lib.callback.await('k-referral:getConfig', false)
lib.locale()

function redeemCode()
    local input = lib.inputDialog(locale('referral_codes'), {
        {type = 'input', label = locale('redeem_code'), placeholder = locale('input_code'), required = true, min = 4, max = 16}
    })
    if input then
        lib.callback('k-referral:codeExists', false, function(state)
            lib.callback('k-referral:hasCode', false, function(own_code)
                if own_code == input[1] then Notify(locale('referral_sys'), locale('own_code'), 'error') openMenu() else
                    if state then
                        lib.callback.await('k-referral:claimCode', false, input[1])
                        Notify(locale('referral_sys'), locale('success_redeem'), 'success')
                        openMenu()
                    else
                        Notify(locale('referral_sys'), locale('code_invalid'), 'error')
                        openMenu()
                    end
                end
            end)
        end, input[1])
    else openMenu() end
end

function createCode()
    local input = lib.inputDialog(locale('referral_codes'), {
        {type = 'input', label = locale('create_code'), placeholder = locale('input_code'), required = true, min = 4, max = 16}
    })
    if input and not lib.callback.await('k-referral:codeExists', false, input[1]) then
        lib.callback.await('k-referral:insertCode', false, input[1])
        Notify(locale('referral_sys'), locale('success_create'), 'success')
        openMenu()
    elseif input and lib.callback.await('k-referral:codeExists', false, input[1]) then
        Notify(locale('referral_sys'), locale('code_used'), 'error')
        openMenu()
    else
        openMenu()
    end
end

function redeemRewards()
    lib.callback('k-referral:claimRewards', false, function(state)
        if state == 'norewards' then
            Notify(locale('referral_sys'), locale('no_unclaimed_rewards'), 'error')
            openMenu()
        elseif state then
            Notify(locale('referral_sys'), locale('success_rewards'), 'success')
            openMenu()
        else
            Notify(locale('referral_sys'), locale('error'), 'error')
            openMenu()
        end
    end)
end

function openMenu()
    local referral_options = {
        {
            title = locale('collect'),
            description = locale('collect_description'),
            icon = 'fa-solid fa-money-bill',
            onSelect = redeemRewards
        },
        {
            title = locale('info'),
            description = locale('info_description'),
            menu = 'information',
            icon = 'fa-solid fa-circle-info'
        }
    }
    local info_options = {
        {
            title = locale('info'),
            icon = 'fa-solid fa-circle-info',
            description = locale('info_long')
        }
    }
    
    lib.callback('k-referral:hasCode', false, function(own, used)
        if not own then
            table.insert(referral_options, 1, {
                title = locale('create'),
                description = locale('create_description'),
                icon = 'fa-solid fa-plus',
                onSelect = createCode
            })
        else
            table.insert(info_options, {
                title = locale('code')..(not own and 'none' or own),
                icon = 'fa-solid fa-ticket',
                description = locale('code_description')
            })
            table.insert(info_options, {
                title = locale('uses')..lib.callback.await('k-referral:getUseCount', false, own),
                icon = 'fa-solid fa-user',
                description = locale('uses_description')
            })
            table.insert(info_options, {
                title = locale('unclaimed')..lib.callback.await('k-referral:getUnclaimedUseCount', false, own),
                icon = 'fa-solid fa-money-bill',
                description = locale('unclaimed_description')
            })
        end
        if not used then
            table.insert(referral_options, 2, {
                title = locale('redeem_code'),
                description = locale('redeem_description'),
                icon = 'fa-solid fa-tag',
                onSelect = redeemCode
            })
        end

        lib.registerContext({
            id = 'information',
            menu = 'referral',
            title = locale('info'),
            options = info_options
        })
        
        lib.registerContext({
            id = 'referral',
            title = locale('referral_sys'),
            options = referral_options
        })

        lib.showContext('referral')
    end)
end

RegisterCommand(cfg.CommandName, function(source)
    lib.callback.await('k-referral:firstTime', false)
    openMenu()
end, false)

TriggerEvent('chat:addSuggestion', '/'..cfg.CommandName, locale('open_menu'))