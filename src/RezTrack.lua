local RezTrack = LibStub("AceAddon-3.0"):NewAddon("RezTrack", "AceConsole-3.0","AceEvent-3.0","AceTimer-3.0")
local AceGUI = LibStub("AceGUI-3.0") 
local db
local scoreUpdateBuffer
local allFrames

function RezTrack:OnInitialize()
	self.timeleft = 0
end

function RezTrack:OnEnable()
	self:Print("RezTrack Loaded");
	self:RegisterChatCommand("rt","HandleSlashCommands")
	self:RegisterEvent("PLAYER_DEAD","PlayerHasDied")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA","HandleZoneChange")
	self:RegisterEvent("PLAYER_ENTERING_WORLD","HandleZoneChange")
	RegisterAddonMessagePrefix("RezTrack")
	self:RegisterEvent("CHAT_MSG_ADDON","HandleAddonNotfied")
	self.englishFaction, self.localizedFaction = UnitFactionGroup("player")
	if self.englishFaction == "Alliance" then
		self.factionInt = 1
	else
		self.factionInt = 0
	end
	self:Print("RezTrack faction is ",self.englishFaction)
end

function RezTrack:OnDisable()
	self:UnregisterEvent("PLAYER_DEAD")
	self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("CHAT_MSG_ADDON")
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
	elseif cmds == "test" then
		self:BuildContainerAndDefaults()
		local targetFrame = select(1,self.container:GetChildren())
		targetFrame.pName = "Out"
		targetFrame.pRealm = "Velen"
		targetFrame.nameText:SetText("Out")
	elseif cmds == "msg" then
		local pName,pRealm = UnitName("player")
		if pRealm == nil then
			pRealm = GetRealmName()
		end
		local fEvent= (pName .. "-" .. pRealm .. "-" .. 30)
		SendAddonMessage("RezTrack", fEvent, "WHISPER",pName)
	else
		self:Print("RezTrack unknown slash command.");
		self:Print("RezTrack supported slash commands :");
		self:Print("lock")
		self:Print("unlock")
		self:Print("hide")
		self:Print("show")
		self:Print("resize true | false")
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
				for i = 1, 40 do
					self["pMember" .. i]:SetWidth(self:GetWidth())
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
	--self:Print("scored updated building ui")
	local safety = GetNumBattlefieldScores()
	if safety == 0 then
		self:Print("returning cus score is 0")
		return
	end
	local delta = GetTime() - scoreUpdateBuffer
	if delta < 10 then
		return
	end
	self:UpdateUI()
end

function RezTrack:BuildContainerAndDefaults()
	self.container = CreateFrame("Frame","RezTrackContainer",UIParent)
	self.container:SetFrameStrata("HIGH")
	self.container:SetWidth(128)
	self.container:RegisterForDrag("LeftButton")
	
	local t = self.container:CreateTexture(nil,"BACKGROUND")
	t:SetTexture(0,0,0,1)
	t:SetAllPoints(self.container)
	self.container.texture = t
	
	for i = 1, 40 do
		self.container["pMember" .. i] = CreateFrame("Frame",nil,self.container)
		self.container:SetFrameStrata("BACKGROUND")
		self.container["pMember" .. i]:SetWidth(128)
		self.container["pMember" .. i]:SetHeight(20)
		self.container["pMember" .. i]:SetResizable(true)
		if i==1 then
			self.container["pMember" .. i].pName = "Out"
			self.container["pMember" .. i].pRealm = "Velen"
		else
			self.container["pMember" .. i].pName = ""
			self.container["pMember" .. i].pRealm = ""
		end
		self.container["pMember" .. i].rezTime = 0
		self.container["pMember" .. i].rezTimer = {}
		
		local tb = self.container["pMember" .. i]:CreateTexture(nil, "BORDER")
		tb:SetTexture(0, .5, 0, 1)
		tb:SetPoint("TOPLEFT", self.container["pMember" .. i], 1, -1)
		tb:SetPoint("BOTTOMRIGHT", self.container["pMember" .. i],-1, 1)
		self.container["pMember" .. i].mainFill = tb
		
		local t = self.container["pMember" .. i]:CreateTexture(nil,"BACKGROUND")
		t:SetTexture(0,0,0,1)
		t:SetAllPoints(self.container["pMember" .. i])
		
		local fs_status = self.container["pMember" .. i]:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		fs_status:SetHeight(12)
		fs_status:SetPoint("RIGHT", self.container["pMember" .. i], 0,0)
		fs_status:SetJustifyH("RIGHT")
		fs_status:SetText("Alive")
		fs_status:SetTextColor(1, 1, 1, 1)
		self.container["pMember" .. i].statusText = fs_status
		
		local fs_name = self.container["pMember" .. i]:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		fs_name:SetHeight(12)
		fs_name:SetPoint("Left", self.container["pMember" .. i], 0,0)
		fs_name:SetJustifyH("Left")
		fs_name:SetText("Name")
		fs_name:SetTextColor(1, 1, 1, 1)
		self.container["pMember" .. i].nameText = fs_name
		
		self.container["pMember" .. i]:SetPoint("TOPLEFT",self.container,0,-(20*(i-1)))
		self.container["pMember" .. i]:Show()
	end
	self.container:SetHeight(800)
	if RezTrack_Settings.POSITION then
		--self.container:self.container:SetPoint("CENTER",0,0)("CENTER",0,0)
	else
		self.container:SetPoint("CENTER",0,0)
	end
	self.container:Show()
