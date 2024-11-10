if GetResourceState("es_extended") ~= "started" then return end

ESX = exports["es_extended"]:getSharedObject()

Framework = {
    GetIdentifier = function(source)
        local player = ESX.GetPlayerFromId(source)
        if not player then return end
        return player.getIdentifier()
    end
}