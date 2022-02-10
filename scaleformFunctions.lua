Scaleform = {}
function Scaleform.Request(scaleform)
    local scaleform_handle = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform_handle) do
        Citizen.Wait(0)
    end
    return scaleform_handle
end

function Scaleform.CallFunction(scaleform, returndata, the_function, ...)
    BeginScaleformMovieMethod(scaleform, the_function)
    local args = {...}

    if args ~= nil then
        for i = 1,#args do
            local arg_type = type(args[i])

            if arg_type == "boolean" then
                ScaleformMovieMethodAddParamBool(args[i])
            elseif arg_type == "number" then
                if not string.find(args[i], '%.') then
                    PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", true)
                    ScaleformMovieMethodAddParamInt(args[i])
                    
                else
                    ScaleformMovieMethodAddParamFloat(args[i])
                end
            elseif arg_type == "string" then
                ScaleformMovieMethodAddParamTextureNameString(args[i])
            end
        end

        if not returndata then
            EndScaleformMovieMethod()
        else
            return EndScaleformMovieMethodReturnValue()
        end
    end
end

function showCountdown(_number, _r, _g, _b)
    local scaleform = Scaleform.Request('COUNTDOWN')
    
    Scaleform.CallFunction(scaleform, false, "SET_MESSAGE", _number, _r, _g, _b, true)
    Scaleform.CallFunction(scaleform, false, "FADE_MP", _number, _r, _g, _b)

    return scaleform
end
function showCountdown2(_r, _g, _b, _waitTime, _playSound)
    local showCD = true
    local time = _waitTime
    local scale = 0
    if _playSound ~= nil and _playSound == true then
        
       
    end
    scale = showCountdown(time, _r, _g, _b)
    Citizen.CreateThread(function()
        while showCD do
            Citizen.Wait(1000)
            if time > 1 then
                time = time - 1
                scale = showCountdown(time, _r, _g, _b)
                
            elseif time == 1 then
                time = time - 1
                PlaySoundFrontend(-1, "Go", "DLC_EXEC_ARC_MAC_SOUNDS", true)
                scale = showCountdown("GO", _r, _g, _b)
                PlaySoundFrontend(-1, "Go", "DLC_EXEC_ARC_MAC_SOUNDS", true)
                
            else
                showCD = false
            end
        end
    end)
    Citizen.CreateThread(function()
        while showCD do
            Citizen.Wait(1)
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
    
end
