function DrawAdvancedNativeText(x,y,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(254, 254, 254, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function disp_time(time)
    local minutes = math.floor((time % 3600) /60)
    local seconds = math.floor(time % 60)
    return string.format("%02d:%02d",minutes,seconds)
  end


function isLastCheckpoint(position, checkpointsTable, laps)
    if position == tablelength(checkpointsTable) then
        if laps == cfg.gameSettings.lapsInRace then
            return true
        end
        return nil
    end
    return false
end