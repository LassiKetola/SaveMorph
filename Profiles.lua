local _, Util = ...

local tableLength = function(table)
  local idx = 0
  for k, v in pairs(table) do
    idx = idx + 1
  end
  return idx
end

local reIndex = function(table)
  local index = 1
  local result = {}
  for k, v in pairs(table) do
    result[tostring(index)] = v
    index = index + 1
  end
  return result;
end

local profileSlots = {
  ["1"] = {["x"] = 10, ["y"] = -10},
  ["2"] = {["x"] = 49, ["y"] = -10},
  ["3"] = {["x"] = 88, ["y"] = -10},
  ["4"] = {["x"] = 127, ["y"] = -10},
  ["5"] = {["x"] = 10, ["y"] = -54},
  ["6"] = {["x"] = 49, ["y"] = -54},
  ["7"] = {["x"] = 88, ["y"] = -54},
  ["8"] = {["x"] = 127, ["y"] = -54}
}

local SM_ProfileFrame = CreateFrame("Frame", "SM_ProfileFrame", SM_RootFrame, "BackdropTemplate")
SM_ProfileFrame:SetPoint("TOPRIGHT", 175, 0)
SM_ProfileFrame:SetSize(175, 125)
SM_ProfileFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"})
SM_ProfileFrame:SetBackdropColor(0, 0, 0, 1)
SM_ProfileFrame.texture = SM_ProfileFrame:CreateTexture()
SM_ProfileFrame.texture:SetAllPoints(SM_ProfileFrame)
SM_ProfileFrame.texture:SetSize(150, 150)
SM_ProfileFrame.texture:SetColorTexture(0.05, 0.05, 0.05, 0.6)
SM_ProfileFrame:EnableMouse(true)
SM_ProfileFrame:RegisterForDrag("LeftButton", "RightButton")

function SM_ProfileFrame:ClearIcons()
  local icons = {SM_ProfileFrame:GetChildren()}
  for k, v in ipairs(icons) do
    if v.icon then
      v.icon:SetTexture(v.defaultIcon)
    end
  end
end

SM_ProfileFrame:SetScript("OnDragStart", function(self)
  SM_RootFrame:StartMoving()
end)

SM_ProfileFrame:SetScript("OnDragStop", function(self)
  SM_RootFrame:StopMovingOrSizing()
end)

local SM_DeleteButton = CreateFrame("Button", "SM_DeleteButton", SM_ProfileFrame, "UIPanelButtonTemplate");
SM_DeleteButton:SetPoint("BOTTOMRIGHT", -70, 8)
SM_DeleteButton:SetSize(60, 20)
SM_DeleteButton:SetText("Delete")
SM_DeleteButton:SetFrameLevel(20)
SM_DeleteButton:EnableMouse(true)
SM_DeleteButton:SetScript("OnClick", function()
  if Util.state.selected_profile then
    SavedMorphs[Util.state.selected_profile] = nil
    SavedMorphs = reIndex(SavedMorphs)
    _G["SM_ProfileFrame"]:ClearIcons()
  end
  for idx, morph in pairs(SavedMorphs) do
    _G["SM_ProfileSlotFrame" .. idx]:SetIcon(morph.icon)
  end
end)

local SM_SaveButton = CreateFrame("Button", "SM_SaveButton", SM_ProfileFrame, "UIPanelButtonTemplate");
SM_SaveButton:SetPoint("BOTTOMRIGHT", -10, 8)
SM_SaveButton:SetSize(60, 20)
SM_SaveButton:SetText("Save")
SM_SaveButton:SetFrameLevel(20)
SM_SaveButton:EnableMouse(true)
SM_SaveButton:SetScript("OnClick", function()
  SM_Dialog_ProfileConfigFrame:Show()
end)

local SM_Dialog_ProfileConfigFrame = CreateFrame("Frame", "SM_Dialog_ProfileConfigFrame", SM_RootFrame, "BackdropTemplate")
SM_Dialog_ProfileConfigFrame:SetPoint("TOPRIGHT", 277, -127)
SM_Dialog_ProfileConfigFrame:SetSize(275, 240)
SM_Dialog_ProfileConfigFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"})
SM_Dialog_ProfileConfigFrame:SetBackdropColor(0, 0, 0, 1)
SM_Dialog_ProfileConfigFrame.texture = SM_Dialog_ProfileConfigFrame:CreateTexture()
SM_Dialog_ProfileConfigFrame.texture:SetAllPoints(SM_Dialog_ProfileConfigFrame)
SM_Dialog_ProfileConfigFrame.texture:SetSize(150, 150)
SM_Dialog_ProfileConfigFrame.texture:SetColorTexture(0.05, 0.05, 0.05, 0.6)
SM_Dialog_ProfileConfigFrame:Hide()

