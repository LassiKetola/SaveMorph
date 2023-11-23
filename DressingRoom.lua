local _, Util = ...

local PLAYER_UNIT_LOADED = false

local SM_ModelFrame = CreateFrame("DressUpModel", "SM_ModelFrame", SM_MainFrame, "ModelWithControlsTemplate")
SM_ModelFrame:SetPoint("CENTER")
SM_ModelFrame:SetSize(320, 305)
SM_ModelFrame:EnableMouse(true)
SM_ModelFrame:SetCamDistanceScale(1.1)
SM_ModelFrame:SetCamera(0)
SM_ModelFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE")

SM_ModelFrame:SetScript("OnEvent", function(self, eventType, unitType)
  if eventType == "UNIT_PORTRAIT_UPDATE" and unitType == "player" then
    SM_ModelFrame:SetUnit("player")
    PLAYER_UNIT_LOADED = true
  end
end)

local SM_ResetButton = CreateFrame("Button", "SM_ResetButton", SM_MainFrame, "UIPanelButtonTemplate");
SM_ResetButton:SetPoint("BOTTOMRIGHT", -70, 10)
SM_ResetButton:SetSize(60, 20)
SM_ResetButton:EnableMouse(true)
SM_ResetButton:SetText("Reset")
SM_ResetButton:SetFrameLevel(20)
SM_ResetButton:SetScript("OnClick", function()
  SM_ModelFrame:Undress()
  _G["SM_MainFrame"]:ClearIcons()
  for k, v in pairs(Util.state.slots) do
    Util.state.slots[k] = false
  end

end)

local SM_MorphButton = CreateFrame("Button", "SM_MorphButton", SM_MainFrame, "UIPanelButtonTemplate");
SM_MorphButton:SetPoint("BOTTOMRIGHT", -10, 10)
SM_MorphButton:SetSize(60, 20)
SM_MorphButton:SetText("Morph")
SM_MorphButton:SetFrameLevel(20)
SM_MorphButton:EnableMouse(true)
SM_MorphButton:SetScript("OnClick", function()
  for key, value in pairs(Util.state.slots) do
    print(key, value)
    if value ~= 0 and type(tonumber(value)) == "number" then
      SetItem(Util.IMORPH_SLOT_IDS[key], value)
    end
  end
end)

local SM_DialogFrame_ItemID = CreateFrame("Frame", "SM_DialogFrame_ItemID", SM_MainFrame, "BackdropTemplate")
SM_DialogFrame_ItemID:SetPoint("CENTER")
SM_DialogFrame_ItemID:SetSize(440, 325)
SM_DialogFrame_ItemID:SetBackdrop({
  bgFile = "Interface/Tooltips/UI-Tooltip-Background",
  edgeSize = 32,
})
SM_DialogFrame_ItemID:SetBackdropColor(0, 0, 0, 1)
SM_DialogFrame_ItemID:SetFrameLevel(50)
SM_DialogFrame_ItemID:Hide()

local SM_ItemID_TextInput = CreateFrame("EditBox", "SM_TextInput_ItemID", SM_DialogFrame_ItemID, "BackdropTemplate")
SM_TextInput_ItemID:SetAutoFocus(false)
SM_TextInput_ItemID:SetSize(175, 25)
SM_TextInput_ItemID:SetPoint("CENTER", 0, 0)
SM_TextInput_ItemID:SetFontObject("GameFontNormal")
SM_TextInput_ItemID:SetTextColor(0.1, 0.1, 0.1, 1)
SM_TextInput_ItemID:SetFrameLevel(50)
SM_TextInput_ItemID:SetPropagateKeyboardInput(false)
SM_TextInput_ItemID.texture = SM_TextInput_ItemID:CreateTexture()
SM_TextInput_ItemID.texture:SetAllPoints(SM_TextInput_ItemID)
SM_TextInput_ItemID.texture:SetSize(125, 15)
SM_TextInput_ItemID.texture:SetColorTexture(0.9, 0.9, 0.9, 1)
SM_TextInput_ItemID.title = SM_TextInput_ItemID:CreateFontString(nil, "OVERLAY", "GameFontNormal")
SM_TextInput_ItemID.title:SetPoint("CENTER", 0, -10)
SM_TextInput_ItemID.title:SetFont("Fonts\\FRIZQT__.TTF", 11)
SM_TextInput_ItemID.title:SetTextColor(1, 1, 1, 1)

SM_TextInput_ItemID:SetScript("OnEscapePressed", function(self, a, b, c)
end)

SM_TextInput_ItemID:SetScript("OnEnterPressed", function(self, event)
  local function parseInput(value)
    if type(tonumber(value)) == "number" then
      return value
    else
      local result = select(3, strfind(value, "item=(%d+)"))
      return result
    end
  end
  local input_value = parseInput(SM_TextInput_ItemID:GetText())
  local _, link, _, _, _, _, _, _, item_inv_type, item_texture = GetItemInfo(input_value)
  if link then
    -- if the given item .e.g "thunderfury" inv_type is "MAINHANDSLOT"
    -- but the current selected slot is "SECONDARYHANDSLOT" then make an exception
    -- and add the item to the "SECONDARYHANDSLOT"
    if Util.INV_TYPES[item_inv_type] == "MAINHANDSLOT" and Util.state.selected_slot == "SECONDARYHANDSLOT" then
      Util.state.slots["SECONDARYHANDSLOT"] = input_value
      _G["INVENTORY_" .. "SECONDARYHANDSLOT"]:SetIcon(item_texture)
      SM_ModelFrame:TryOn("item:" .. input_value, "SECONDARYHANDSLOT")
    end
    if Util.INV_TYPES[item_inv_type] == Util.state.selected_slot then
      Util.state.slots[Util.INV_TYPES[item_inv_type]] = input_value
      print(Util.state.slots[Util.INV_TYPES[item_inv_type]])
      _G["INVENTORY_" .. Util.state.selected_slot]:SetIcon(item_texture)
      SM_ModelFrame:TryOn("item:" .. input_value, Util.state.selected_slot)
    end
  end
  SM_DialogFrame_ItemID:Hide()
  SM_TextInput_ItemID:ClearFocus()
  SM_TextInput_ItemID:SetText("")
  Util.state.selected_slot = false
end)