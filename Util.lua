local _, Util = ...

local INV_SLOTS = {
  ["head"] = {
    ["name"] = "Head",
    ["id"] = "HEADSLOT",
    ["invType"] = "INVTYPE_HEAD",
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-Head", 
    ["position"] = {"TOPLEFT", 10, -10, 40}
  },  
  ["shoulder"] = {
    ["name"] = "Shoulders",
    ["id"] = "SHOULDERSLOT",
    ["invType"] = "INVTYPE_SHOULDER",
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-Shoulder",
    ["position"] = {"TOPLEFT", 10, -55, 40}
  },
  ["back"] = { 
    ["name"] = "Back",
    ["id"] = "BACKSLOT",
    ["invType"] = "INVTYPE_CLOAK",
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-Shirt",
    ["position"] = {"TOPLEFT", 10, -100, 40}
  },
  ["chest"] = {
    ["name"] = "Chest",
    ["id"] = "CHESTSLOT",
    ["invType"] = "INVTYPE_CHEST",
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-Chest",
    ["position"] = {"TOPLEFT", 10, -145, 40}
  },
  ["tabard"] = {
    ["name"] = "Tabard",
    ["id"] = "TABARDSLOT",
    ["invType"] = "INVTYPE_TABARD",
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-Tabard",
    ["position"] = {"TOPLEFT", 10, -190, 40}
  },
  ["wrist"] = {
    ["name"] = "Wrist",
    ["id"] = "WRISTSLOT",
    ["invType"] = "INVTYPE_WRIST",
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-Wrists",
    ["position"] = {"TOPLEFT", 10, -235, 40}
  },
  ["mainhand"] = {
    ["name"] = "Main Hand",
    ["id"] = "MAINHANDSLOT",
    ["invType"] = {"INVTYPE_WEAPON", "INVTYPE_2HWEAPON"},
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-MainHand",
    ["position"] = {"TOPLEFT", 10, -280, 40}
  },
  ["hands"] = {
    ["name"] = "Hands",
    ["id"] = "HANDSSLOT",
    ["invType"] = "INVTYPE_HAND",
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-Hands",
    ["position"] = {"TOPRIGHT", -10, -10, -40}
  },
  ["waist"] = {
    ["name"] = "Waist",
    ["id"] = "WAISTSLOT",
    ["invType"] = "INVTYPE_WAIST",
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-Waist",
    ["position"] = {"TOPRIGHT", -10, -55, -40}
  },
  ["legs"] = {
    ["name"] = "Legs",
    ["id"] = "LEGSSLOT",
    ["invType"] = "INVTYPE_LEGS",
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-Legs",
    ["position"] = {"TOPRIGHT", -10, -100, -40}
  },
  ["feet"] = {
    ["name"] = "Feet",
    ["id"] = "FEETSLOT",
    ["invType"] = "INVTYPE_FEET",
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-Feet",
    ["position"] = {"TOPRIGHT", -10, -145, -40}
  },
  ["ranged"] = {
    ["name"] = "Ranged",
    ["id"] = "RANGEDSLOT",
    ["invType"] = "INVTYPE_RANGED",
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-Ranged",
    ["position"] = {"TOPRIGHT", -10, -190, -40}
  },
  ["offhand"] = {
    ["name"] = "Off Hand",
    ["id"] = "SECONDARYHANDSLOT",
    ["invType"] = {"INVTYPE_SHIELD", "INVTYPE_WEAPONOFFHAND"},
    ["texture"] = "Interface/PaperDoll/UI-PaperDoll-Slot-SecondaryHand",
    ["position"] = {"TOPRIGHT", -10, -235, -40}
  },
}

local INV_TYPES = {
  ["INVTYPE_HEAD"] = "HEADSLOT",
  ["INVTYPE_SHOULDER"] = "SHOULDERSLOT",
  ["INVTYPE_CHEST"] = "CHESTSLOT",
  ["INVTYPE_ROBE"] = "CHESTSLOT",
  ["INVTYPE_WAIST"] = "WAISTSLOT",
  ["INVTYPE_LEGS"] = "LEGSSLOT",
  ["INVTYPE_FEET"] = "FEETSLOT",
  ["INVTYPE_WRIST"] = "WRISTSLOT",
  ["INVTYPE_HAND"] = "HANDSSLOT",
  ["INVTYPE_WEAPON"] = "MAINHANDSLOT",
  ["INVTYPE_SHIELD"] = "SECONDARYHANDSLOT",
  ["INVTYPE_RANGED"] = "RANGEDSLOT",
  ["INVTYPE_CLOAK"] = "BACKSLOT",
  ["INVTYPE_2HWEAPON"] = "MAINHANDSLOT",
  ["INVTYPE_TABARD"] = "TABARDSLOT",
  ["INVTYPE_WEAPONMAINHAND"] = "MAINHANDSLOT",
  ["INVTYPE_WEAPONOFFHAND"] = "SECONDARYHANDSLOT",
  ["INVTYPE_THROWN"] = "RANGEDSLOT"
}

local IMORPH_SLOT_IDS = {
  ["HEADSLOT"] = 1,
  ["SHOULDERSLOT"] = 3,
  ["BACKSLOT"] = 15,
  ["CHESTSLOT"] = 5,
  ["TABARDSLOT"] = 19,
  ["WRISTSLOT"] = 9,
  ["MAINHANDSLOT"] = 16,
  ["HANDSSLOT"] = 10,
  ["WAISTSLOT"] = 6,
  ["LEGSSLOT"] = 7,
  ["FEETSLOT"] = 8,
  ["SECONDARYHANDSLOT"] = 17,
  ["RANGEDSLOT"] = 18
}

local IconList = {
  [135731] = 135731,
  [236293] = 236293,
  [135900] = 135900,
  [135990] = 135990,
  [136083] = 136083,
  [135732] = 135732,
  [135899] = 135899,
  [132331] = 132331,
  [236208] = 236208,
  [135738] = 135738,
  [136211] = 136211,
  [135819] = 135819
}

local state = {
  ["selected_slot"] = false,
  ["slots"] = {
    ["HEADSLOT"] = false,
    ["SHOULDERSLOT"] = false,
    ["BACKSLOT"] = false,
    ["CHESTSLOT"] = false,
    ["TABARDSLOT"] = false,
    ["WRISTSLOT"] = false,
    ["MAINHANDSLOT"] = false,
    ["HANDSSLOT"] = false,
    ["WAISTSLOT"] = false,
    ["LEGSSLOT"] = false,
    ["FEETSLOT"] = false,
    ["SECONDARYHANDSLOT"] = false,
    ["RANGEDSLOT"] = false
  },
  ["profiles_list"] = {},
  ["selected_profile"] = false,
  ["profile_config"] = {}
}

SlashCmdList["ADDONTOGGLE"] = function(msg)
	if SM_RootFrame:IsVisible() == false then
		SM_RootFrame:Show()
	else 
		SM_RootFrame:Hide()
	end
end

SLASH_ADDONTOGGLE1 = "/sm"
SLASH_ADDONTOGGLE2 = "/savemorph"

Util.INV_SLOTS = INV_SLOTS
Util.INV_TYPES = INV_TYPES
Util.IMORPH_SLOT_IDS = IMORPH_SLOT_IDS
Util.ProfileSlots = ProfileSlots
Util.IconList = IconList
Util.state = state