end

function RezTrack:UpdateUI()

	if self.container == nil then
		self:BuildContainerAndDefaults()
	end
	
	self.container:Hide()
	self.totalMembers = 0
	
	for i = 1, GetNumBattlefieldScores() do 
		local name, killingBlows, honorKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone = GetBattlefieldScore(i)
		--self:Print("faction " .. faction)
		--self:Print("englishFaction " .. self.englishFaction)
		--self:Print("name " .. name)
		if faction == self.factionInt then
			self.totalMembers = self.totalMembers + 1
			local targetFrame = select(self.totalMembers,self.container:GetChildren())
			local pName,pRealm = strsplit("-",name)
			targetFrame.nameText:SetText(pName)
			targetFrame.pName = pName
			targetFrame.pRealm = pRealm
			targetFrame.rezTime = 0
			targetFrame.rezTimer = {}
			targetFrame:Show()
			--self:Print("step 6")
		end
	end
	
	for i = self.totalMembers+1, 40 do 
		local targetFrame = select(i,self.container:GetChildren())
		targetFrame:Hide()
	end
	
	self.container:SetHeight(self.totalMembers * 20)	
	self.container:SetPoint("CENTER",0,0)
	self.container:Show()
end

function RezTrack:PlayerHasDied(event,...)
	self:Print("RezTrack ",event)
	RepopMe()
	self.timeLeft = GetCorpseRecoveryDelay()
	self.healerTime =  GetAreaSpiritHealerTime()
	self:Print("DIED GetCorpseRecoveryDelay " .. self.timeLeft)
 	self:Print("DIED GetAreaSpiritHealerTime " .. self.healerTime)
	if self.timeLeft <= 0 then
		self:Print("returning");
		return
	end
	local pName,pRealm = UnitName("player")
	if pRealm == nil then
		pRealm = GetRealmName()
	end
	local fEvent= (pName .. "-" .. pRealm .. "-" .. self.timeLeft)
  	SendAddonMessage("RezTrack", fEvent, "WHISPER")
end

function RezTrack:HandleAddonNotfied(event,prefix,message,channel,player)
	if prefix == "RezTrack" then
		local pName,pRealm,time = strsplit("-",message)
		RezTrack:Print("in the check " ..  pName .. " " .. pRealm)
		for i=1,40 do
			local targetFrame = select(i,self.container:GetChildren())
			RezTrack:Print("targetFrame.pName " .. targetFrame.pName)
			RezTrack:Print("targetFrame.pRealm " .. targetFrame.pRealm)
			if targetFrame.pName == pName and targetFrame.pRealm == pRealm then
				RezTrack:Print("found the matching frame")
				targetFrame.rezTime = time
				targetFrame.rezTimer = self:ScheduleRepeatingTimer("UpdateTargetRezTime", 1,targetFrame)
				break
			end
		end
	end
end

function RezTrack:UpdateTargetRezTime(targetFrame)
	targetFrame.rezTime = targetFrame.rezTime - 1
	if targetFrame.rezTime == 0 then	
    	self:CancelTimer(targetFrame.rezTimer)
    	targetFrame.mainFill:SetTexture(0, .5, 0, 1)
    	targetFrame.statusText:SetText("Alive")
    else
    	targetFrame.statusText:SetText("Rez in : " .. targetFrame.rezTime)
    	targetFrame.mainFill:SetTexture(1, 1, 0, 1)
    end
end