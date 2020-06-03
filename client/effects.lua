local Threads = {}
local Offset = 1

AnimateUI = {}


function RandomID(length)
    local res = ""
    math.randomseed(GetGameTimer() + Offset)
    for i = 1, length do
        res = res .. string.char(math.random(97, 122))
    end
    Offset = Offset + 1
    return res
end

function MergeConfig(Copy, Settings)
    for k,v in pairs(Settings) do Copy[k] = v end
    return Copy
end

function Override(Settings, Key)
    local Element = Config[Key]
    if Settings ~= nil then
        if Settings[Key] ~= nil then
            Element = Settings[Key]
        end
    end
    
    return Element
end

-- MAIN RENDER THREADS
AnimateUI.Run = function(Message, Settings, Element, Func, Interval, Timeout, Exit, Callback)
    local Copy = {
        Font         = Config.Font,
        Size         = Config.Size,
        PositionX    = Config.PositionX,
        PositionY    = Config.PositionY,
        Opacity      = Config.Opacity
    }

    if Settings ~= nil then
        Copy = MergeConfig(Copy, Settings)
    end

    local Tick = true

    if type(Element) == 'table' then
        for Type, Value in pairs(Element) do
            if Value.Start ~= nil then
                Value.Start = { Key = Type, Value = Value.Start }
            else
                Value.Start = { Key = Type, Value = Copy[Type] }
            end

            if Value.End ~= nil then
                Value.End = { Key = Type, Value = Value.End }
            else
                Value.End = { Key = Type, Value = Copy[Type] }
            end
        end
    end

    local Index = #Threads + 1
    local ID = RandomID(20)
    table.insert(Threads, Index, {
        Tick = true,
        ID = ID
    })

    for k,v in pairs(Threads) do print(k,v.ID) end

    local Thread = Threads[Index]
    
    Citizen.CreateThread(function()
        local StartTime = GetGameTimer()
        while Thread.Tick do
            local CurrentTime = GetGameTimer() - StartTime

            if CurrentTime < Interval then
                for Type, Value in pairs(Element) do
                    Copy[Type] = Easing[Func](CurrentTime, Value.Start.Value, Value.End.Value - Value.Start.Value, Interval)
                end
            else
                for Type, Value in pairs(Element) do
                    if Copy[Type] > Value.End.Value or Copy[Type] < Value.End.Value then
                        Copy[Type] = Value.End.Value
                    end
                end

                Citizen.Wait(Timeout)

                -- Exit animation
                if Exit ~= nil then
                    if type(Exit) == 'table' then
                        if Exit.Duration == nil then
                            Exit.Duration = Interval
                        end
                        AnimateUI[Exit.Effect](Message, Settings, Exit.Duration, 0, Callback)
                    elseif type(Exit) == 'string' then
                        AnimateUI[Exit](Message, Settings, Interval, 0, Callback)
                    end
                    Citizen.Wait(20)
                    Thread.Tick = false
                    Threads[Index] = nil
                    break
                else
                    Thread.Tick = false
                    Threads[Index] = nil
                    
                    if Callback ~= nil then
                        Callback(ID)
                    end
                end                     
            end
                     
            Citizen.Wait(0)
        end
    end)
                
    Citizen.CreateThread(function()
        while Thread.Tick do
            AnimateUI.RenderMessage(Message, Copy.PositionX, Copy.PositionY, Copy.Size, Copy.Font, math.floor(Copy.Opacity))
            Citizen.Wait(0)
        end
    end)

    return ID
end

AnimateUI.Kill = function(ID)
    for _, v in pairs(Threads) do
        if v.ID == ID then
            v.Tick = false
        end
    end
end

AnimateUI.RenderMessage = function(text, x, y, scale, font, a)
    if x == nil then  x = 0.5 end
    if y == nil then y = 0.5 end 
    if a == nil then a = 255 end   

    SetTextFont(font)
    SetTextProportional(true)
    SetTextCentre(true)
    SetTextScale(scale, scale)
    SetTextColour(Config.Color.R, Config.Color.G, Config.Color.B, a)
    SetTextDropShadow(0, 0, 0, 0, a)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, a)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--                             FADE EFFECTS                              --
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- FADE IN
AnimateUI.FadeIn = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { Opacity = { Start = 0 } }, 'linear', Interval, Timeout, Exit, cb)  
end

AnimateUI.FadeInDown = function(Message, Settings, Interval, Timeout, Exit, cb)
    local PositionY = Override(Settings, "PositionY")
    local Opacity   = Override(Settings, "Opacity")

    return AnimateUI.Run(Message, Settings, {
        PositionY = {
            Start = PositionY - 0.10,
            End = PositionY
        },
        Opacity = {
            Start = 0,
            End = Opacity
        }
    }, 'linear', Interval, Timeout, Exit, cb)
end

