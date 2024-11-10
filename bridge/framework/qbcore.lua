if GetResourceState("qb-core") ~= "started" then return end

QBCore = exports["qb-core"]:GetCoreObject()

Framework = {
    GetIdentifier = function(source)
        local player = QBCore.Functions.GetPlayer(source)
        if not player then return end
        return player.PlayerData.citizenid
    end
}

return Framework