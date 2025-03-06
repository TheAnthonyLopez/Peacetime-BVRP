local peacetimeActive = false
local peacetimeTime = 0

RegisterNetEvent("peacetime:startCountdown")
AddEventHandler("peacetime:startCountdown", function(time)
    peacetimeActive = true
    peacetimeTime = time

    Citizen.CreateThread(function()
        while peacetimeTime > 0 and peacetimeActive do
            Citizen.Wait(1000)
            peacetimeTime = peacetimeTime - 1
        end
        peacetimeActive = false
    end)
end)

RegisterNetEvent("peacetime:end")
AddEventHandler("peacetime:end", function()
    peacetimeActive = false
end)

-- HUD Display
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if peacetimeActive then
            DrawTextOnScreen("~y~Peacetime Active: ~w~" .. math.floor(peacetimeTime / 60) .. "m " .. (peacetimeTime % 60) .. "s", 0.5, 0.95, 0.6)
        end
    end
end)

-- Function to Draw Text on Screen
function DrawTextOnScreen(text, x, y, scale)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Sync Peacetime on Player Join
AddEventHandler("playerSpawned", function()
    TriggerServerEvent("peacetime:syncStatus")
end)
