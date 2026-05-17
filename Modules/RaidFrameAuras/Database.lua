local _, ns = ...
local l = ns.I18N;

-- * avoid conflict override
if ns.CONFLICT then return; end

local RaidFrameAuras = ns.RaidFrameAuras
if not RaidFrameAuras then return end

local DEFAULTS = ns.DEFAULTS or {}
local Constants = ns.Constants or {}
local State = ns.State or {}
local Util = ns.Util or {}
local VALID_AURA_FRAME_STRATA = Constants.VALID_AURA_FRAME_STRATA or {}
local VALID_AURA_ANCHOR_TARGETS = Constants.VALID_AURA_ANCHOR_TARGETS or {}
local VALID_AURA_ANCHORS = Constants.ANCHOR_FACTORS or {}
local MAX_PRIVATE_AURA_SLOTS = Constants.MAX_PRIVATE_AURA_SLOTS or 4
local DB_VERSION = ns.DB_VERSION or 1303

local LAYOUT_ONLY_OPTIONS = {
    previewWidth = true,
    previewHeight = true,
    auraAnchorTarget = true,
    buffAutoScale = true,
    buffAutoScaleMinSize = true,
    buffAutoScaleMaxSize = true,
    debuffAutoScale = true,
    debuffAutoScaleMinSize = true,
    debuffAutoScaleMaxSize = true,
    bossDebuffsEnabled = true,
    privateAuraMax = true,
    privateAuraScale = true,
    privateAuraAnchor = true,
    privateAuraGrowth = true,
    privateAuraWrap = true,
    privateAuraOffsetX = true,
    privateAuraOffsetY = true,
}

local PASSIVE_OPTIONS = {
    debugMode = true,
    perfMode = true,
}

local function ClampOption(db, key, minValue, maxValue)
    db[key] = Util.Clamp(db[key], minValue, maxValue, DEFAULTS[key])
end

local VALID_GROWTH_DIRECTIONS = {
    LEFT_UP = true,
    LEFT_DOWN = true,
    RIGHT_UP = true,
    RIGHT_DOWN = true,
    UP_LEFT = true,
    UP_RIGHT = true,
    DOWN_LEFT = true,
    DOWN_RIGHT = true,
    CENTER_UP = true,
    CENTER_DOWN = true,
    CENTER_LEFT = true,
    CENTER_RIGHT = true,
}

local function GetAuraPrefix(auraTypeOrPrefix)
    if auraTypeOrPrefix == "BUFF" or auraTypeOrPrefix == "buff" then
        return "buff"
    elseif auraTypeOrPrefix == "DEBUFF" or auraTypeOrPrefix == "debuff" then
        return "debuff"
    end
    return nil
end


local OBSOLETE_SAVED_VARIABLE_KEYS = {
    buffScale = true,
    debuffScale = true,
    buffBlacklist = true,
    debuffBlacklist = true,
    blacklistBuffs = true,
    blacklistDebuffs = true,
    blacklistedBuffs = true,
    blacklistedDebuffs = true,
    buffBlacklistEnabled = true,
    debuffBlacklistEnabled = true,
    hiddenBuffs = true,
    hiddenDebuffs = true,
    directDebuffFilterRaidHideInCombat = true,
    directBuffHideLongInCombat = true,
    directBuffHideLongInCombatThreshold = true,
    directBuffHideLongThreshold = true,
}

local function RemoveObsoleteKeys(db)
    for key in pairs(OBSOLETE_SAVED_VARIABLE_KEYS) do
        db[key] = nil
    end
end

local LEGACY_PRIVATE_AURA_DEFAULTS = {
    privateAuraMax = 4,
    privateAuraScale = 1,
    privateAuraAnchor = "BOTTOMLEFT",
    privateAuraGrowth = "RIGHT_UP",
    privateAuraWrap = 3,
    privateAuraOffsetX = -17,
    privateAuraOffsetY = -17,
}

local function HasLegacyPrivateAuraDefaults(db)
    return tonumber(db.privateAuraMax) == LEGACY_PRIVATE_AURA_DEFAULTS.privateAuraMax
        and tonumber(db.privateAuraScale) == LEGACY_PRIVATE_AURA_DEFAULTS.privateAuraScale
        and db.privateAuraAnchor == LEGACY_PRIVATE_AURA_DEFAULTS.privateAuraAnchor
        and db.privateAuraGrowth == LEGACY_PRIVATE_AURA_DEFAULTS.privateAuraGrowth
        and tonumber(db.privateAuraWrap) == LEGACY_PRIVATE_AURA_DEFAULTS.privateAuraWrap
        and tonumber(db.privateAuraOffsetX) == LEGACY_PRIVATE_AURA_DEFAULTS.privateAuraOffsetX
        and tonumber(db.privateAuraOffsetY) == LEGACY_PRIVATE_AURA_DEFAULTS.privateAuraOffsetY
end

