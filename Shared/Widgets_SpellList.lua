--[[

 NOTE : TO BE LOADED AFTER WidgetsXXX.xml

--]]
-- #region Spell List Widget
--[[
! Spell List Widget
Attributes: text, title, placeholder
]]
local _, ns = ...

K_SHARED_UI = K_SHARED_UI or {};

-- ! avoid conflict override
if ns.CONFLICT then return; end

-- * Share locales between shared ui files
K_SHARED_UI.I18N = K_SHARED_UI.I18N or {}
K_SHARED_UI.I18N[ns.ADDON_NAME] = K_SHARED_UI.I18N[ns.ADDON_NAME] or ns.I18N
--- Shared ui locales access
local function l(localeName)
    for _, locales in pairs(K_SHARED_UI.I18N) do
        if locales[localeName] then
            return locales[localeName]
        end
    end
    return nil
end

local function AssignNameSpace_OnLoad(self)
	self._OPTIONS_NAME = ns.OPTIONS_NAME
	self._ns = ns
end

-- #region Spell List Widget
--[[
! Spell List Widget
Main attributes: text, tooltip, width, justify
Items attributes: text1, value1, color1, ...
* Warning: name has to be set if you want to enable/disable widget
]]
local SPELL_LIST_VISIBLE_ROWS = 12
local SPELL_LIST_ROW_HEIGHT = 22

local function SpellList_GetSpellInfo(identifier)
    if not identifier or identifier == "" or not C_Spell or not C_Spell.GetSpellInfo then
        return nil
    end

	local info = C_Spell.GetSpellInfo(identifier)

	if info then
		return {
			id = info.spellID or tonumber(identifier),
			name = info.name,
		}
	end
	ns.AddMsgWarn(UNKNOWN..": " .. tostring(identifier), true)
	return nil
end


