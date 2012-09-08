local RezTrack = LibStub("AceAddon-3.0"):NewAddon("RezTrack", "AceConsole-3.0","AceEvent-3.0","AceTimer-3.0")
-- Constants
local REZTRACK_ALLIANCE_En = "Alliance"
local REZTRACK_PREFIX = "RezTrack"
local REZTRACK_DEFAULT_STATUS_En = "Alive"
local REZTRACK_REZ_ABLE_En = "Ready For Rez"
local REZTRACK_DEFAULT_WIDTH = 128
local REZTRACK_DEFAULT_HEIGHT = 800
local REZTRACK_DEFAULT_POSITION = 100
local REZTRACK_MAX_FRAMES = 40
-- Declared
local db
local scoreUpdateBuffer,factionInt,totalMembers,scoreUpdateThreshold
-- Stubs
TEN_PERSON_BG = {
	[1] = {	["name"]="Player1-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[2] = {	["name"]="Player2-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[3] = {	["name"]="Player3-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[4] = {	["name"]="Player4-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[5] = {	["name"]="Player5-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[6] = {	["name"]="Player6-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[7] = {	["name"]="Player7-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[8] = {	["name"]="Player8-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[9] = {	["name"]="Player9-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[10] = {	["name"]="Player10-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""}
}
FIFTEEN_PERSON_BG = {
	[1] = {	["name"]="Player1 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[2] = {	["name"]="Player2 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[3] = {	["name"]="Player3 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[4] = {	["name"]="Player4 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[5] = {	["name"]="Player5 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[6] = {	["name"]="Player6 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[7] = {	["name"]="Player7 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[8] = {	["name"]="Player8 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[9] = {	["name"]="Player9 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[10] = {	["name"]="Player10 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[11] = { ["name"]="Player11 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[12] = { ["name"]="Player12 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[13] = { ["name"]="Player13 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[14] = { ["name"]="Player14 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[15] = { ["name"]="Player15 - Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""}
}
-- end Stubs
function RezTrack:OnInitialize()
	scoreUpdateThreshold = 10
	totalMembers = 0
	-- Assign session defaults if none exist
	if RezTrack_Settings == nil then
		RezTrack_Settings = {}
		RezTrack_Settings["POSITION"] = {}
		RezTrack_Settings["DIMENSIONS"] = {}
	end
end

function RezTrack:OnEnable()
	self:Print("RezTrack Loaded");	
	-- Register Events
	self:RegisterEvent("PLAYER_DEAD","PlayerHasDied")
	self:RegisterEvent("PLAYER_UNGHOST","PlayerHasRessurected")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA","HandleZoneChange")
	self:RegisterEvent("PLAYER_ENTERING_WORLD","HandleZoneChange")
	self:RegisterEvent("CHAT_MSG_ADDON","HandleAddonNotfied")
	-- Register Slash Command Listener
	self:RegisterChatCommand("rt","HandleSlashCommands")
	-- Register Addon Message Listener
	RegisterAddonMessagePrefix(REZTRACK_PREFIX)
	--
	self:storeFactionAsInteger()
end

function RezTrack:storeFactionAsInteger()
	local englishFaction,localizedFaction = UnitFactionGroup("player")
	if englishFaction == REZTRACK_ALLIANCE_En then
		factionInt = 1
	else
		factionInt = 0
	end
end

function RezTrack:OnDisable()
	self:UnregisterEvent("PLAYER_DEAD")
	self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("CHAT_MSG_ADDON")
	self:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")
end

function RezTrack:HandleSlashCommands(cmds)
	if cmds == "lock" then
		self:ToggleLock(true)
	elseif cmds == "unlock" then
		self:ToggleResize(false)
		self:ToggleLock(false)
	elseif cmds == "hide" then
		self.container:Hide()
	elseif cmds == "show" then
		self.container:Show()
	elseif cmds == "resize false" then
		self:ToggleResize(false)
	elseif cmds == "resize true" then
		self:ToggleLock(true)
		self:ToggleResize(true)
	elseif cmds == "scores" then
		self:Print(GetNumBattlefieldScores())
	elseif cmds == "buildDefaultUI" then
		self:BuildContainerAndDefaults()
	elseif cmds == "update10man" then
		self:UpdateUI(TEN_PERSON_BG)
	elseif cmds == "update15man" then
		self:UpdateUI(FIFTEEN_PERSON_BG)
	elseif cmds == "killEveryone" then
		local fEvent= ("Player1-Velen-" .. 60)
  		SendAddonMessage(REZTRACK_PREFIX, fEvent, "WHISPER","Neato")
	elseif cmds == "msg" then
		local pName,pRealm = UnitName("player")
		if pRealm == nil then
			pRealm = GetRealmName()
		end
		local fEvent= (pName .. "-" .. pRealm .. "-" .. 30)
		SendAddonMessage(REZTRACK_PREFIX,fEvent,"WHISPER",pName)
	else
		self:Print("RezTrack supported slash commands :")
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
		self.container:SetScript("OnDragStop", function(self,event,...)
			RezTrack_Settings.POSITION["x"] = self:GetLeft()
			RezTrack_Settings.POSITION["y"] = self:GetTop()
			self:StopMovingOrSizing()
		end)
		self.container:SetMovable(true)
		self.container:EnableMouse(true)
	end	
end

function RezTrack:ToggleResize(val)
	if val == true then	
		self.container:SetScript("OnDragStart", function(self,event,...)
			self:SetScript("OnUpdate", function(self,event,...)
				for i = 1, REZTRACK_MAX_FRAMES do
					self["pMember" .. i]:SetWidth(self:GetWidth())
				end
			end)
			self:StartSizing()
		end)		
		self.container:SetScript("OnDragStop",function(self,event,...)
			RezTrack_Settings.DIMENSIONS["width"] = self:GetWidth()
			RezTrack:Print("RezTrack_Settings.DIMENSIONS " .. RezTrack_Settings.DIMENSIONS.width)
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
	else
		self:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")
	end
end

function RezTrack:HandleScoreUpdate()
	local members = GetNumBattlefieldScores()
	-- Check to see if we have any battleground party members first.
	if members == 0 then
		self:Print("RezTrack returning because there are no memebers")
		return
	end
	-- Since we have party members lets build the ui , but we dont need to do this everytime the score is updated.
	local delta = GetTime() - scoreUpdateBuffer
	if delta < scoreUpdateThreshold then
		return
	end
	self:UpdateUI()
end

function RezTrack:BuildContainerAndDefaults()
	-- Build the main addon frame
	self.container = CreateFrame("Frame","RezTrackContainer",UIParent)
	self.container:SetFrameStrata("HIGH")
	-- Check for user defined width
	local targetWidth
	if RezTrack_Settings.DIMENSIONS.width then
		self:Print("width found " .. RezTrack_Settings.DIMENSIONS.width)
		targetWidth = RezTrack_Settings.DIMENSIONS.width
	else
		self:Print("no width found " .. REZTRACK_DEFAULT_WIDTH)
		targetWidth = REZTRACK_DEFAULT_WIDTH
	end
	self.container:SetWidth(targetWidth)
	self.container:RegisterForDrag("LeftButton")
	-- Build the main addon frame's texture
	local t = self.container:CreateTexture(nil,"BACKGROUND")
	t:SetTexture(0,0,0,1)
	t:SetAllPoints(self.container)
	self.container.texture = t
	-- Build the member frames
	for i = 1, REZTRACK_MAX_FRAMES do
		self.container["pMember" .. i] = CreateFrame("Frame",nil,self.container)
		self.container:SetFrameStrata("BACKGROUND")
		self.container["pMember" .. i]:SetWidth(targetWidth)
		self.container["pMember" .. i]:SetHeight(20)
		self.container["pMember" .. i]:SetResizable(true)
		self.container["pMember" .. i].pName = ""
		self.container["pMember" .. i].pRealm = ""
		self.container["pMember" .. i].rezTime = 0
		self.container["pMember" .. i].rezTimer = {}
		-- Build the member frames background
		local tb = self.container["pMember" .. i]:CreateTexture(nil, "BORDER")
		tb:SetTexture(0, 1, 0, 1)
		tb:SetPoint("TOPLEFT", self.container["pMember" .. i], 1, -1)
		tb:SetPoint("BOTTOMRIGHT", self.container["pMember" .. i],-1, 1)
		self.container["pMember" .. i].mainFill = tb
		-- Build the member frames border
		local t = self.container["pMember" .. i]:CreateTexture(nil,"BACKGROUND")
		t:SetTexture(0,0,0,1)
		t:SetAllPoints(self.container["pMember" .. i])
		-- Add status text
		local fs_status = self.container["pMember" .. i]:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		fs_status:SetHeight(12)
		fs_status:SetPoint("RIGHT", self.container["pMember" .. i], 0,0)
		fs_status:SetJustifyH("RIGHT")
		fs_status:SetText("Alive")
		fs_status:SetTextColor(1, 1, 1, 1)
		self.container["pMember" .. i].statusText = fs_status
		-- Add time text
		local fs_name = self.container["pMember" .. i]:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		fs_name:SetHeight(12)
		fs_name:SetPoint("Left", self.container["pMember" .. i], 0,0)
		fs_name:SetJustifyH("Left")
		fs_name:SetText("Name")
		fs_name:SetTextColor(1, 1, 1, 1)
		self.container["pMember" .. i].nameText = fs_name
		-- Position the member frame
		self.container["pMember" .. i]:SetPoint("TOPLEFT",self.container,0,-(20*(i-1)))
		self.container["pMember" .. i]:Show()
	end
	-- Position size, and show
	self.container:SetHeight(REZTRACK_DEFAULT_HEIGHT)
	self:PositionAndShow()
end

function RezTrack:PositionAndShow()
	--TODO : This is not fully implemented.
	if RezTrack_Settings.POSITION.x then
		self:Print("first if")
		self.container:ClearAllPoints()
		self.container:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",RezTrack_Settings.POSITION.x,RezTrack_Settings.POSITION.y)
	else
		self.container:SetPoint("CENTER",0,0)
	end
	self:Print("position and show")
	self.container:Show()
end

function RezTrack:UpdateUI(optionalStub)
	-- Check to see if the defaults have been built, if not build them once.
	if self.container == nil then
		self:Print("building default ui")
		self:BuildContainerAndDefaults()
	end	
	-- Hide the defaults prior to updating.
	self.container:Hide()
	totalMembers = 0
	-- Update the existing frames with actual party member data.
	local nMembers
	-- Check to see if we have stub data
	if optionalStub == nil then
		nMembers = GetNumBattlefieldScores()
	else
		nMembers = #(optionalStub)
		self:Print("nMembers " .. nMembers)
	end
	--
	for i = 1, nMembers do 
		local name, killingBlows, honorKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone
		if optionalStub == nil then
			name, killingBlows, honorKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone = GetBattlefieldScore(i)
		else
			nMembersData = optionalStub[i]
			name = optionalStub[i].name
			killingBlows = optionalStub[i].killingBlows
			honorKills = optionalStub[i].honorKills
			deaths = optionalStub[i].deaths
			honorGained = optionalStub[i].honorGained
			faction = optionalStub[i].faction
			rank = optionalStub[i].rank
			race = optionalStub[i].race
			class = optionalStub[i].class
			filename = optionalStub[i].filename
			damageDone = optionalStub[i].damageDone
			healingDone = optionalStub[i].healingDone
		end
		--
		if faction == factionInt then
			totalMembers = totalMembers + 1
			local targetFrame = select(totalMembers,self.container:GetChildren())
			local pName,pRealm = strsplit("-",name)
			targetFrame.nameText:SetText(pName)
			targetFrame.pName = pName
			targetFrame.pRealm = pRealm
			targetFrame.rezTime = 0
			targetFrame.rezTimer = {}
			targetFrame:Show()
		end
	end
	-- Hide the remaining frames we don't need.
	for i = totalMembers+1, REZTRACK_MAX_FRAMES do 
		local targetFrame = select(i,self.container:GetChildren())
		targetFrame:Hide()
	end
	-- Position size, and show
	self.container:SetHeight(totalMembers * 20)	
	self:PositionAndShow()
end

function RezTrack:PlayerHasDied(event,...)
	self:Print("RezTrack ",event)
	-- Send Player to the graveyard
	RepopMe()
	-- Get the approximate ressurection times
	local timeLeft = GetCorpseRecoveryDelay()
	local healerTime =  GetAreaSpiritHealerTime()
	self:Print("RezTrack player death : GetCorpseRecoveryDelay " .. self.timeLeft)
 	self:Print("RezTrack player death : GetAreaSpiritHealerTime " .. self.healerTime)
 	-- If the rez time is 0 return
	if timeLeft <= 0 then
		self:Print("returning")
		return
	end
	--
	local pName,pRealm = UnitName("player")
	if pRealm == nil then
		pRealm = GetRealmName()
	end
	-- Send a message to the battlegroup that the player has died along with info
	local fEvent= (pName .. "-" .. pRealm .. "-" .. timeLeft)
	-- TODO: Channel should be BATTLEGROUP not WHISPER
  	SendAddonMessage(REZTRACK_PREFIX, fEvent, "WHISPER",pName)
end

function RezTrack:PlayerHasRessurected(event,...)
	local pName,pRealm = UnitName("player")
	if pRealm == nil then
		pRealm = GetRealmName()
	end
	-- Send a message to the battlegroup that the player has died along with info
	local fEvent= (pName .. "-" .. pRealm .. "-" .. REZTRACK_REZ_ABLE_En)
	-- TODO: Channel should be BATTLEGROUP not WHISPER
  	SendAddonMessage(REZTRACK_PREFIX, fEvent, "WHISPER",pName)
end

function RezTrack:HandleAddonNotfied(event,prefix,message,channel,player)
	if prefix == REZTRACK_PREFIX then
		local pName,pRealm,time = strsplit("-",message)
		RezTrack:Print("RezTrack HandleAddonNotfied for " ..  pName .. " " .. pRealm)
		for i=1,REZTRACK_MAX_FRAMES do
			local targetFrame = select(i,self.container:GetChildren())
			RezTrack:Print("RezTrack targetFrame.pName " .. targetFrame.pName)
			RezTrack:Print("RezTrack pName " .. pName)
			RezTrack:Print("RezTrack targetFrame.pRealm " .. targetFrame.pRealm)
			RezTrack:Print("RezTrack pRealm " .. pRealm)
			if targetFrame.pName == pName and targetFrame.pRealm == pRealm then
				RezTrack:Print("init")
				if time == REZTRACK_REZ_ABLE_En then
					self:RestoreTargetAlive(targetFrame)
				else
					targetFrame.rezTime = time
					targetFrame.rezTimer = self:ScheduleRepeatingTimer("UpdateTargetRezTime", 1,targetFrame)
				end
				break
			end
		end
	end
end

function RezTrack:RestoreTargetAlive(targetFrame)
	targetFrame.mainFill:SetTexture(0, 1, 0, 1)
    targetFrame.statusText:SetText(REZTRACK_DEFAULT_STATUS_En)
end

function RezTrack:UpdateTargetRezTime(targetFrame)
	targetFrame.rezTime = targetFrame.rezTime - 1
	if targetFrame.rezTime == 0 then	
    	self:CancelTimer(targetFrame.rezTimer)
    	targetFrame.mainFill:SetTexture(0, .5, 0, 1)
    	targetFrame.statusText:SetText(REZTRACK_REZ_ABLE_En)
    else
    	targetFrame.statusText:SetText("Rez in : " .. targetFrame.rezTime)
    	targetFrame.mainFill:SetTexture(.5, 0, 0, 1)
    end
end