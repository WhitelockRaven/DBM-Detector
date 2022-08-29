successfulRequest = C_ChatInfo.RegisterAddonMessagePrefix("D4BC")
successfulRequest = C_ChatInfo.RegisterAddonMessagePrefix("BigWigs")

-- Local variable declarations and initiations
local registeredPrefixes = C_ChatInfo.GetRegisteredAddonMessagePrefixes()
local playernames = {}
showchatmessage = true
ignoreguild = true
ignorereapeated = false
local prefixtofilterfor = "D4BC, BigWigs"

-- Function to make one multi-line string out of the table fullstring
local function MakeNameString()
	local fullstring = ""
	for k,v in pairs(playernames) do 
		fullstring = fullstring .. k .. ':' .. v .. '\n'
	end
	return fullstring 
end


-- Used for the Interface/AddOns menu
local panel = CreateFrame("Frame")
panel.name = "DBM-Detector"               -- see panel fields
InterfaceOptions_AddCategory(panel)  -- see InterfaceOptions API

-- add widgets to the panel as desired
local title = panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
title:SetPoint("TOP", panel, 0, -10)
title:SetText("DBM-Detecor")


-- Actual text for messages recived
local names = panel:CreateFontString("ARTWORK", nil, "GameFontNormal")
names:SetPoint("CENTER")

-- The below Editbox would always be set at Focus, and thus effectively 'disable' the use of the keyboard for unkown reasons. 
-- 	Instead a hardcoded value is now used.
-- Editbox for which message prefix to look for
local prefixboxtitle = panel:CreateFontString("ARTWORK", nil, "GameFontNormal")
prefixboxtitle:SetPoint("TOPLEFT", panel, 10, -30)
prefixboxtitle:SetText("Prefixes to filter for:")
--[[
local prefixbox = CreateFrame("Editbox", nil, panel, "InputBoxTemplate")
prefixbox:ClearFocus()
prefixbox:SetPoint("TOPLEFT", panel, 10, -40)
prefixbox:SetText("D4BC, BigWigs")
prefixbox:SetHeight(25)
prefixbox:SetWidth(120)
prefixbox:ClearFocus()
]]--
local prefixbox = panel:CreateFontString("ARTWORK", nil, "GameFontNormal")
prefixbox:SetPoint("TOPLEFT", panel, 10, -45)
prefixbox:SetText(prefixtofilterfor)

-- Checkbox to show or not show messages in chat
local showmessagecheckbutton = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
showmessagecheckbutton:SetPoint("TOP", panel, -50, -40)
showmessagecheckbutton.Text:SetText("Show chat messages")
showmessagecheckbutton.SetValue = function(_, value)
	showchatmessage = (value == "1") -- value can be either "0" or "1"
end
showmessagecheckbutton:SetChecked(showchatmessage) -- set the initial checked state

-- Checkbox to ignore messages in from guild channel
local ignoreguildbutton = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
ignoreguildbutton:SetPoint("TOP", panel, -50, -70)
ignoreguildbutton.Text:SetText("Ignore Guild Messages")
ignoreguildbutton.SetValue = function(_, value)
	ignoreguild = (value == "1") -- value can be either "0" or "1"
end
ignoreguildbutton:SetChecked(ignoreguild) -- set the initial checked state

-- Checkbox to not write out repeated messages to the chat
local ignorerepeatebutton = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
ignorerepeatebutton:SetPoint("TOP", panel, -50, -100)
ignorerepeatebutton.Text:SetText("Ignore repeate messages")
ignorerepeatebutton.SetValue = function(_, value)
	ignorereapeated = (value == "1") -- value can be either "0" or "1"
end
ignorerepeatebutton:SetChecked(ignorereapeated) -- set the initial checked state

-- Reset Button
local resetbutton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
resetbutton:SetPoint("TOPRIGHT", panel, -10, -40)
resetbutton:SetText("Reset List")
resetbutton:SetHeight(25)
resetbutton:SetWidth(100)
resetbutton:SetScript("OnClick", function()
	playernames = {}
	names:SetText(MakeNameString())
end)


local function AddName(prefix, msg, type, sender)
	if playernames[sender] ~= nil then
		if not string.find(playernames[sender], prefix) then
			playernames[sender] = playernames[sender] .. ", " .. prefix
			print(prefix .. " message detected from " .. sender .. " in " .. type)
		end	
		if showchatmessage and not ignorereapeated then
			print(prefix .. " message detected from " .. sender .. " in " .. type)
		end		
	else
		playernames[sender] = prefix 
		if showchatmessage then
			print(prefix .. " message detected from " .. sender .. " in " .. type)
		end
	end
	names:SetText(MakeNameString())
end

print(registeredPrefixes)
local function CHAT_MSG_ADDON_CALLBACK(prefix, msg, type, sender)
	if sender ~= nil then
		if not (type == "GUILD" and ignoreguild) then 
			if string.find(prefixbox:GetText(), prefix) then
				AddName(prefix, msg, type, sender)
			end
		end
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
