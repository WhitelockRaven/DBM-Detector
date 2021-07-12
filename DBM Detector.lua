successfulRequest = C_ChatInfo.RegisterAddonMessagePrefix("D4BC")
successfulRequest = C_ChatInfo.RegisterAddonMessagePrefix("BigWigs")


local registeredPrefixes = C_ChatInfo.GetRegisteredAddonMessagePrefixes()

print(registeredPrefixes)
local function CHAT_MSG_ADDON_CALLBACK(prefix, msg, type, sender)
    if (prefix == "D4BC") then
        print("DBM message detected from " .. sender .. " in " .. type)
    end

    if (prefix == "BigWigs") then
        print("BigWigs message detected from " .. sender .. " in " .. type)
    end
end

local function FrameEventCallback(event, ...)
    if (event == "CHAT_MSG_ADDON") then
        CHAT_MSG_ADDON_CALLBACK(...)
    end
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", 
function(self, event, ...)
    FrameEventCallback(event, ...)
end)

frame:RegisterEvent("CHAT_MSG_ADDON")