local SM_Dialog_IconsFrame = CreateFrame("Frame", "SM_Dialog_IconsFrame", SM_Dialog_ProfileConfigFrame, "BackdropTemplate")
SM_Dialog_IconsFrame:SetPoint("BOTTOM", 0, 0)
SM_Dialog_IconsFrame:SetSize(265, 175)

local SM_Dialog_ScrollFrame = CreateFrame("ScrollFrame", "SM_Dialog_ScrollFrame", SM_Dialog_IconsFrame, "UIPanelScrollFrameTemplate")
SM_Dialog_ScrollFrame:SetPoint("TOPLEFT", 3, -4)
SM_Dialog_ScrollFrame:SetPoint("BOTTOMRIGHT", -22, 35)

local SM_Dialog_ScrollChildFrame = CreateFrame("Frame")
SM_Dialog_ScrollFrame:SetScrollChild(SM_Dialog_ScrollChildFrame)
SM_Dialog_ScrollChildFrame:SetWidth(SM_Dialog_ProfileConfigFrame:GetWidth())
SM_Dialog_ScrollChildFrame:SetHeight(500)

local CreateIcon = function(icon, x, y)
  local iconframe = CreateFrame("Button", "Icon" .. icon, SM_Dialog_ScrollChildFrame, "BackdropTemplate")
  iconframe:SetPoint("TOPLEFT", 5 + x, y)
  iconframe:SetSize(40, 40)
  iconframe:EnableMouse(true)
  iconframe:SetAlpha(0.4)
  iconframe:SetBackdrop({
    bgFile = "",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 6,
    insets = {left = 6, right = 6, top = 6, bottom = 6}
  })
  iconframe.texture = iconframe:CreateTexture(nil, "BACKGROUND", nil)
  iconframe.texture:SetAllPoints(iconframe)
  iconframe.texture:SetSize(40, 40)
  iconframe.texture:SetTexture(icon)
  iconframe:SetScript("OnClick", function(self)
    Util.state["profile_config"]["icon"] = icon
    SM_ConfirmButton:Enable()
    iconframe:SetAlpha(1)
    local icons = {SM_Dialog_ScrollChildFrame:GetChildren()}
    for _, v in pairs(icons) do
      if v:GetName() ~= self:GetName() then
        v:SetAlpha(0.4)
      end
    end
  end)
end

local mapIconsToScrollFrame = function(icons)
  local index = 0
  local row = 0
  local column = 0
  for _, icon in pairs(icons) do
    if index >= 5 then
      column = column - 50
      row = 0
      index = 0
    end
    CreateIcon(icon, row, column)
    index = index + 1
    row = row + 45
  end
end

mapIconsToScrollFrame(Util.IconList)

local SM_ConfirmButton = CreateFrame("Button", "SM_ConfirmButton", SM_Dialog_ProfileConfigFrame, "UIPanelButtonTemplate");
SM_ConfirmButton:SetPoint("BOTTOMRIGHT", -70, 10)
SM_ConfirmButton:SetSize(60, 20)
SM_ConfirmButton:SetText("Okay")
SM_ConfirmButton:SetFrameLevel(20)
SM_ConfirmButton:EnableMouse(true)
SM_ConfirmButton:Disable()

