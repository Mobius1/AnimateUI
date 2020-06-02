Threads = {}
AnimateUI = {}


function RandomID(length)
    local res = ""
    math.randomseed(GetGameTimer())
    for i = 1, length do
        res = res .. string.char(math.random(97, 122))
    end
    return res
end

-- MAIN RENDER THREADS
AnimateUI.Run = function(Message, Element, Func, Interval, Timeout, Exit, Callback)
    local Copy = {
        Size         = Config.Size,
        PositionX    = Config.PositionX,
        PositionY    = Config.PositionY,
        Opacity      = Config.Opacity
    }

    local Tick = true
    local StartTime = GetGameTimer()

    if type(Element) == 'table' then
        for Type, Value in pairs(Element) do
            Copy[Type] = Value.Start

            if Value.End == nil then
                Value.End = Config[Type]
            end
        end
    end

    local Pos = #Threads + 1
    local ID = RandomID(20)
    table.insert(Threads, Pos, {
        Tick = true,
        ID = ID
    })

    local Thread = Threads[Pos]

    
    Citizen.CreateThread(function()
        while Thread.Tick do
            local CurrentTime = GetGameTimer() - StartTime
            
            if CurrentTime <= Interval then
                for Type, Value in pairs(Element) do
                    Copy[Type] = Easing[Func](CurrentTime, Value.Start, Value.End - Value.Start, Interval)
                end
            else
                Citizen.Wait(Timeout)

                -- Exit animation
                if Exit ~= nil then
                    if type(Exit) == 'table' then
                        if Exit.Duration == nil then
                            Exit.Duration = Interval
                        end
                        AnimateUI[Exit.Effect](Message, Exit.Duration, 0, Callback)
                    elseif type(Exit) == 'string' then
                        AnimateUI[Exit](Message, Interval, 0, Callback)
                    end
                    Citizen.Wait(10)
                    Thread.Tick = false
                    Threads[Pos] = nil
                    break
                else
                    Thread.Tick = false
                    Threads[Pos] = nil
                    
                    if Callback ~= nil then
                        Callback()
                    end
                end                     
            end
                     
            Citizen.Wait(0)
        end
    end)
                
    Citizen.CreateThread(function()
        while Thread.Tick do
            AnimateUI.RenderMessage(Message, Copy.PositionX, Copy.PositionY, Copy.Size, math.floor(Copy.Opacity))
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

AnimateUI.RenderMessage = function(text, x, y, scale, a)
    if x == nil then  x = 0.5 end
    if y == nil then y = 0.5 end 
    if a == nil then a = 255 end   

    SetTextFont(Config.Font)
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
AnimateUI.FadeIn = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { Opacity = { Start = 0 } }, 'linear', Interval, Timeout, Exit, cb)  
end

AnimateUI.FadeInDown = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, {
        PositionY = {
            Start = Config.PositionY - 0.10,
            End = Config.PositionY
        },
        Opacity = {
            Start = 0,
            End = Config.Opacity
        }
    }, 'linear', Interval, Timeout, Exit, cb)
end

AnimateUI.FadeInUp = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, {
        PositionY = {
            Start = Config.PositionY + 0.10,
            End = Config.PositionY
        },
        Opacity = {
            Start = 0,
            End = Config.Opacity
        }
    }, 'linear', Interval, Timeout, Exit, cb)
end

AnimateUI.FadeInLeft = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, {
        PositionX = {
            Start = Config.PositionX + 0.10,
            End = Config.PositionX
        },
        Opacity = {
            Start = 0,
            End = Config.Opacity
        }
    }, 'linear', Interval, Timeout, Exit, cb)
end

AnimateUI.FadeInRight = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, {
        PositionX = {
            Start = Config.PositionX + 0.10,
            End = Config.PositionX
        },
        Opacity = {
            Start = 0,
            End = Config.Opacity
        }
    }, 'linear', Interval, Timeout, Exit, cb)
end


-- FADE OUT
AnimateUI.FadeOut = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { Opacity = { Start = Config.Opacity, End = 0 } }, 'linear', Interval, Timeout, nil, cb)  
end

