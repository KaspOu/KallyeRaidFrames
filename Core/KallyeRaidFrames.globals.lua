
KRF_VERSION       = C_AddOns.GetAddOnMetadata("KallyeRaidFrames", "Version");
KRF_VERSIONNR     = tonumber(gsub(KRF_VERSION, "%D", ""), 10);
if (C_AddOns.GetAddOnInfo) then
  KRF_ADDON_NAME,KRF_TITLE, KRF_NOTES = C_AddOns.GetAddOnInfo("KallyeRaidFrames");
else
  KRF_ADDON_NAME,KRF_TITLE, KRF_NOTES = GetAddOnInfo("KallyeRaidFrames");
end
BINDING_NAME_KRaidFrames =  KRF_ADDON_NAME.." options";

KRF_IS_RETAIL = (WOW_PROJECT_ID == (WOW_PROJECT_MAINLINE or 1));

KRF_HAS_colorNameBySelection = KRF_IS_RETAIL; -- colorNameBySelection, Since BfA (7)

-- Returns a chat color code string
function BCC(r, g, b)
  return string.format("|cff%02x%02x%02x", (r*255), (g*255), (b*255));
end


KRF_Globals = {
  scrollBarX = KRF_IS_RETAIL and 6 or -2,

  RT8 = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t",
  BL  = BCC(0.1, 0.1, 1.0),
  BLD = BCC(0.0, 0.0, 0.7),
  BLL = BCC(0.5, 0.8, 1.0),
  GR  = BCC(0.1, 1.0, 0.1),
  GRD = BCC(0.0, 0.7, 0.0),
  GRL = BCC(0.25, 0.75, 0.25),
  RD  = BCC(1.0, 0.1, 0.1),
  RDD = BCC(0.7, 0.0, 0.0),
  RDL = BCC(1.0, 0.3, 0.3),
  YL  = BCC(1.0, 1.0, 0.0),
  YLD = BCC(0.7, 0.7, 0.0),
  YLL = BCC(1.0, 1.0, 0.5),
  OR  = BCC(1.0, 0.5, 0.25),
  ORD = BCC(0.7, 0.5, 0.0),
  ORL = BCC(1.0, 0.6, 0.3),
  WH  = BCC(1.0, 1.0, 1.0),
  CY  = BCC(0.5, 1.0, 1.0),
  GY  = BCC(0.5, 0.5, 0.5),
  GYD = BCC(0.35, 0.35, 0.35),
  GYL = BCC(0.65, 0.65, 0.65),

  IsDebugFramesTimerActive = false;
};