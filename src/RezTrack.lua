local RezTrack = LibStub("AceAddon-3.0"):NewAddon("RezTrack", "AceConsole-3.0","AceEvent-3.0","AceTimer-3.0")
local AceGUI = LibStub("AceGUI-3.0") 
local db
local rezFrame

function RezTrack:OnInitialize()
	self.timeleft = 0
end

function RezTrack:OnEnable()
	self:Print("RezTrack Loaded");
	self:RegisterEvent("PLAYER_DEAD","PlayerHasDied")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA","HandleZoneChange")
	self:RegisterEvent("PLAYER_ENTERING_WORLD","HandleZoneChange")
	self.englishFaction, self.localizedFaction = UnitFactionGroup("player")
	self:Print("RezTrack faction is ",self.englishFaction)
end

function RezTrack:OnDisable()
	
end

function RezTrack:HandleZoneChange(event,...)
	self:Print("RezTrack checking zone")
	self:BuildUI()
	local zoneType = select(2,IsInInstance())
	if (zoneType == "pvp") then
		self:Print("RezTrack found battleground. buiding ui...")
		self:BuildUI()
	end
end

function RezTrack:BuildUI()
	self.container = CreateFrame("Frame","RezTrackContainer",UIParent)
	self.container:SetFrameStrata("HIGH")
	self.container:SetWidth(128)
	self.container:SetHeight(400)
	
	local t = self.container:CreateTexture(nil,"BACKGROUND")
	t:SetTexture(0,0,0,1)
	t:SetAllPoints(self.container)
	self.container.texture = t
	
	for i = 1, 20 do 
		self.container["pMember" .. i] = CreateFrame("Frame",nil,self.container.name)
	end
	
	self.container:SetPoint("CENTER",0,0)
	self.container:Show()
	for i = 1, GetNumBattlefieldScores() do
		local name, _, _, _, _, faction, _, _, _, _, _, _ = GetBattlefieldScore(index)
		if faction == self.englishFaction then
			self:AddUnit()
		end
	end
end

function RezTrack:AddUnit()
end

function RezTrack:PlayerHasDied(event,...)
	self:Print("RezTrack ",event)
	self.timeleft = GetCorpseRecoveryDelay()
	self.rezTimer = self:ScheduleRepeatingTimer("TimerFeedback", 1)
end

function RezTrack:TimerFeedback()
  self.timeleft = self.timeleft - 1
  if self.timeleft == 0 then
    self:CancelTimer(self.rezTimer)
    self:Print("RezTrack you may rez now.")
  else
  	self:Print("RezTrack , waiting for rez : ",self.timeleft)
  end
end