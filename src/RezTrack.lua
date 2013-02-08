local RezTrack = LibStub("AceAddon-3.0"):NewAddon("RezTrack", "AceConsole-3.0","AceEvent-3.0","AceTimer-3.0")
-- Constants
local REZTRACK_ALLIANCE_En = "Alliance"
local REZTRACK_PREFIX = "RezTrack"
local REZTRACK_DEFAULT_STATUS_En = "Alive"
local REZTRACK_REZ_PROGRESS_En = "Rez in "
local REZTRACK_REZ_ABLE_En = "Ready For Rez"
local REZTRACK_DEFAULT_WIDTH = 128
local REZTRACK_DEFAULT_HEIGHT = 800
local REZTRACK_DEFAULT_POSITION = 100
local REZTRACK_MAX_FRAMES = 40
local REZTRACK_DEFAULT_UNIT_HEIGHT = 20
local REZTRACK_MIN_WIDTH = 80
local ADDON_MSG_CHANNEL = "WHISPER"
--local ADDON_MSG_CHANNEL = "BATTLEGROUP"
-- Declared
local scoreUpdateBuffer,factionInt,totalMembers,scoreUpdateThreshold
local cachedTimers,maxHeight,members
-- Stubs
TEN_PERSON_BG = {
	[1] = {	["name"]="Goober-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[2] = {	["name"]="Stupid-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[3] = {	["name"]="Hello-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[4] = {	["name"]="Monkey-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[5] = {	["name"]="SSSSSSSSSSS-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[6] = {	["name"]="Manchild-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[7] = {	["name"]="Silly-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[8] = {	["name"]="KickerTWashington-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[9] = {	["name"]="Bluezyu-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[10] = {["name"]="Farkins-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""}
}
FIFTEEN_PERSON_BG = {
	[1] = {	["name"]="Goober-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[2] = {	["name"]="Stupid-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[3] = {	["name"]="Hello-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[4] = {	["name"]="Monkey-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[5] = {	["name"]="SSSSSSSSSSS-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[6] = {	["name"]="Manchild-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[7] = {	["name"]="Silly-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[8] = {	["name"]="KickerTWashington-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[9] = {	["name"]="Bluezyu-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[10] = {["name"]="Farkins-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[11] = { ["name"]="Moggle-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[12] = { ["name"]="BloodersRampins-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[13] = { ["name"]="Simpsimmons-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[14] = { ["name"]="Taskings-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""},
	[15] = { ["name"]="Rubbalulz-Velen",["killingBlows"]=10,["honorKills"]=10,["deaths"]=10,["honorGained"]=10,["faction"]=1,["rank"]=1,
			["race"]="Human",["class"]="Death Knight",["filename"]="",["damageDone"]="",["healingDone"]=""}
}
-- end Stubs
function RezTrack:OnInitialize()
	scoreUpdateThreshold = .5
	totalMembers = 0
	cachedTimers = {}
	members = {}
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
	self:RegisterEvent("PLAYER_ALIVE","PlayerHasRessurected")
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
	elseif cmds == "sorta" then
		self:SortAlphabetically(FIFTEEN_PERSON_BG)
	elseif cmds == "killEveryone" then
		local fEvent= ("Neato-Velen-" .. 60)
  		SendAddonMessage(REZTRACK_PREFIX,fEvent,ADDON_MSG_CHANNEL,"Neato")
  	elseif cmds == "checkCache" then
		self:CheckForCachedTimer(select(1,self.container:GetChildren()))
	elseif cmds == "msg" then
		local pName,pRealm = UnitName("player")
		if pRealm == nil then
			pRealm = GetRealmName()
		end
		local fEvent= (pName .. "-" .. pRealm .. "-" .. 30)
		SendAddonMessage(REZTRACK_PREFIX,fEvent,ADDON_MSG_CHANNEL,pName)
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
				if self:GetHeight() >= maxHeight then
					self:SetHeight(maxHeight)
				end
				if self:GetWidth() <= REZTRACK_MIN_WIDTH then
					self:SetWidth(REZTRACK_MIN_WIDTH)
				end				
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
		self.container["pMember" .. i]:SetHeight(REZTRACK_DEFAULT_UNIT_HEIGHT)
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
		self.container["pMember" .. i]:SetPoint("TOPLEFT",self.container,0,-(REZTRACK_DEFAULT_UNIT_HEIGHT*(i-1)))
		self.container["pMember" .. i]:Show()
	end
	-- Position size, and show
	self.container:SetHeight(REZTRACK_DEFAULT_HEIGHT)
	self:PositionAndShow()
end

function RezTrack:PositionAndShow()
	if RezTrack_Settings.POSITION.x then
		self.container:ClearAllPoints()
		self.container:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",RezTrack_Settings.POSITION.x,RezTrack_Settings.POSITION.y)
	else
		self.container:SetPoint("CENTER",0,0)
	end
	self.container:Show()
end

function RezTrack:HandleZoneChange(event,...)
	self:Print("RezTrack HandleZoneChange " .. event)
	local zoneType = select(2,IsInInstance())
	if (zoneType == "pvp") then
		self:Print("RezTrack found battleground. buiding ui...")
		scoreUpdateBuffer = GetTime()
		self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE","HandleScoreUpdate")
		RequestBattlefieldScoreData()
	else
		self:Print("RezTrack not in battleground")
		if self.container then
			self.container:Hide()
		end
		self:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")
	end
end

function RezTrack:HandleScoreUpdate()
	-- Since we have party members lets build the ui , but we dont need to do this 
	-- everytime the score is updated.
	local delta = GetTime() - scoreUpdateBuffer
	if delta < scoreUpdateThreshold then
		RequestBattlefieldScoreData()
		return
	end
	self:Print("RezTrack HandleScoreUpdate updatBuffer met " .. delta)
	local members = GetNumBattlefieldScores()
	-- Check to see if we have any battleground party members first.
	if members == 0 then
		self:Print("RezTrack returning because there are no memebers")
		RequestBattlefieldScoreData()
		return
	end
	self:UpdateUI()
end

function RezTrack:UpdateUI(optionalStub)
	-- Check to see if the defaults have been built, if not build them once.
	if self.container == nil then
		self:Print("RezTrack building default ui")
		self:BuildContainerAndDefaults()
	end	
	--Cancel all timers before an update
	self:CancelAndCacheAllTimers()
	-- Hide the defaults prior to updating.
	self.container:Hide()
	totalMembers = 0
	-- Update the existing frames with actual party member data.
	local nMembers
	-- Check to see if we have stub data
	if optionalStub == nil then
		nMembers = GetNumBattlefieldScores()
		self:Print("RezTrack number of members in bg " .. nMembers)
	else
		nMembers = #(optionalStub)
		self:Print("nMembers " .. nMembers)
	end
	local collection = {}
	for i = 1, nMembers do 

	end
	--
	for i = 1, nMembers do 
		local name, _, _, _, _, faction, _, _, _, _, _, _
		if optionalStub == nil then
			name, _, _, _, _, faction, _, _, _, _, _, _ = GetBattlefieldScore(i)
		else
			name = optionalStub[i].name
			faction = optionalStub[i].faction
		end
		--
		if faction == factionInt then
			totalMembers = totalMembers + 1
			local targetFrame = select(totalMembers,self.container:GetChildren())
			local pName,pRealm = strsplit("-",name)
			if pRealm == nil then
				self:Print("getting realm explicitly")
				pRealm = GetRealmName()
				self:Print("pRealm " .. pRealm)
			end
			targetFrame.nameText:SetText(pName)
			targetFrame.pName = pName
			targetFrame.pRealm = pRealm
			targetFrame.rezTime = self:CheckForCachedTimer(targetFrame)
			if targetFrame.rezTime == nil then
				targetFrame.rezTime = 0
				targetFrame.rezTimer = {}
			else
				targetFrame.rezTimer = RezTrack:ScheduleRepeatingTimer("UpdateTargetRezTime", 1,targetFrame)
			end
			targetFrame:Show()
		end
	end
	self:Print("RezTrack updated frames totalMembers was " .. totalMembers)
	-- Hide the remaining frames we don't need.
	for i = totalMembers+1, REZTRACK_MAX_FRAMES do 
		local targetFrame = select(i,self.container:GetChildren())
		targetFrame.rezTime = 0
		targetFrame.rezTimer = {}
		targetFrame:Hide()
	end
	-- Position size, and show
	maxHeight = totalMembers * REZTRACK_DEFAULT_UNIT_HEIGHT
	self.container:SetHeight(maxHeight)
	self:PositionAndShow()
	-- Clear the timer cache
	cachedTimers = {}
end

function RezTrack:PlayerHasDied(event,...)
	self:Print("RezTrack ",event)
	-- Send Player to the graveyard
	-- RepopMe()
	-- Get the approximate ressurection times
	local timeLeft = GetCorpseRecoveryDelay()
	local healerTime =  GetAreaSpiritHealerTime()
	self:Print("RezTrack player death : GetCorpseRecoveryDelay " .. timeLeft)
 	self:Print("RezTrack player death : GetAreaSpiritHealerTime " .. healerTime)
 	local pName,pRealm = UnitName("player")
	if pRealm == nil then
		self:Print("RezTrack PlayerHasDied getting realm explicitly")
		pRealm = GetRealmName()
		self:Print("RezTrack PlayerHasDied pRealm " .. pRealm)
	end
 -- 	-- If the rez time is 0 update the UI and wait for UnGhost
	-- if timeLeft <= 0 then
	-- 	for i = 1, REZTRACK_MAX_FRAMES do 
	-- 		local targetFrame = select(i,self.container:GetChildren())
	-- 		if targetFrame.pName == pName and targetFrame.pRealm == pRealm then
	-- 			self:Print("rez time is 0 so ")
	-- 			targetFrame.rezTime = 0
	-- 			self:UpdateTargetRezTime(targetFrame)
	-- 		end
	-- 	end
	-- end
	--
	-- Send a message to the battlegroup that the player has died along with info
	local fEvent= (pName .. "-" .. pRealm .. "-" .. timeLeft)
	-- TODO: Channel should be BATTLEGROUP not WHISPER
  	SendAddonMessage(REZTRACK_PREFIX,fEvent,ADDON_MSG_CHANNEL,pName)
end

function RezTrack:PlayerHasRessurected(event,...)
	local pName,pRealm = UnitName("player")
	if pRealm == nil then
		pRealm = GetRealmName()
	end
	self:Print("player has ressurected " .. pName)
	-- Send a message to the battlegroup that the player has died along with info
	local fEvent= (pName .. "-" .. pRealm .. "-" .. REZTRACK_REZ_ABLE_En)
	-- TODO: Channel should be BATTLEGROUP not WHISPER
  	SendAddonMessage(REZTRACK_PREFIX, fEvent,ADDON_MSG_CHANNEL,pName)
end

function RezTrack:HandleAddonNotfied(event,prefix,message,channel,player)
	if prefix == REZTRACK_PREFIX then
		local pName,pRealm,time = strsplit("-",message)
		RezTrack:Print("RezTrack HandleAddonNotfied for " ..  pName .. " " .. pRealm)
		for i=1,REZTRACK_MAX_FRAMES do
			local targetFrame = select(i,RezTrack.container:GetChildren())
			if pName == 'Neato' then
				self:Print("targetFrame.pName " .. targetFrame.pName)
				self:Print("targetFrame.pRealm " .. targetFrame.pRealm)
				self:Print("pName " .. pName)
				self:Print("pRealm " .. pRealm)
				self:Print((pName == targetFrame.pName))
				self:Print(((pName .. " ") == targetFrame.pName))
				self:Print((pName == (targetFrame.pName .. " ")))
			end
			if targetFrame.pName == pName and targetFrame.pRealm == pRealm then
				RezTrack:Print("init")
				if time == REZTRACK_REZ_ABLE_En then
					RezTrack:Print("init time " .. time)
					RezTrack:RestoreTargetAlive(targetFrame)
				else
					RezTrack:Print("init starting timer " .. time)
					targetFrame.rezTime = time
					targetFrame.rezTimer = RezTrack:ScheduleRepeatingTimer("UpdateTargetRezTime", 1,targetFrame)
				end
				break
			end
		end
	end
end

function RezTrack:CancelAndCacheAllTimers()
	for i = 1, REZTRACK_MAX_FRAMES do 
		local targetFrame = select(i,self.container:GetChildren())
		if targetFrame.rezTime > 0 then
			cachedTimers[targetFrame.pName .. "-" .. targetFrame.pRealm] = targetFrame.rezTime
			self:CancelTimer(targetFrame.rezTimer)
		end
	end
end

function RezTrack:CheckForCachedTimer(targetFrame)
	for k,v in pairs(cachedTimers) do
    	local pName,pRealm = strsplit("-",k)
    	if targetFrame.pName == pName and targetFrame.pRealm == pRealm then
    		self:Print("found a cached timer for " .. pName)
    		self:Print("taht value is " .. cachedTimers[k])
    		return cachedTimers[k]
    	end
	end
end

function RezTrack:RestoreTargetAlive(targetFrame)
	self:Print("restoring target")
	targetFrame.mainFill:SetTexture(0, 1, 0, 1)
    targetFrame.statusText:SetText(REZTRACK_DEFAULT_STATUS_En)
end

function RezTrack:UpdateTargetRezTime(targetFrame)
	targetFrame.rezTime = targetFrame.rezTime - 1
	if targetFrame.rezTime == 0 then	
		self:Print("UpdateTargetRezTime cus 0")
    	self:CancelTimer(targetFrame.rezTimer)
    	targetFrame.mainFill:SetTexture(0, .5, 0, 1)
    	targetFrame.statusText:SetText(REZTRACK_REZ_ABLE_En)
    else
    	targetFrame.mainFill:SetTexture(.5, 0, 0, 1)
    	targetFrame.statusText:SetText(REZTRACK_REZ_PROGRESS_En .. "" .. targetFrame.rezTime)
    end
end

function RezTrack:SortAlphabetically(collection)
	t={}
	f={}
	for k,v in pairs(collection) do 
		table.insert(t,v)
	end
	table.sort(t,function(a,b)
		return a.name < b.name
	end)
	for i=1, #(t) do
		f[i] = t
	end
	return f
end