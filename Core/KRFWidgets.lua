local _, ns = ...
local l = ns.I18N;


--[[
! Checkbox Widget
Simple checkbutton widget with text
]]
function KRFUI.CheckboxWidget_OnClick(self)
	if ( self:GetChecked() ) then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON, "Master")
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF, "Master")
	end
end
function KRFUI.CheckboxWidget_OnLoad(self)
	self.type = "checkbox";

	local text = self:GetAttribute("text");
	text = KRFUI.l[text] or _G[text] or text;

	self.Text:SetText(text);
end
function KRFUI.CheckboxWidget_OnEnter(self)
	if (not self:IsEnabled()) then return end;
	local text = self:GetAttribute("text") or self:GetAttribute("title") or "";
	text = KRFUI.l[text] or _G[text] or text;

	local tooltip = self:GetAttribute("tooltip") or "";
	tooltip = KRFUI.l[tooltip] or _G[tooltip] or tooltip;
	tooltip = tooltip ~= text and tooltip or "";

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(l.WH..text);
	GameTooltip:AddLine(tooltip, 1, 0.82, 0, 1);
	GameTooltip:AppendText("");
end
function KRFUI.CheckboxWidget_OnLeave(self)
	-- GameTooltip:Hide();
end

--[[
! Heading Widget
Using a checkbutton widget and hide checkbox
]]
function KRFUI.HeadingWidget_OnLoad (self)
	local transparent = self:CreateTexture(nil, "BACKGROUND")
	self:SetNormalTexture(transparent);
	self:SetHighlightTexture(transparent);
	self:SetPushedTexture(transparent);

	local text = self:GetAttribute("text");
	text = KRFUI.l[text] or _G[text] or text;

	local label = self:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
	label:SetPoint("TOP")
	label:SetPoint("BOTTOM")
	label:SetJustifyH("CENTER")
	label:SetText(text);
	
	local left = self:CreateTexture(nil, "BACKGROUND")
	left:SetHeight(8)
	left:SetPoint("LEFT", 3, 0)
	left:SetPoint("RIGHT", label, "LEFT", text ~= "" and -5 or 1, 0)
	left:SetTexture(137057) -- Interface\\Tooltips\\UI-Tooltip-Border
	left:SetTexCoord(0.81, 0.94, 0.5, 1)

	local right = self:CreateTexture(nil, "BACKGROUND")
	right:SetHeight(8)
	right:SetPoint("RIGHT", -3, 0)
	right:SetPoint("LEFT", label, "RIGHT", text ~= "" and 5 or -1, 0)
	right:SetTexture(137057) -- Interface\\Tooltips\\UI-Tooltip-Border
	right:SetTexCoord(0.81, 0.94, 0.5, 1);
end
-- disable checked state
function KRFUI.HeadingWidget_OnClick(self)
	self:SetChecked(false);
end

--[[
! Color Widget
-- Removed OpacitySliderFrame, Since Dragonflight (10)
]]
local function ColorWidget_ShowColorPicker(pickedCallback, cancelledCallback, self)
	ColorPickerFrame.Self = self;
	local r,g,b,o = self._RGBA.r, self._RGBA.g, self._RGBA.b, self._RGBA.a or nil;
	local info = {
		swatchFunc = pickedCallback,

		hasOpacity = (o ~= nil),
		opacityFunc = pickedCallback,
		opacity = o,

		cancelFunc = cancelledCallback,

		r = r,
		g = g,
		b = b,
	}
	ColorPickerFrame:SetupColorPickerAndShow(info)
end
local function ColorWidget_ColorPickedCallback()
	local newR, newG, newB = ColorPickerFrame:GetColorRGB();
	local newA = ColorPickerFrame:GetColorAlpha();
	ColorPickerFrame.Self.SetColor(ColorPickerFrame.Self, { r = newR , g = newG, b = newB, a = newA });
end
local function ColorWidget_ColorCancelledCallback()
	local newR, newG, newB, newA = ColorPickerFrame:GetPreviousValues();
	ColorPickerFrame.Self.SetColor(ColorPickerFrame.Self, { r = newR , g = newG, b = newB, a = newA });
end

--[[
! Color Widget Classic
]]
local function ColorWidget_ShowColorPicker_Classic(pickedCallback, cancelledCallback, self)
	ColorPickerFrame.Self = self;
	local r,g,b,o = self._RGBA.r, self._RGBA.g, self._RGBA.b, self._RGBA.a or nil;
	ColorPickerFrame:SetColorRGB(r,g,b);
	ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (o ~= nil), 1 - o;
	ColorPickerFrame._previousValues = {r, g, b, o};
	ColorPickerFrame.func, ColorPickerFrame.swatchFunc, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc =
		pickedCallback, pickedCallback, pickedCallback, cancelledCallback;
	ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
	ColorPickerFrame:Show();
end
local function ColorWidget_ColorPickedCallback_Classic()
	local newR, newG, newB = ColorPickerFrame:GetColorRGB();
	local newA = 1 - OpacitySliderFrame:GetValue();
	ColorPickerFrame.Self.SetColor(ColorPickerFrame.Self, { r = newR , g = newG, b = newB, a = newA });
end
local function ColorWidget_ColorCancelledCallback_Classic()
	local newR, newG, newB, newA = unpack(ColorPickerFrame._previousValues);
	ColorPickerFrame.Self.SetColor(ColorPickerFrame.Self, { r = newR , g = newG, b = newB, a = newA });
end