function RaidFrameAuras:MigrateDatabase(db)
    if type(db) ~= "table" then return end
    local previousVersion = tonumber(db.dbVersion) or 0

    -- Split the old single "Hide long buffs in combat" option into:
    --   Hide long buffs / Only in combat
    -- Preserve existing user intent before deleting the obsolete keys.
    if db.directBuffHideLong == nil and db.directBuffHideLongInCombat ~= nil then
        db.directBuffHideLong = db.directBuffHideLongInCombat == true
    end
    if db.directBuffHideLongOnlyInCombat == nil then
        if db.directBuffHideLongInCombat ~= nil then
            db.directBuffHideLongOnlyInCombat = true
        else
            db.directBuffHideLongOnlyInCombat = DEFAULTS.directBuffHideLongOnlyInCombat == true
        end
    end

    -- DB 1302: encounter debuffs are too important to miss when Blizzard has
    -- not tagged them with one of the narrower raid-frame categories.
    if previousVersion < 1302 then
        db.directDebuffShowAll = true
    end

    -- DB 1303: move untouched boss-debuff overlay profiles to the new defaults.
    if previousVersion < 1303 and HasLegacyPrivateAuraDefaults(db) then
        db.privateAuraMax = DEFAULTS.privateAuraMax
        db.privateAuraScale = DEFAULTS.privateAuraScale
        db.privateAuraAnchor = DEFAULTS.privateAuraAnchor
        db.privateAuraGrowth = DEFAULTS.privateAuraGrowth
        db.privateAuraWrap = DEFAULTS.privateAuraWrap
        db.privateAuraOffsetX = DEFAULTS.privateAuraOffsetX
        db.privateAuraOffsetY = DEFAULTS.privateAuraOffsetY
    end

    -- Release cleanup: remove legacy keys and removed combat toggles.
    RemoveObsoleteKeys(db)

    db.dbVersion = DB_VERSION
end

local function ClampAutoScaleOptions(db, prefix)
    ClampOption(db, prefix .. "AutoScaleMinSize", 4, 80)
    ClampOption(db, prefix .. "AutoScaleMaxSize", 4, 120)
    if db[prefix .. "AutoScaleMaxSize"] < db[prefix .. "AutoScaleMinSize"] then
        db[prefix .. "AutoScaleMaxSize"] = db[prefix .. "AutoScaleMinSize"]
    end
    db[prefix .. "AutoScale"] = db[prefix .. "AutoScale"] == true
end

local function ClampPrivateAuraOptions(db)
    ClampOption(db, "privateAuraMax", 1, MAX_PRIVATE_AURA_SLOTS)
    ClampOption(db, "privateAuraScale", Constants.CATEGORY_SCALE_MIN or 0.5, Constants.CATEGORY_SCALE_MAX or 2)
    ClampOption(db, "privateAuraWrap", 1, MAX_PRIVATE_AURA_SLOTS)
    db.privateAuraMax = math.floor((tonumber(db.privateAuraMax) or DEFAULTS.privateAuraMax or MAX_PRIVATE_AURA_SLOTS) + 0.5)
    db.privateAuraWrap = math.floor((tonumber(db.privateAuraWrap) or DEFAULTS.privateAuraWrap or 1) + 0.5)
    ClampOption(db, "privateAuraOffsetX", -120, 120)
    ClampOption(db, "privateAuraOffsetY", -120, 120)
    if not VALID_AURA_ANCHORS[db.privateAuraAnchor] then
        db.privateAuraAnchor = DEFAULTS.privateAuraAnchor
    end
    if not VALID_GROWTH_DIRECTIONS[db.privateAuraGrowth] then
        db.privateAuraGrowth = DEFAULTS.privateAuraGrowth
    end
end

function RaidFrameAuras:InitializeDatabase()
    RaidFrameAurasDB = type(RaidFrameAurasDB) == "table" and RaidFrameAurasDB or {}
    self:MigrateDatabase(RaidFrameAurasDB)
    Util.CopyDefaults(DEFAULTS, RaidFrameAurasDB)
    RaidFrameAurasDB.dbVersion = DB_VERSION
    if not VALID_AURA_FRAME_STRATA[RaidFrameAurasDB.auraFrameStrata] then
        RaidFrameAurasDB.auraFrameStrata = DEFAULTS.auraFrameStrata
    end
    if not VALID_AURA_ANCHOR_TARGETS[RaidFrameAurasDB.auraAnchorTarget] then
        RaidFrameAurasDB.auraAnchorTarget = DEFAULTS.auraAnchorTarget
    end
    ClampOption(RaidFrameAurasDB, "previewWidth", Constants.PREVIEW_WIDTH_MIN or 72, Constants.PREVIEW_WIDTH_MAX or 144)
    ClampOption(RaidFrameAurasDB, "previewHeight", Constants.PREVIEW_HEIGHT_MIN or 36, Constants.PREVIEW_HEIGHT_MAX or 72)
    ClampOption(RaidFrameAurasDB, "thresholdExpiringSoon", 1, 60)
    ClampOption(RaidFrameAurasDB, "thresholdShortDuration", 5, 300)
    ClampOption(RaidFrameAurasDB, "thresholdLongDuration", 60, 3600)
    ClampOption(RaidFrameAurasDB, "thresholdTransitionOffset", -2, 2)
    ClampPrivateAuraOptions(RaidFrameAurasDB)
    ClampAutoScaleOptions(RaidFrameAurasDB, "buff")
    ClampAutoScaleOptions(RaidFrameAurasDB, "debuff")
    self.db = RaidFrameAurasDB
