function showMessage(Message, Type, Interval, Timeout, Exit, Callback)
    if AnimateUI[Type] then
        return AnimateUI[Type](Message, Interval, Timeout, Exit, Callback)
    end

    return false
end

function removeMessage(ID)
    AnimateUI.Kill(ID)
end