local function ColorWidget_SetColor(self, RGBA)
	self._RGBA = RGBA or self._RGBA;
	self._colorSwatch:SetVertexColor(self._RGBA.r, self._RGBA.g, self._RGBA.b, self._RGBA.a)
end
local function ColorWidget_GetColor(self)
	return self._RGBA;
end

function KRFUI.ColorWidget_OnLoad (self)
	self.type = "color";

	local text = self:GetAttribute("text");
	text = KRFUI.l[text] or _G[text] or text;

	self._RGBA = { r=1, g=1, b=1, a=1}
	self.SetColor = ColorWidget_SetColor;
	self.GetColor = ColorWidget_GetColor;

	self:EnableMouse(true)

	local transparent = self:CreateTexture(nil, "BACKGROUND")
	self:SetNormalTexture(transparent)

	local colorSwatch = self:CreateTexture(nil, "OVERLAY")
	colorSwatch:SetWidth(20)
	colorSwatch:SetHeight(20)
	colorSwatch:SetTexture(130939) -- Interface\\ChatFrame\\ChatFrameColorSwatch
	colorSwatch:SetPoint("LEFT", 4, 0)
	self._colorSwatch = colorSwatch

	local texture = self:CreateTexture(nil, "BACKGROUND")
	colorSwatch.background = texture
	texture:SetWidth(16)
	texture:SetHeight(16)
	texture:SetColorTexture(1, 1, 1)
	texture:SetPoint("CENTER", colorSwatch)
	texture:Show()

	local checkers = self:CreateTexture(nil, "BACKGROUND")
	colorSwatch.checkers = checkers
	checkers:SetWidth(14)
	checkers:SetHeight(14)
	checkers:SetTexture(188523) -- Tileset\\Generic\\Checkers
	checkers:SetTexCoord(.25, 0, 0.5, .25)
	checkers:SetDesaturated(true)
	checkers:SetVertexColor(1, 1, 1, 0.75)
	checkers:SetPoint("CENTER", colorSwatch)
	checkers:Show()

	self.Text:SetText(text);
end
function KRFUI.ColorWidget_OnClick(self)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION, "Master")
	if (not OpacitySliderFrame) then
		-- Removed OpacitySliderFrame, Since Dragonflight (10)
		ColorWidget_ShowColorPicker(ColorWidget_ColorPickedCallback, ColorWidget_ColorCancelledCallback, self);
	else
		ColorWidget_ShowColorPicker_Classic(ColorWidget_ColorPickedCallback_Classic, ColorWidget_ColorCancelledCallback_Classic, self);
	end
end
function KRFUI.ColorWidget_OnEnter(self)
	if (not self:IsEnabled()) then return end;
	local text = self:GetAttribute("text") or self:GetAttribute("title") or "";
	text = KRFUI.l[text] or _G[text] or text;
	local tooltip = self:GetAttribute("tooltip") or "";
	tooltip = KRFUI.l[tooltip] or _G[tooltip] or tooltip;
	tooltip = tooltip ~= text and tooltip or "";

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(l.WH..text);
	GameTooltip:AddLine(tooltip, 1, 0.82, 0, 1);
	GameTooltip:AppendText("");
end
function KRFUI.ColorWidget_OnLeave(self)
	GameTooltip:Hide();
end

--[[
! Slider Widget
]]
local function SliderWidget_SetValue (self, value)
	self:SetDisplayValue(value);
	self._Value = value;
end
local function SliderWidget_GetValue(self)
	return self._Value;
end
function KRFUI.SliderWidget_OnLoad (self)
	self.type = CONTROLTYPE_SLIDER;
	-- Since Shadowlands (9)
	if (BackdropTemplateMixin) then
		BackdropTemplateMixin.OnBackdropLoaded(self);
	end

	local text = self:GetAttribute("text") or "";
	text = KRFUI.l[text] or _G[text] or text;

	self._Value = 0;

	self.SetDisplayValue = self.SetValue;
	self.SetValue = SliderWidget_SetValue
	self.GetCurrentValue = SliderWidget_GetValue
	self.Text:SetFontObject("OptionsFontSmall");
	self.Text:SetText(text);
	self.High:Hide();

	self.Label = self.Low;
	self.Label:ClearAllPoints();
	self.Label:SetPoint("LEFT", self, "RIGHT", 3.5, 1);
end
function KRFUI.SliderWidget_OnValueChanged(self, value)
	local format = self:GetAttribute("format") or nil;
	format = KRFUI.l[format] or _G[format] or format;
	self.Label =self.Low;
	local formatRatio = self:GetAttribute("formatRatio") or 1;
	if format ~= nil then
		self.Label:SetFormattedText(format, value * tonumber(formatRatio));
	else
		self.Label:SetText(value * tonumber(formatRatio));
	end
	self:SetValue(value);
end
function KRFUI.SliderWidget_OnEnter(self)
	if (not self:IsEnabled()) then return end;
	local text = self:GetAttribute("text") or self:GetAttribute("title") or "";
	text = KRFUI.l[text] or _G[text] or text;

	local tooltip = self:GetAttribute("tooltip") or "";
	tooltip = KRFUI.l[tooltip] or _G[tooltip] or tooltip;
	tooltip = tooltip ~= text and tooltip or "";

	GameTooltip:SetOwner(self, "ANCHOR_TOP");
	GameTooltip:SetText(l.WH..text);
	GameTooltip:AddLine(tooltip, 1, 0.82, 0, 1);
	GameTooltip:AppendText("");
end
function KRFUI.SliderWidget_OnLeave(self)
	GameTooltip:Hide();
end