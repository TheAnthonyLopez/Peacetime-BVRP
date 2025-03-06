local peacetimeActive = false
local peacetimeTime = 0

-- Configuration: Allowed Discord Role IDs (replace with actual role IDs)
local allowedRoles = {
    "123456789012345678", -- Example Role ID 1
    "987654321098765432"  -- Example Role ID 2
}

-- Check if player has the required Discord role
function hasPermission(src)
    for _, role in pairs(allowedRoles) do
        if exports.Badger_Discord_API:IsAceAllowed(src, "discord:" .. role) then
            return true
        end
    end
    return false
end

-- Peacetime Command
RegisterCommand("pt", function(source, args)
    local src = source
    if not hasPermission(src) then
        TriggerClientEvent("chat:addMessage", src, { args = { "^1Error", "You don't have permission to use this command." } })
        return
    end

    local minutes = tonumber(args[1])
    if not minutes or minutes <= 0 then
        TriggerClientEvent("chat:addMessage", src, { args = { "^1Usage", "/pt <minutes>" } })
        return
    end

    peacetimeTime = minutes * 60
    peacetimeActive = true
    TriggerClientEvent("peacetime:startCountdown", -1, peacetimeTime)

    TriggerClientEvent("chat:addMessage", -1, { args = { "^2Peacetime", "Peacetime has been activated for " .. minutes .. " minutes!" } })

    -- Timer to deactivate peacetime
    Citizen.CreateThread(function()
        while peacetimeTime > 0 do
            Citizen.Wait(1000)
            peacetimeTime = peacetimeTime - 1
        end
        peacetimeActive = false
        TriggerClientEvent("peacetime:end", -1)
        TriggerClientEvent("chat:addMessage", -1, { args = { "^1Peacetime", "Peacetime has ended!" } })
    end)
end)

-- Prevent players from using weapons during Peacetime
AddEventHandler("weaponDamageEvent", function(sender, data)
    if peacetimeActive then
        CancelEvent()
    end
end)

-- Sync peacetime status with new players
RegisterNetEvent("peacetime:syncStatus")
AddEventHandler("peacetime:syncStatus", function()
    if peacetimeActive then
        TriggerClientEvent("peacetime:startCountdown", source, peacetimeTime)
    end
end)