AnimateUI.FadeOutUp = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, {
        PositionY = {
            Start = Config.PositionY,
            End = Config.PositionY - 0.10
        },
        Opacity = {
            Start = Config.Opacity,
            End = 0
        }
    }, 'linear', Interval, Timeout, nil, cb)
end

AnimateUI.FadeOutDown = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, {
        PositionY = {
            Start = Config.PositionY,
            End = Config.PositionY + 0.10
        },
        Opacity = {
            Start = Config.Opacity,
            End = 0
        }
    }, 'linear', Interval, Timeout, nil, cb)
end

AnimateUI.FadeOutLeft = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, {
        PositionX = {
            Start = Config.PositionX,
            End = Config.PositionX + 0.10
        },
        Opacity = {
            Start = Config.Opacity,
            End = 0
        }
    }, 'linear', Interval, Timeout, nil, cb)
end

AnimateUI.FadeOutRight = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, {
        PositionX = {
            Start = Config.PositionX,
            End = Config.PositionX + 0.10
        },
        Opacity = {
            Start = Config.Opacity,
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
AnimateUI.SlideInDown = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { PositionY = { Start = 0 } }, 'linear', Interval, Timeout, Exit, cb)
end

AnimateUI.SlideInUp = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { PositionY = { Start = 1.0 } }, 'linear', Interval, Timeout, Exit, cb)
end

AnimateUI.SlideInLeft = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { PositionX = { Start = 0 } }, 'linear', Interval, Timeout, Exit, cb)
end

AnimateUI.SlideInRight = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { PositionX = { Start = 1.0 } }, 'linear', Interval, Timeout, Exit, cb)
end

-- SLIDE OUT EFFECTS
AnimateUI.SlideOutDown = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { PositionY = { Start = Config.PositionY, End = 1.1 } }, 'linear', Interval, Timeout, nil, cb)
end

AnimateUI.SlideOutUp = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { PositionY = { Start = Config.PositionY, End = -0.1 } }, 'linear', Interval, Timeout, nil, cb)
end

AnimateUI.SlideOutLeft = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { PositionX = { Start = Config.PositionX, End = -0.1 } }, 'linear', Interval, Timeout, nil, cb)
end

AnimateUI.SlideOutRight = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { PositionX = { Start = Config.PositionX, End = 1.1 } }, 'linear', Interval, Timeout, nil, cb)
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--                            BOUNCE EFFECTS                             --
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- BOUNCE IN

AnimateUI.BounceIn = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { Size = { Start = 0 } }, 'inBounce', Interval, Timeout, Exit, cb)
end

AnimateUI.BounceInUp = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { PositionY = { Start = 1.0 } }, 'inBounce', Interval, Timeout, Exit, cb)
end

AnimateUI.BounceInDown = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { PositionY = { Start = 0 } }, 'inBounce', Interval, Timeout, Exit, cb)
end

AnimateUI.BounceInLeft = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { PositionX = { Start = 0 } }, 'inBounce', Interval, Timeout, Exit, cb)
end

AnimateUI.BounceInRight = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { PositionX = { Start = 1.0 } }, 'inBounce', Interval, Timeout, Exit, cb)
end

-- BOUNCE OUT
AnimateUI.BounceOut = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { Size = { Start = Config.Size, End = 0 } }, 'outBounce', Interval, Timeout, nil, cb)
end

AnimateUI.BounceOutUp = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { PositionY = { Start = Config.PositionY, End = -0.1 } }, 'outBounce', Interval, Timeout, nil, cb)
end

AnimateUI.BounceOutDown = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { PositionY = { Start = Config.PositionY, End = 1.1 } }, 'outBounce', Interval, Timeout, nil, cb)
end

AnimateUI.BounceOutLeft = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { PositionX = { Start = Config.PositionX, End = -0.1 } }, 'outBounce', Interval, Timeout, nil, cb)
end

AnimateUI.BounceOutRight = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { PositionX = { Start = Config.PositionX, End = 1.1 } }, 'outBounce', Interval, Timeout, nil, cb)
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--                             ZOOM EFFECTS                              --
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- ZOOM IN
AnimateUI.ZoomIn = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { Size = { Start = 0 } }, 'linear', Interval, Timeout, Exit, cb)
end