AnimateUI.FadeInUp = function(Message, Settings, Interval, Timeout, Exit, cb)
    local PositionY = Override(Settings, "PositionY")
    local Opacity   = Override(Settings, "Opacity")

    return AnimateUI.Run(Message, Settings, {
        PositionY = {
            Start = PositionY + 0.10,
            End = PositionY
        },
        Opacity = {
            Start = 0,
            End = Opacity
        }
    }, 'linear', Interval, Timeout, Exit, cb)
end

AnimateUI.FadeInLeft = function(Message, Settings, Interval, Timeout, Exit, cb)
    local PositionX = Override(Settings, "PositionX")
    local Opacity   = Override(Settings, "Opacity")

    return AnimateUI.Run(Message, Settings, {
        PositionX = {
            Start = PositionX - 0.10,
            End = PositionX
        },
        Opacity = {
            Start = 0,
            End = Opacity
        }
    }, 'linear', Interval, Timeout, Exit, cb)
end

AnimateUI.FadeInRight = function(Message, Settings, Interval, Timeout, Exit, cb)
    local PositionX = Override(Settings, "PositionX")
    local Opacity   = Override(Settings, "Opacity")

    return AnimateUI.Run(Message, Settings, {
        PositionX = {
            Start = PositionX + 0.10,
            End = PositionX
        },
        Opacity = {
            Start = 0,
            End = Opacity
        }
    }, 'linear', Interval, Timeout, Exit, cb)
end


-- FADE OUT
AnimateUI.FadeOut = function(Message, Settings, Interval, Timeout, cb)
    local Opacity   = Override(Settings, "Opacity")   
    return AnimateUI.Run(Message, Settings, { Opacity = { Start = Opacity, End = 0 } }, 'linear', Interval, Timeout, nil, cb)  
end

AnimateUI.FadeOutUp = function(Message, Settings, Interval, Timeout, cb)
    local PositionY = Override(Settings, "PositionY")
    local Opacity   = Override(Settings, "Opacity")

    return AnimateUI.Run(Message, Settings, {
        PositionY = {
            Start = PositionY,
            End = PositionY - 0.10
        },
        Opacity = {
            Start = Opacity,
            End = 0
        }
    }, 'linear', Interval, Timeout, nil, cb)
end

AnimateUI.FadeOutDown = function(Message, Settings, Interval, Timeout, cb)
    local PositionY = Override(Settings, "PositionY")
    local Opacity   = Override(Settings, "Opacity")

    return AnimateUI.Run(Message, Settings, {
        PositionY = {
            Start = PositionY,
            End = PositionY + 0.10
        },
        Opacity = {
            Start = Opacity,
            End = 0
        }
    }, 'linear', Interval, Timeout, nil, cb)
end

AnimateUI.FadeOutLeft = function(Message, Settings, Interval, Timeout, cb)
    local PositionX = Override(Settings, "PositionX")
    local Opacity   = Override(Settings, "Opacity")    

    return AnimateUI.Run(Message, Settings, {
        PositionX = {
            Start = PositionX,
            End = PositionX - 0.10
        },
        Opacity = {
            Start = Opacity,
            End = 0
        }
    }, 'linear', Interval, Timeout, nil, cb)
end

AnimateUI.FadeOutRight = function(Message, Settings, Interval, Timeout, cb)

    local PositionX = Override(Settings, "PositionX")
    local Opacity   = Override(Settings, "Opacity")    

    return AnimateUI.Run(Message, Settings, {
        PositionX = {
            Start = PositionX,
            End = PositionX + 0.10
        },
        Opacity = {
            Start = Opacity,
            End = 0
        }
    }, 'linear', Interval, Timeout, nil, cb)
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--                             SLIDE EFFECTS                             --
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- SLIDE IN EFFECTS
AnimateUI.SlideInDown = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { PositionY = { Start = -0.1 } }, 'linear', Interval, Timeout, Exit, cb)
end

AnimateUI.SlideInUp = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { PositionY = { Start = 1.1 } }, 'linear', Interval, Timeout, Exit, cb)
end

AnimateUI.SlideInLeft = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { PositionX = { Start = -0.1 } }, 'linear', Interval, Timeout, Exit, cb)
end

AnimateUI.SlideInRight = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { PositionX = { Start = 1.1 } }, 'linear', Interval, Timeout, Exit, cb)
end

-- SLIDE OUT EFFECTS
AnimateUI.SlideOutDown = function(Message, Settings, Interval, Timeout, cb)
    local PositionY = Override(Settings, "PositionY")
    return AnimateUI.Run(Message, Settings, { PositionY = { Start = PositionY, End = 1.1 } }, 'linear', Interval, Timeout, nil, cb)
end

