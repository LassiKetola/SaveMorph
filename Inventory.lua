local _, Util = ...

local SM_RootFrame = CreateFrame("Frame", "SM_RootFrame", UIParent, "BackdropTemplate")
SM_RootFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
SM_RootFrame:SetPoint("CENTER")
SM_RootFrame:SetSize(440, 325)
SM_RootFrame:SetFrameLevel(12)
SM_RootFrame:SetMovable(true)
SM_RootFrame:RegisterEvent("ADDON_LOADED")

SM_RootFrame:SetScript("OnEvent", function(self, event, addon)
  if addon == "SaveMorph" then
    print ("SaveMorph v1.0 loaded type /sm or /savemorph to start")
    for idx, morph in pairs(SavedMorphs) do
      _G["SM_ProfileSlotFrame" .. idx]:SetIcon(morph.icon)
    end
  end
end)

SM_RootFrame:Hide()

local SM_AppTitle = CreateFrame("Frame", "SM_AppTitle", SM_RootFrame, "BackdropTemplate")
SM_AppTitle:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
SM_AppTitle:SetPoint("TOP", 0, 10)
SM_AppTitle:SetSize(440, 10)
SM_AppTitle:SetFrameLevel(12)
SM_AppTitle:EnableMouse(true)
SM_AppTitle:RegisterForDrag("LeftButton", "RightButton")
SM_AppTitle.texture = SM_AppTitle:CreateTexture()
SM_AppTitle.texture:SetAllPoints(SM_AppTitle)
SM_AppTitle.texture:SetSize(440, 10)
SM_AppTitle.texture:SetColorTexture(0, 0, 0, 1)
SM_AppTitle.title = SM_AppTitle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
SM_AppTitle.title:SetPoint("LEFT", 10, 0)
SM_AppTitle.title:SetFont("Fonts\\FRIZQT__.TTF", 11)
SM_AppTitle.title:SetTextColor(1, 1, 1, 1)
SM_AppTitle.title:SetText("SaveMorph v 1.0")
SM_AppTitle:SetScript("OnDragStart", function(self)
  SM_RootFrame:StartMoving()
end)
SM_AppTitle:SetScript("OnDragStop", function(self)
  SM_RootFrame:StopMovingOrSizing()
end)


local SM_MainFrame = CreateFrame("Frame", "SM_MainFrame", SM_RootFrame, "BackdropTemplate")
SM_MainFrame:SetPoint("LEFT")
SM_MainFrame:SetSize(440, 325)
SM_MainFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
SM_MainFrame:EnableMouse(true)
SM_MainFrame:RegisterForDrag("LeftButton", "RightButton")
SM_MainFrame.texture = SM_MainFrame:CreateTexture()
SM_MainFrame.texture:SetAllPoints(SM_MainFrame)
SM_MainFrame.texture:SetSize(440, 325)
SM_MainFrame.texture:SetColorTexture(0.02, 0.02, 0.02, 0.9)

function SM_MainFrame:ClearIcons()
  local icons = {SM_MainFrame:GetChildren()}
  for k, v in ipairs(icons) do
    if v.icon then
      v.icon:SetTexture(v.defaultIcon)
    end
  end
end

SM_MainFrame:SetScript("OnDragStart", function(self)
  SM_RootFrame:StartMoving()
end)
SM_MainFrame:SetScript("OnDragStop", function(self)
  SM_RootFrame:StopMovingOrSizing()
end)

local CreateSlot = function(slot)
  local Slot = CreateFrame("Button", "INVENTORY_" .. slot.id, SM_MainFrame, "BackdropTemplate");
  Slot:SetPoint(slot.position[1], slot.position[2], slot.position[3])
  Slot:SetSize(35, 35)
  Slot:EnableMouse(true)
  Slot:SetBackdropColor(0.3, 0.3, 0.3, 1)
  Slot:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeSize = 32,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
  })
  Slot.defaultIcon = slot.texture
  Slot.icon = Slot:CreateTexture()
  Slot.icon:SetAllPoints(Slot)
  Slot.icon:SetSize(64, 64)
  Slot.icon:SetTexture(slot.texture)
  Slot.title = Slot:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  Slot.title:SetPoint(slot.position[1], slot.position[4], 0)
  Slot.title:SetFont("Fonts\\FRIZQT__.TTF", 9)
  Slot.title:SetText(slot.name)
  Slot.title:SetTextColor(0.7, 0.7, 0.7, 1)
  Slot:SetScript("OnClick", function (self)
    SM_TextInput_ItemID:SetText("")
    SM_DialogFrame_ItemID:Show()
    Util.state.selected_slot = slot.id
  end)
  function Slot:SetIcon(icon)
    Slot.icon:SetTexture(icon)
  end
  Slot:SetScript("OnEnter", function(self)
    self:SetAlpha(0.75)
  end)
  Slot:SetScript("OnLeave", function(self)
    self:SetAlpha(1)
  end)
end

for _, slot in pairs(Util.INV_SLOTS) do
  CreateSlot(slot)
end