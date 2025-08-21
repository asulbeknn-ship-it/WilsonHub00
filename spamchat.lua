local TextChatService = game:GetService("TextChatService")

task.spawn(function()
    local chatChannel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
    
    while true do
        chatChannel:SendAsync("I'm Wilson join my team тШая╕ПЁЯдл")
        task.wait(math.random(9))
    end
end)

print("Script de spam modificado iniciado.")