local function SpellList_GetInfos(self)
    local infos = {}
    for id, _ in pairs(self._spells) do
        local info = SpellList_GetSpellInfo(id)
        if info then
            infos[#infos + 1] = info
        end
    end
    return infos
end

local function SpellList_RefreshTooltip(self)
    if not GameTooltip:IsOwned(self) then
        return
    end

    GameTooltip:ClearLines()
    GameTooltip:SetText(self:GetText() or "")

    local infos = SpellList_GetInfos(self)
    if #infos == 0 then
        GameTooltip:AddLine(NONE, 0.7, 0.7, 0.7)
    else
        for _, spell in ipairs(infos) do
            GameTooltip:AddLine(
                l("WH") .. spell.name,
                1, 0.82, 0, true
            )
        end
    end

    GameTooltip:Show()
end

local function SpellList_NotifyChanged(self)
    K_SHARED_UI.NotifyControlChanged(self._ns, self)

    local onEventScript = self:GetScript("OnEvent")
    if onEventScript then
        onEventScript(self, "change")
    end
end

local function SpellList_Refresh(self)
    local popup = self._popup
    if not popup then
        return
    end

    local spells = SpellList_GetInfos(self)
    local offset = FauxScrollFrame_GetOffset(popup.scrollFrame) or 0

    FauxScrollFrame_Update(
        popup.scrollFrame,
        #spells,
        SPELL_LIST_VISIBLE_ROWS,
        SPELL_LIST_ROW_HEIGHT
    )

    for i = 1, SPELL_LIST_VISIBLE_ROWS do
		local row = popup.rows[i]
		local index = i + offset
		local spell = spells[index]

		row.spellID = spell and spell.id or nil

		if spell then
			local cross = l("RT7") or ""
			row:SetText(string.format("%s %s %s(%d)|r", cross, spell.name, l("GY"), spell.id))
			row:Show()
		else
			row:Hide()
		end
	end

    SpellList_RefreshTooltip(self)
end

local function SpellList_AddSpell(self, identifier)
    if type(identifier) ~= "string" and type(identifier) ~= "number" then
        return false
    end

    identifier = tostring(identifier):match("^%s*(.-)%s*$")

    -- Allow pasting "12345: Spell name".
    local idText = identifier:match("^(%d+)%s*:")
    if idText then
        identifier = idText
    end

    local spell = SpellList_GetSpellInfo(tonumber(identifier) or identifier)

    if not spell or not spell.name or not spell.id then
        return false
    end

    if self._spells[spell.id] then
        return false
    end

    self._spells[spell.id] = true

    SpellList_Refresh(self)
    SpellList_NotifyChanged(self)

    return true
end

local function SpellList_RemoveSpell(self, spellID)
    spellID = tonumber(spellID)

    if not spellID or not self._spells[spellID] then
        return false
    end

    self._spells[spellID] = nil
    SpellList_Refresh(self)
    SpellList_NotifyChanged(self)
    return true
end

local function SpellList_GetSpells(self)
    return CopyTable(self._spells)
end

local function SpellList_SetSpells(self, spells)
    self._spells = {}

    for id, _ in pairs(spells or {}) do
        local spellID = tonumber(id)

        if spellID then
            self._spells[spellID] = true
        end
    end
    SpellList_Refresh(self)
end

StaticPopupDialogs[ns.ADDON_NAME .. "_CLEAR_SPELL_LIST"] = {
    text = string.format("%s%s|r: %s%s|r\n\n%s?", l("YL"), ns.TITLE, l("WH"), "%s", CLEAR_ALL),
    button1 = CLEAR_ALL,
    button2 = CANCEL,
    OnAccept = function(self)
        local widget = self.data

        SpellList_SetSpells(widget, {})
        SpellList_NotifyChanged(widget)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION, "master")
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

local function SpellList_CreatePopup(self, show)
    if self._popup then
        return self._popup
    end

    local popup = CreateFrame(
        "Frame",
        nil,
        UIParent,
        BackdropTemplateMixin and "BackdropTemplate" or nil
    )

    popup:SetSize(300, 340)
    popup:SetFrameStrata("DIALOG")
    popup:SetClampedToScreen(true)
    popup:EnableMouse(true)
    popup:SetMovable(true)
    popup:RegisterForDrag("LeftButton")
    popup:SetScript("OnDragStart", popup.StartMoving)
    popup:SetScript("OnDragStop", popup.StopMovingOrSizing)

    if popup.SetBackdrop then
        popup:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })
        popup:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
    end

    local title = popup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", 12, -12)
    title:SetPoint("TOPRIGHT", -30, -12)
    title:SetJustifyH("CENTER")
    title:SetText(l(self:GetAttribute("title")) or SPELLS)
    popup.title = title

    local close = CreateFrame("Button", nil, popup, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -2, -2)
    close:SetScript("OnClick", function()
        popup:Hide()
    end)

    local input = CreateFrame("EditBox", nil, popup, "InputBoxTemplate")
    input:SetSize(200, 24)
    input:SetPoint("TOPLEFT", 12, -42)
    input:SetAutoFocus(false)
    input:SetText("")
	
	-- Placeholder
	input.placeholder = input:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	input.placeholder:SetPoint("LEFT", input, "LEFT", 6, 0)
	input.placeholder:SetText(l(self:GetAttribute("placeholder")) or "Spell Name or Spell ID")
	input.placeholder:SetJustifyH("LEFT")
	input.placeholder:SetWordWrap(false)

	input:SetScript("OnTextChanged", function(self)
		if self:GetText() == "" then
			self.placeholder:Show()
		else
			self.placeholder:Hide()
		end
	end)

	input:SetScript("OnEditFocusGained", function(self)
		self.placeholder:Hide()
	end)

    popup.input = input

    local clear = CreateFrame("Button", nil, popup)
    clear:SetSize(20, 20)
    clear:SetPoint("TOPLEFT", popup, "TOPLEFT", 8, -8)

    clear:SetNormalTexture("Interface/Buttons/UI-GroupLoot-Pass-Up")
    clear:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square", "ADD")

    clear:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    clear:SetScript("OnClick", function()
        StaticPopup_Show(ns.ADDON_NAME .. "_CLEAR_SPELL_LIST", l(self:GetAttribute("text")) or SPELLS, nil, self)
    end)

    clear:SetScript("OnEnter", function(button)
        GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
        GameTooltip:SetText(CLEAR_ALL)
        GameTooltip:Show()
    end)

    clear:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    popup.clear = clear

    local add = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
    add:SetSize(64, 24)
    add:SetPoint("LEFT", input, "RIGHT", 8, 0)
    add:SetText(ADD)

    local scrollFrame = CreateFrame(
        "ScrollFrame",
        nil,
        popup,
        "FauxScrollFrameTemplate"
    )
    scrollFrame:SetPoint("TOPLEFT", 12, -78)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 12)
    popup.scrollFrame = scrollFrame
    popup.rows = {}

    for i = 1, SPELL_LIST_VISIBLE_ROWS do
        local row = CreateFrame(
            "Button",
            nil,
            popup,
            "UIMenuButtonStretchTemplate" -- UIPanelButtonTemplate
        )

        row:SetSize(250, SPELL_LIST_ROW_HEIGHT)
        row:SetPoint(
            "TOPLEFT",
            scrollFrame,
            "TOPLEFT",
            0,
            -((i - 1) * SPELL_LIST_ROW_HEIGHT)
        )
        row:RegisterForClicks("LeftButtonUp", "RightButtonUp")

        row:SetScript("OnClick", function(button, mouseButton)
            if mouseButton == "RightButton" and button.spellID then
                SpellList_RemoveSpell(self, button.spellID)
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION, "master")
            end
        end)

		row:SetScript("OnEnter", function(button)
            local spellID = button.spellID

            if not spellID then
                return
            end

            GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(spellID)
            GameTooltip:AddLine(
                (l("GR") or "") .. (GLYPH_SLOT_REMOVE_TOOLTIP or "Right click to remove"),
                1, 1, 1, true
            )
            GameTooltip:Show()
        end)

        popup.rows[i] = row
    end

    scrollFrame:SetScript("OnVerticalScroll", function(frame, offset)
        FauxScrollFrame_OnVerticalScroll(
            frame,
            offset,
            SPELL_LIST_ROW_HEIGHT,
            function()
				SpellList_Refresh(self)
			end
        )
    end)

    add:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    add:SetScript("OnClick", function()
        if SpellList_AddSpell(self, input:GetText()) then
            input:SetText("")
            input:ClearFocus()
            PlaySound(SOUNDKIT.IG_MAINMENU_OPTION, "master")
        else
            PlaySound(SOUNDKIT.IG_QUEST_LOG_ABANDON_QUEST, "master")
        end
    end)

    input:SetScript("OnEnterPressed", function(editBox)
        add:Click()
    end)

    input:SetScript("OnEscapePressed", function(editBox)
        editBox:ClearFocus()
    end)

    popup:SetScript("OnShow", function()
        popup.title:SetText(l(self:GetAttribute("title")) or SPELLS)
        SpellList_Refresh(self)
    end)

	popup:SetShown(show)
    self._popup = popup
    return popup
end

function K_SHARED_UI.SpellListWidget_OnLoad(self)
    self.type = "spellList"
    AssignNameSpace_OnLoad(self)

    self._spells = {}

	self.SetValue = SpellList_SetSpells;
	self.GetValue = SpellList_GetSpells;
    self.AddSpell = SpellList_AddSpell
    self.RemoveSpell = SpellList_RemoveSpell

    local label = self:GetAttribute("text") or ""
    label = l(label) or _G[label] or label
    self:SetText(label)

    self:SetScript("OnClick", function(button)
        local popup = SpellList_CreatePopup(button, false)

        if popup:IsShown() then
            popup:Hide()
        else
            popup:ClearAllPoints()
            popup:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0, 0)
            popup:Show()
        end
    end)
end

function K_SHARED_UI.SpellListWidget_OnEnter(self)
    if not self:IsEnabled() then
        return
    end

    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    SpellList_RefreshTooltip(self)
end

function K_SHARED_UI.SpellListWidget_OnLeave(self)
    GameTooltip:Hide()
end

-- #endregion