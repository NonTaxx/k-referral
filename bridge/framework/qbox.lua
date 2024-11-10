if GetResourceState("qbx_core") ~= "started" then return end

QBX = exports.qbx_core

Framework = {
    GetIdentifier = function(source)
        local player = QBX:GetPlayer(source)
        if not player then return end
        return player.PlayerData.citizenid
    end
}

return Framework