SM_ConfirmButton:SetScript("OnClick", function()
  SM_Dialog_ProfileConfigFrame:Hide()
  if SavedMorphs == nil then
    SavedMorphs = {}
  end

  function cloneObj(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[cloneObj(k)] = cloneObj(v) end
    return res
  end

  if tableLength(SavedMorphs) <= 8 then
    SavedMorphs[tostring(tableLength(SavedMorphs) + 1)] = {
      ["name"] = cloneObj(Util.state.profile_config.name),
      ["icon"] = cloneObj(Util.state.profile_config.icon),
      ["gear_set"] = cloneObj(Util.state.slots)
    }
    _G["SM_ProfileSlotFrame" .. tableLength(SavedMorphs)]:SetIcon(Util.state.profile_config.icon)
  end
  --[[
  for k, v in pairs(Util.state.slots) do
    print(k, v)
    Util.state.slots[k] = false
    util.state.profile_config = {}
  end
    --]]
end)


local SM_CancelButton = CreateFrame("Button", "SM_CancelButton", SM_Dialog_ProfileConfigFrame, "UIPanelButtonTemplate");
SM_CancelButton:SetPoint("BOTTOMRIGHT", -10, 10)
SM_CancelButton:SetSize(60, 20)
SM_CancelButton:SetText("Cancel")
SM_CancelButton:SetFrameLevel(20)
SM_CancelButton:EnableMouse(true)
SM_CancelButton:SetScript("OnClick", function()
  SM_Dialog_ProfileConfigFrame:Hide()
end)

local SM_TextInput_ProfileName = CreateFrame("EditBox", "SM_TextInput_ProfileName", SM_Dialog_ProfileConfigFrame, "BackdropTemplate")
SM_TextInput_ProfileName:SetAutoFocus(false)
SM_TextInput_ProfileName:SetSize(200, 23)
SM_TextInput_ProfileName:SetPoint("TOPLEFT", 10, -25)
SM_TextInput_ProfileName:SetFontObject("GameFontNormal")
SM_TextInput_ProfileName:SetTextColor(1, 1, 1, 1)
SM_TextInput_ProfileName:SetFrameLevel(50)
SM_TextInput_ProfileName:SetBackdrop({
  bgFile = "",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = "true",
  tileSize = 10,
  edgeSize = 10,
  insets = {left = 8, right = 8, top = 8, bottom = 8}
})
SM_TextInput_ProfileName.texture = SM_TextInput_ProfileName:CreateTexture()
SM_TextInput_ProfileName.texture:SetAllPoints(SM_TextInput_ProfileName)
SM_TextInput_ProfileName.texture:SetColorTexture(0, 0, 0, 1)
SM_TextInput_ProfileName.title = SM_TextInput_ProfileName:CreateFontString(nil, "OVERLAY", "GameFontNormal")
SM_TextInput_ProfileName.title:SetPoint("LEFT", 0, 20)
SM_TextInput_ProfileName.title:SetFont("Fonts\\FRIZQT__.TTF", 10)
SM_TextInput_ProfileName.title:SetTextColor(1, 1, 1, 1)
SM_TextInput_ProfileName.title:SetText("Enter Set Name:")
SM_TextInput_ProfileName:SetPropagateKeyboardInput(false)
SM_TextInput_ProfileName:SetScript("OnEnterPressed", function(self, event)
  local textInputValue = SM_TextInput_ProfileName:GetText()
  if string.len(textInputValue) ~= 0 then
    Util.state["profile_config"]["name"] = textInputValue
  end
  SM_TextInput_ProfileName:ClearFocus()
  SM_TextInput_ProfileName:SetText("")
end)

local CreateSlot = function(idx, x, y)
  local frame = CreateFrame("Button", "SM_ProfileSlotFrame" .. idx, SM_ProfileFrame, "BackdropTemplate")
  frame:SetPoint("TOPLEFT", x, y)
  frame:SetSize(36, 36)
  frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"})
  frame:SetBackdropColor(0, 0, 0, 1)
  frame.defaultIcon = "Interface/PaperDoll/UI-Backpack-EmptySlot"
  frame.idx = idx
  frame.icon = frame:CreateTexture()
  frame.icon:SetAllPoints(frame)
  frame.icon:SetSize(36, 36)
  frame.icon:SetTexture(frame.defaultIcon)

  function frame:SetIcon(iconID)
    frame.icon:SetTexture(iconID)
    frame:SetAlpha(1)
  end

  function frame:SelectMorph(morph)
    for itemKey, itemValue in pairs(morph.gear_set) do
      if itemValue ~= false then
        local _, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemValue)
        SM_ModelFrame:TryOn("item:" .. itemValue, itemKey)
        Util.state.slots[itemKey] = itemValue
        _G["INVENTORY_" .. itemKey]:SetIcon(texture)
      end
    end
  end

  frame:SetScript("OnClick", function()
    frame:SelectMorph(SavedMorphs[frame.idx])
    Util.state.selected_profile = frame.idx
    print(Util.state.selected_profile)
  end)

  frame:SetScript("OnEnter", function()
    frame:SetAlpha(0.5)
  end)

  frame:SetScript("OnLeave", function()
    frame:SetAlpha(1)
  end)
end

local CreateSlots = function(slots)
  for idx, slot in pairs(slots) do
    CreateSlot(idx, slot.x, slot.y)
  end
end

CreateSlots(profileSlots)