-- ZOOM OUT
AnimateUI.ZoomOut = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { Size = { Start = Config.Size, End = 0 } }, 'linear', Interval, Timeout, nil, cb)
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--                            ELASTIC EFFECTS                            --
---------------------------------------------------------------------------
---------------------------------------------------------------------------

-- ELASTIC IN
AnimateUI.ElasticIn = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, {Size = { Start = 0 } }, 'inElastic', Interval, Timeout, Exit, cb)
end

AnimateUI.ElasticInUp = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { PositionY = { Start = 1.0 } }, 'inElastic', Interval, Timeout, Exit, cb)
end

AnimateUI.ElasticInDown = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { PositionY = { Start = 0 } }, 'inElastic', Interval, Timeout, Exit, cb)
end

AnimateUI.ElasticInLeft = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { PositionX = { Start = 0 } }, 'inElastic', Interval, Timeout, Exit, cb)
end

AnimateUI.ElasticInRight = function(Message, Interval, Timeout, Exit, cb)
    return AnimateUI.Run(Message, { PositionX = { Start = 1.0 } }, 'inElastic', Interval, Timeout, Exit, cb)
end

-- ELASTIC OUT
AnimateUI.ElasticOut = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, {Size = { Start = Config.Size, End = 0 } }, 'outElastic', Interval, Timeout, nil, cb)
end

AnimateUI.ElasticOutUp = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { PositionY = { Start = Config.PositionY, End = -0.1 } }, 'outElastic', Interval, Timeout, nil, cb)
end

AnimateUI.ElasticOutDown = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { PositionY = { Start = Config.PositionY, End = 1.1 } }, 'outElastic', Interval, Timeout, nil, cb)
end

AnimateUI.ElasticOutLeft = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { PositionX = { Start = Config.PositionX, End = -0.1 } }, 'outElastic', Interval, Timeout, nil, cb)
end

AnimateUI.ElasticOutRight = function(Message, Interval, Timeout, cb)
    return AnimateUI.Run(Message, { PositionX = { Start = Config.PositionX, End = 1.1 } }, 'outElastic', Interval, Timeout, nil, cb)
end


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--                           TYPEWRITER EFFECTS                          --
---------------------------------------------------------------------------
---------------------------------------------------------------------------

AnimateUI.TypewriterIn = function(Message, Interval, Timeout, Exit, Callback)
    local Count = 0
    local Length = string.len(Message)

    local Pos = #Threads + 1
    local ID = RandomID(20)
    table.insert(Threads, Pos, {
        Tick = true,
        ID = ID
    })

    local Thread = Threads[Pos]

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
                            AnimateUI[Exit.Effect](Message, Exit.Duration, 0, Callback)
                        elseif type(Exit) == 'string' then
                            AnimateUI[Exit](Message, Interval, 0, Callback)
                        end
                        Citizen.Wait(10)
                        Thread.Tick = false
                        Threads[Pos] = nil
                        break
                    else
                        Thread.Tick = false
                        Threads[Pos] = nil
                        
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
            AnimateUI.RenderMessage(Str, Config.PositionX, Config.PositionY, Config.Size, Config.Opacity)
            Citizen.Wait(0)
        end
    end) 
    
    return ID
end

AnimateUI.TypewriterOut = function(Message, Interval, Timeout, cb)
    local Length = string.len(Message)
    local Count = Length

    local Pos = #Threads + 1
    local ID = RandomID(20)
    table.insert(Threads, Pos, {
        Tick = true,
        ID = ID
    })

    local Thread = Threads[Pos]

    Citizen.CreateThread(function()
        while Thread.Tick do
            if Count > 0 then
                Count = Count - 1
                Str = string.sub(Message, 0, Count)

                if Count == 0 then
                    Citizen.Wait(Timeout)

                    Thread.Tick = false
                    Threads[Pos] = nil

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
            AnimateUI.RenderMessage(Str, Config.PositionX, Config.PositionY, Config.Size, Config.Opacity)
            Citizen.Wait(0)
        end
    end)    

    return ID
end