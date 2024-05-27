--@ Class Module
local _, ns = ...
local l = ns.I18N;

local function noop() end;
ns.Module = {};
ns.Module.__index = ns.Module;
ns.Module.cacheOptions = {};

-- Constructeur pour les modules
function ns.Module:new(onInit, name)
	local instance = setmetatable({}, ns.Module);
	instance.onInit = onInit or noop;
	instance.name = name or "Unnamed";
	instance.onSaveOptions = noop;
	instance.getInfo = noop;
	instance.isLoaded = false;

	table.insert(ns.MODULES, instance);
	return instance;
end

--#region Setters for callbacks
function ns.Module:SetOnSaveOptions(onSaveOptions)
	self.onSaveOptions = onSaveOptions or noop;
	return self;
end

function ns.Module:SetGetInfo(getInfo)
	self.getInfo = getInfo or noop;
	return self;
end
--#endregion

--#region CalledByCore
function ns.Module:Init(options, ...)
	if ns.AddMsgDebug then
		ns.AddMsgDebug(string.format("Loading <%s> module...", self.name));
	end
	ns.Module.cacheOptions = options or {};
	self.onInit(self, ns.Module.cacheOptions, ...);
	self.isLoaded = true;
	return self;
end

function ns.Module:OnSaveOptions(options, ...)
    if not self.isLoaded then
        ns.AddMsgWarn(l.INIT_FAILED)
        return
    end
    ns.Module.cacheOptions = options or ns.Module.cacheOptions;
    self.onSaveOptions(self, ns.Module.cacheOptions, ...)
end

-- Only if Standalone
function ns.Module:GetInfo(...)
    if not self.isLoaded then
        ns.AddMsgWarn(l.INIT_FAILED)
        return
    end
    self.getInfo(self, ...)
end

function ns.Module:Name()
	return self.name;
end

function ns.Module:IsLoaded()
	return self.isLoaded;
end

function ns.Module:GetCacheOptions()
	return ns.Module.cacheOptions;
end
--#endregion