end

function RaidFrameAuras:GetOption(key)
    if self.db and self.db[key] ~= nil then
        return self.db[key]
    end
    return DEFAULTS[key]
end

function RaidFrameAuras:SetOption(key, value)
    if not self.db then self:InitializeDatabase() end
    if key == "auraFrameStrata" and not VALID_AURA_FRAME_STRATA[value] then
        value = DEFAULTS.auraFrameStrata
    elseif key == "auraAnchorTarget" and not VALID_AURA_ANCHOR_TARGETS[value] then
        value = DEFAULTS.auraAnchorTarget
    elseif key == "previewWidth" then
        value = Util.Clamp(value, Constants.PREVIEW_WIDTH_MIN or 72, Constants.PREVIEW_WIDTH_MAX or 144, DEFAULTS.previewWidth)
    elseif key == "previewHeight" then
        value = Util.Clamp(value, Constants.PREVIEW_HEIGHT_MIN or 36, Constants.PREVIEW_HEIGHT_MAX or 72, DEFAULTS.previewHeight)
    elseif key == "thresholdExpiringSoon" then
        value = Util.Clamp(value, 1, 60, DEFAULTS.thresholdExpiringSoon)
    elseif key == "thresholdShortDuration" then
        value = Util.Clamp(value, 5, 300, DEFAULTS.thresholdShortDuration)
    elseif key == "thresholdLongDuration" then
        value = Util.Clamp(value, 60, 3600, DEFAULTS.thresholdLongDuration)
    elseif key == "thresholdTransitionOffset" then
        value = Util.Clamp(value, -2, 2, DEFAULTS.thresholdTransitionOffset)
    elseif key == "directBuffHideLong" or key == "directBuffHideLongOnlyInCombat" or key == "directBuffFilterRaidHideInCombat" or key == "bossDebuffsEnabled" then
        value = value == true
    elseif key == "privateAuraAnchor" then
        if not VALID_AURA_ANCHORS[value] then
            value = DEFAULTS.privateAuraAnchor
        end
    elseif key == "privateAuraGrowth" then
        if not VALID_GROWTH_DIRECTIONS[value] then
            value = DEFAULTS.privateAuraGrowth
        end
    elseif key == "privateAuraMax" then
        value = math.floor(Util.Clamp(value, 1, MAX_PRIVATE_AURA_SLOTS, DEFAULTS.privateAuraMax) + 0.5)
    elseif key == "privateAuraScale" then
        value = Util.Clamp(value, Constants.CATEGORY_SCALE_MIN or 0.5, Constants.CATEGORY_SCALE_MAX or 2, DEFAULTS.privateAuraScale)
    elseif key == "privateAuraWrap" then
        value = math.floor(Util.Clamp(value, 1, MAX_PRIVATE_AURA_SLOTS, DEFAULTS.privateAuraWrap) + 0.5)
    elseif key == "privateAuraOffsetX" or key == "privateAuraOffsetY" then
        value = Util.Clamp(value, -120, 120, DEFAULTS[key])
    elseif key == "buffAutoScaleMinSize" or key == "debuffAutoScaleMinSize" then
        value = Util.Clamp(value, 4, 80, DEFAULTS[key])
    elseif key == "buffAutoScaleMaxSize" or key == "debuffAutoScaleMaxSize" then
        value = Util.Clamp(value, 4, 120, DEFAULTS[key])
    elseif key == "buffAutoScale" or key == "debuffAutoScale" then
        value = value == true
    end
    self.db[key] = value

    local prefix = key and key:match("^(buff)AutoScale") or key and key:match("^(debuff)AutoScale")
    if prefix then
        ClampAutoScaleOptions(self.db, prefix)
    end

    if PASSIVE_OPTIONS[key] then
        if self.RefreshOptionControls then self:RefreshOptionControls() end
        return
    end

    self:ApplySettings(not LAYOUT_ONLY_OPTIONS[key])
end

function RaidFrameAuras:SetAuraAutoScaleEnabled(auraTypeOrPrefix, enabled)
    if not self.db then self:InitializeDatabase() end
    local prefix = GetAuraPrefix(auraTypeOrPrefix)
    if not prefix then return end

    self.db[prefix .. "AutoScale"] = enabled == true
    ClampAutoScaleOptions(self.db, prefix)
    self:ApplySettings(false)
end

function RaidFrameAuras:ResetOptions()
    if not self.db then self:InitializeDatabase() end
    wipe(self.db)
    Util.CopyDefaults(DEFAULTS, self.db)
    self.db.dbVersion = DB_VERSION
    self:ApplySettings(true)
end

function RaidFrameAuras:ApplySettings(rebuildData)
    if rebuildData then
        State.layoutVersion = (State.layoutVersion or 0) + 1
        self:InvalidateAuraData()
    end
    self:ScheduleRefreshBurst("settings")
    if self.RefreshOptionControls then self:RefreshOptionControls() end
    if self.RefreshPreview then self:RefreshPreview() end
end
