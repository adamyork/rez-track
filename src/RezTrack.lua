local RezTrack = LibStub("AceAddon-3.0"):NewAddon("RezTrack", "AceConsole-3.0","AceEvent-3.0","AceTimer-3.0")
local AceGUI = LibStub("AceGUI-3.0") 
local db
local scoreUpdateBuffer

function RezTrack:OnInitialize()
	self.timeleft = 0
end

function RezTrack:OnEnable()
	self:Print("RezTrack Loaded");
	self:RegisterChatCommand("rt","HandleSlashCommands")
	self:RegisterEvent("PLAYER_DEAD","PlayerHasDied")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA","HandleZoneChange")
	self:RegisterEvent("PLAYER_ENTERING_WORLD","HandleZoneChange")
	self.englishFaction, self.localizedFaction = UnitFactionGroup("player")
	if self.englishFaction == "Alliance" then
		self.factionInt = 1
	else
		self.factionInt = 0
	end
	self:Print("RezTrack faction is ",self.englishFaction)
end

function RezTrack:OnDisable()
	
end

function RezTrack:HandleSlashCommands(cmds)
	if cmds == "lock" then
		self:ToggleLock(true)
	elseif cmds == "unlock" then
		self:ToggleLock(false)
	elseif cmds == "hide" then
		self.container:Hide()
	elseif cmds == "show" then
		self.container:Show()
	elseif cmds == "resize false" then
		self:ToggleResize(false)
	elseif cmds == "resize true" then
		self:ToggleResize(true)
	elseif cmds == "scores" then
		self:Print(GetNumBattlefieldScores())
	else
		self:Print("RezTrack unknown slash command.");
		self:Print("RezTrack supported slash commands :");
		self:Print("lock")
		self:Print("unlock")
		self:Print("hide")
		self:Print("show")
	end
end

function RezTrack:ToggleLock(val)
	if val == true then	
		self.container:SetScript("OnDragStart", nil)
		self.container:SetScript("OnDragStop", nil)
		self.container:SetMovable(false)
		self.container:EnableMouse(false)
		self.container:SetResizable(false)
	else
		self.container:SetScript("OnDragStart", self.container.StartMoving)
		self.container:SetScript("OnDragStop", self.container.StopMovingOrSizing)
		self.container:SetMovable(true)
		self.container:EnableMouse(true)
	end	
end

function RezTrack:ToggleResize(val)
	self:Print("togglin ")
	if val == true then	
		self.container:SetScript("OnDragStart", function(self,event,...)
			self:SetScript("OnUpdate", function(self,event,...)
				for i = 0, RezTrack.totalMembers do
					self["pMember" .. i]:SetWidth(self:GetWidth())
					--self["pMember" .. i]:SetHeight(self:GetHeight()/RezTrack.totalMembers)
				end
			end)
			self:StartSizing()
		end)
		
		self.container:SetScript("OnDragStop",function(self,event,...)
			self:SetScript("OnUpdate",nil)
			self:StopMovingOrSizing()
		end)
		self.container:EnableMouse(true)
		self.container:SetResizable(true)
	else
		self.container:SetScript("OnDragStart", nil)
		self.container:SetScript("OnDragStop", nil)
		self.container:SetScript("OnReceiveDrag", nil)
		self.container:EnableMouse(false)
		self.container:SetResizable(false)
	end	
end

function RezTrack:HandleZoneChange(event,...)
	self:Print("RezTrack checking zone")
	local zoneType = select(2,IsInInstance())
	if (zoneType == "pvp") then
		self:Print("RezTrack found battleground. buiding ui...")
		scoreUpdateBuffer = GetTime()
		self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE","HandleScoreUpdate")
	end
end

function RezTrack:HandleScoreUpdate()
	self:Print("scored updated building ui")
	local safety = GetNumBattlefieldScores()
	if safety == 0 then
		self:Print("returning cus score is 0")
		return
	end
	local delta = GetTime() - scoreUpdateBuffer
	if delta < 1 then
		return
	end
	self:BuildUI()
end

function RezTrack:BuildUI()
	self.container = CreateFrame("Frame","RezTrackContainer",UIParent)
	self.container:SetFrameStrata("HIGH")
	self.container:SetWidth(128)
	self.container:RegisterForDrag("LeftButton")
	
	local t = self.container:CreateTexture(nil,"BACKGROUND")
	t:SetTexture(0,0,0,1)
	t:SetAllPoints(self.container)
	self.container.texture = t
	
	print("test " .. GetNumBattlefieldScores())
	self.totalMembers = 0
	for i = 1, GetNumBattlefieldScores() do 
		self:Print("magoosh")
		local name, killingBlows, honorKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone = GetBattlefieldScore(i)
		self:Print("faction " .. faction)
		self:Print("englishFaction " .. self.englishFaction)
		self:Print("name " .. name)
		if faction == self.factionInt then
			self:Print("manky")
			self.totalMembers = self.totalMembers + 1
			self.container["pMember" .. self.totalMembers] = CreateFrame("Frame",nil,self.container)
			self.container:SetFrameStrata("BACKGROUND")
			self.container["pMember" .. self.totalMembers]:SetWidth(128)
			self.container["pMember" .. self.totalMembers]:SetHeight(20)
			self.container["pMember" .. self.totalMembers]:SetResizable(true)
			self:Print("step 1")
			local tb = self.container["pMember" .. self.totalMembers]:CreateTexture(nil, "BORDER")
			tb:SetTexture(0, 0, 0, 1)
			tb:SetPoint("TOPLEFT", self.container["pMember" .. self.totalMembers], 1, -1)
			tb:SetPoint("BOTTOMRIGHT", self.container["pMember" .. self.totalMembers],-1, 1)
			self:Print("step 2")
			local t = self.container["pMember" .. self.totalMembers]:CreateTexture(nil,"BACKGROUND")
			t:SetTexture(1,1,1,1)
			t:SetAllPoints(self.container["pMember" .. self.totalMembers])
			self:Print("step 3")
			local fs_status = self.container["pMember" .. self.totalMembers]:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			fs_status:SetHeight(12)
			fs_status:SetPoint("RIGHT", self.container["pMember" .. self.totalMembers], 0,0)
			fs_status:SetJustifyH("RIGHT")
			fs_status:SetText("Time")
			fs_status:SetTextColor(1, 1, 1, 1)
			self:Print("step 4")
			local fs_name = self.container["pMember" .. self.totalMembers]:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			fs_name:SetHeight(12)
			fs_name:SetPoint("Left", self.container["pMember" .. self.totalMembers], 0,0)
			fs_name:SetJustifyH("Left")
			local pName,pRealm = strsplit("-",name)
			fs_name:SetText(pName)
			fs_name:SetTextColor(1, 1, 1, 1)
			self:Print("step 5")
			self.container["pMember" .. self.totalMembers].texture = t
			self.container["pMember" .. self.totalMembers]:SetPoint("TOPLEFT",self.container,0,-(20*(self.totalMembers-1)))
			self.container["pMember" .. self.totalMembers]:Show()
			self:Print("step 6")
		end
	end
	
	self.container:SetHeight(self.totalMembers * 20)
	
	self.container:SetPoint("CENTER",0,0)
	self.container:Show()
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