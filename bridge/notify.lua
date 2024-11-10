local cfg = lib.callback.await('k-referral:getConfig', false)

function Notify(title, description, ntype)
    if cfg.NotificationType == 'ox_lib' then
        lib.notify({ title = title, description = description, type = ntype })
    elseif cfg.NotificationType == 'okokNotify' then
        exports['okokNotify']:Alert(title, description, 3000, ntype)
    elseif cfg.NotificationType == 'framework' then
        if GetResourceState("es_extended") ~= "started" then
            ESX = exports["es_extended"]:getSharedObject()
            ESX.ShowNotification(description, ntype)
        elseif GetResourceState("qb-core") ~= "started" then
            QBCore = exports["qb-core"]:GetCoreObject()
            QBCore.Functions.Notify(description, ntype)
        elseif GetResourceState("qbx_core") ~= "started" then
            exports.qbx_core:Notify(description, ntype)
        end
    else
        print("There is an error with your Config.")
    end
end