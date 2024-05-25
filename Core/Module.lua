--@ Class Module
local _, ns = ...
local l = ns.I18N;

local function noop() end;
ns.Module = {};
ns.Module.__index = ns.Module;

-- Calls from modules
function ns.Module:new(onInit, name)
	local self = {};
	setmetatable(self, ns.Module);
	self.onInit = onInit;
	self.name = name;
	self.onSaveOptions = noop;
	self.getInfo = noop;
	self.isloaded = false;

	tinsert(ns.MODULES, self);
	return self;
end
function ns.Module:SetOnSaveOptions(onSaveOptions)
	self.onSaveOptions = onSaveOptions;
	return self;
end
function ns.Module:SetGetInfo(getInfo)
	self.getInfo = getInfo;
	return self;
end

-- Calls from Core
function ns.Module:Init(...)
	if (ns.AddMsgDebug) then
		ns.AddMsgDebug(format("Loading <%s> module...", self.name or "Unnamed?"));
	end
	self.onInit(self, ...);
	self.isloaded = true;
	return self;
end
function ns.Module:OnSaveOptions(...)
	if (self.isloaded) then
		self.onSaveOptions(self, ...);
	else
		ns.AddMsgWarn(l.INIT_FAILED);
	end
end
-- Only if Standalone
function ns.Module:GetInfo(...)
	if (self.isloaded) then
		self.getInfo(self, ...);
	else
		ns.AddMsgWarn(l.INIT_FAILED);
	end
end

function ns.Module:Name()
	return self.name;
end
function ns.Module:IsLoaded()
	return self.isloaded;
end