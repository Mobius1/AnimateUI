-- Adapted from Robert Penner's Easing Functions

local function linear(t, b, c, d) return c * t / d + b end

local function inBounce(t, b, c, d)
    t = t / d
    if t < 1 / 2.75 then
        return c * (7.5625 * t * t) + b
    elseif t < 2 / 2.75 then
        t = t - (1.5 / 2.75)
        return c * (7.5625 * t * t + 0.75) + b
    elseif t < 2.5 / 2.75 then
        t = t - (2.25 / 2.75)
        return c * (7.5625 * t * t + 0.9375) + b
    else
        t = t - (2.625 / 2.75)
        return c * (7.5625 * t * t + 0.984375) + b
    end
end
    
local function outBounce(t, b, c, d)
    return c - inBounce(d - t, 0, c, d) + b
end

local function outElastic(t, b, c, d, a, p)
    if t == 0 then return b end
    
    t = t / d
    
    if t == 1  then return b + c end
    
    if not p then p = d * 0.3 end
    
    local s
    
    if not a or a < math.abs(c) then
        a = c
        s = p / 4
    else
        s = p / (2 * math.pi) * math.asin(c/a)
    end
    
    t = t - 1
    
    return -(a * math.pow(2, 10 * t) * math.sin((t * d - s) * (2 * math.pi) / p)) + b
end

local function inElastic(t, b, c, d, a, p)
    if t == 0 then return b end
    
    t = t / d
    
    if t == 1 then return b + c end
    
    if not p then p = d * 0.3 end
    
    local s
    
    if not a or a < math.abs(c) then
        a = c
        s = p / 4
    else
        s = p / (2 * math.pi) * math.asin(c/a)
    end
    
    return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * math.pi) / p) + c + b
end

Easing = {
    linear = linear,
    inBounce = inBounce,
    outBounce = outBounce,
    inElastic = inElastic,
    outElastic = outElastic,
}