AnimateUI.SlideOutUp = function(Message, Settings, Interval, Timeout, cb)
    local PositionY = Override(Settings, "PositionY")
    return AnimateUI.Run(Message, Settings, { PositionY = { Start = PositionY, End = -0.1 } }, 'linear', Interval, Timeout, nil, cb)
end

AnimateUI.SlideOutLeft = function(Message, Settings, Interval, Timeout, cb)
    local PositionX = Override(Settings, "PositionX")
    return AnimateUI.Run(Message, Settings, { PositionX = { Start = PositionX, End = -0.1 } }, 'linear', Interval, Timeout, nil, cb)
end

AnimateUI.SlideOutRight = function(Message, Settings, Interval, Timeout, cb)
    local PositionX = Override(Settings, "PositionX")
    return AnimateUI.Run(Message, Settings, { PositionX = { Start = PositionX, End = 1.1 } }, 'linear', Interval, Timeout, nil, cb)
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--                            BOUNCE EFFECTS                             --
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- BOUNCE IN

AnimateUI.BounceIn = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { Size = { Start = 0 } }, 'inBounce', Interval, Timeout, Exit, cb)
end

AnimateUI.BounceInUp = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { PositionY = { Start = 1.1 } }, 'inBounce', Interval, Timeout, Exit, cb)
end

AnimateUI.BounceInDown = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { PositionY = { Start = -0.1 } }, 'inBounce', Interval, Timeout, Exit, cb)
end

AnimateUI.BounceInLeft = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { PositionX = { Start = -0.1 } }, 'inBounce', Interval, Timeout, Exit, cb)
end

AnimateUI.BounceInRight = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { PositionX = { Start = 1.1 } }, 'inBounce', Interval, Timeout, Exit, cb)
end

-- BOUNCE OUT
AnimateUI.BounceOut = function(Message, Settings, Interval, Timeout, cb)
    local Size = Override(Settings, "Size")  
    return AnimateUI.Run(Message, Settings, { Size = { Start = Size, End = 0 } }, 'outBounce', Interval, Timeout, nil, cb)
end

AnimateUI.BounceOutUp = function(Message, Settings, Interval, Timeout, cb)
    local PositionY = Override(Settings, "PositionY") 
    return AnimateUI.Run(Message, Settings, { PositionY = { Start = PositionY, End = -0.1 } }, 'outBounce', Interval, Timeout, nil, cb)
end

AnimateUI.BounceOutDown = function(Message, Settings, Interval, Timeout, cb)
    local PositionY = Override(Settings, "PositionY")  
    return AnimateUI.Run(Message, Settings, { PositionY = { Start = PositionY, End = 1.1 } }, 'outBounce', Interval, Timeout, nil, cb)
end

AnimateUI.BounceOutLeft = function(Message, Settings, Interval, Timeout, cb)
    local PositionX = Override(Settings, "PositionX")   
    return AnimateUI.Run(Message, Settings, { PositionX = { Start = PositionX, End = -0.1 } }, 'outBounce', Interval, Timeout, nil, cb)
end

AnimateUI.BounceOutRight = function(Message, Settings, Interval, Timeout, cb)
    local PositionX = Override(Settings, "PositionX")    
    return AnimateUI.Run(Message, Settings, { PositionX = { Start = PositionX, End = 1.1 } }, 'outBounce', Interval, Timeout, nil, cb)
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--                             ZOOM EFFECTS                              --
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- ZOOM IN
AnimateUI.ZoomIn = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { Size = { Start = 0 } }, 'linear', Interval, Timeout, Exit, cb)
end

-- ZOOM OUT
AnimateUI.ZoomOut = function(Message, Settings, Interval, Timeout, cb)
    local Size = Override(Settings, "Size")  
    return AnimateUI.Run(Message, Settings, { Size = { Start = Size, End = 0 } }, 'linear', Interval, Timeout, nil, cb)
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--                            ELASTIC EFFECTS                            --
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- ELASTIC IN
AnimateUI.ElasticIn = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, {Size = { Start = 0 } }, 'inElastic', Interval, Timeout, Exit, cb)
end

AnimateUI.ElasticInUp = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { PositionY = { Start = 1.0 } }, 'inElastic', Interval, Timeout, Exit, cb)
end

AnimateUI.ElasticInDown = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { PositionY = { Start = 0 } }, 'inElastic', Interval, Timeout, Exit, cb)
end

AnimateUI.ElasticInLeft = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { PositionX = { Start = 0 } }, 'inElastic', Interval, Timeout, Exit, cb)
end

AnimateUI.ElasticInRight = function(Message, Settings, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, Settings, { PositionX = { Start = 1.0 } }, 'inElastic', Interval, Timeout, Exit, cb)
end

-- ELASTIC OUT
AnimateUI.ElasticOut = function(Message, Settings, Interval, Timeout, cb)
    local Size = Override(Settings, "Size")    
    return AnimateUI.Run(Message, Settings, {Size = { Start = Config.Size, End = 0 } }, 'outElastic', Interval, Timeout, nil, cb)
end

AnimateUI.ElasticOutUp = function(Message, Settings, Interval, Timeout, cb)
    local PositionY = Override(Settings, "PositionY")  
    return AnimateUI.Run(Message, Settings, { PositionY = { Start = PositionY, End = -0.1 } }, 'outElastic', Interval, Timeout, nil, cb)
end

AnimateUI.ElasticOutDown = function(Message, Settings, Interval, Timeout, cb)
    local PositionY = Override(Settings, "PositionY")        
    return AnimateUI.Run(Message, Settings, { PositionY = { Start = PositionY, End = 1.1 } }, 'outElastic', Interval, Timeout, nil, cb)
end

AnimateUI.ElasticOutLeft = function(Message, Settings, Interval, Timeout, cb)
    local PositionX = Override(Settings, "PositionX")        
    return AnimateUI.Run(Message, Settings, { PositionX = { Start = PositionX, End = -0.1 } }, 'outElastic', Interval, Timeout, nil, cb)
end

AnimateUI.ElasticOutRight = function(Message, Settings, Interval, Timeout, cb)
    local PositionX = Override(Settings, "PositionX")      
    return AnimateUI.Run(Message, Settings, { PositionX = { Start = PositionX, End = 1.1 } }, 'outElastic', Interval, Timeout, nil, cb)
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--                           TYPEWRITER EFFECTS                          --
---------------------------------------------------------------------------
---------------------------------------------------------------------------

AnimateUI.TypewriterIn = function(Message, Settings, Interval, Timeout, Exit, Callback)
    local Count = 0
    local Length = string.len(Message)

    local Copy = {
        Font         = Config.Font,
        Size         = Config.Size,
        PositionX    = Config.PositionX,
        PositionY    = Config.PositionY,
        Opacity      = Config.Opacity
    }

    if Settings ~= nil then
        Copy = MergeConfig(Copy, Settings)
    end

    local Index = #Threads + 1
    local ID = RandomID(20)
    table.insert(Threads, Index, {
        Tick = true,
        ID = ID
    })

    local Thread = Threads[Index]

    Citizen.CreateThread(function()
        while Thread.Tick do
            if Count < Length then
                Count = Count + 1
                Str = string.sub(Message, 0, Count)

                if Count == Length then
                    Citizen.Wait(Timeout)

                    -- Exit animation
                    if Exit ~= nil then
                        if type(Exit) == 'table' then
                            if Exit.Duration == nil then
                                Exit.Duration = Interval
                            end
                            AnimateUI[Exit.Effect](Message, Settings, Exit.Duration, 0, Callback)
                        elseif type(Exit) == 'string' then
                            AnimateUI[Exit](Message, Settings, Interval, 0, Callback)
                        end
                        Citizen.Wait(10)
                        Thread.Tick = false
                        Threads[Index] = nil
                        break
                    else
                        Thread.Tick = false
                        Threads[Index] = nil
                        
                        if Callback ~= nil then
                            Callback()
                        end
                    end 
                end
            end
            Citizen.Wait(Interval)
        end
    end)

    Citizen.CreateThread(function()
        while Thread.Tick do
            AnimateUI.RenderMessage(Str, Copy.PositionX, Copy.PositionY, Copy.Size, Copy.Font, Copy.Opacity)
            Citizen.Wait(0)
        end
    end) 
    
    return ID
end

AnimateUI.TypewriterOut = function(Message, Settings, Interval, Timeout, cb)
    local Length = string.len(Message)
    local Count = Length
    local Copy = {
        Font         = Config.Font,
        Size         = Config.Size,
        PositionX    = Config.PositionX,
        PositionY    = Config.PositionY,
        Opacity      = Config.Opacity
    }

    if Settings ~= nil then
        Copy = MergeConfig(Copy, Settings)
    end

    local Index = #Threads + 1
    local ID = RandomID(20)
    table.insert(Threads, Index, {
        Tick = true,
        ID = ID
    })

    local Thread = Threads[Index]

    Citizen.CreateThread(function()
        while Thread.Tick do
            if Count > 0 then
                Count = Count - 1
                Str = string.sub(Message, 0, Count)

                if Count == 0 then
                    Citizen.Wait(Timeout)

                    Thread.Tick = false
                    Threads[Index] = nil

                    Count = 0

                    if cb ~= nil then
                        cb()
                    end
                end
            end
            Citizen.Wait(Interval)
        end
    end)

    Citizen.CreateThread(function()
        while Thread.Tick do
            AnimateUI.RenderMessage(Str, Copy.PositionX, Copy.PositionY, Copy.Size, Copy.Font, Copy.Opacity)
            Citizen.Wait(0)
        end
    end)    

    return ID
end