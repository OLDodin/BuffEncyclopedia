
local m_reactions={}
local m_configForm = nil
local m_template = nil

local m_searchAllTree = nil
local m_currAllList = {}
local m_subscribedUnits = {}

local m_secondsCnt = 0
local m_wasSomeChangesToSave = false
local m_currAllListContainDuplicate = false

Global("g_classMaskShift", {
	["WARRIOR"]		= 0,  --0000 0000 0001 b
	["PALADIN"]		= 1,  --0000 0000 0010 b
	["MAGE"]		= 2,  --0000 0000 0100 b
	["DRUID"]		= 3,  --0000 0000 1000 b
	["PSIONIC"]		= 4,  --0000 0001 0000 b
	["STALKER"]		= 5,  --0000 0010 0000 b
	["PRIEST"]		= 6,  --0000 0100 0000 b
	["NECROMANCER"]	= 7,  --0000 1000 0000 b
	["ENGINEER"]    = 8,  --0001 0000 0000 b
	["BARD"]		= 9,  --0010 0000 0000 b
	["WARLOCK"] 	= 10, --0100 0000 0000 b
	["UNKNOWN"]		= 11  --1000 0000 0000 b
})
function GetClassMask(aClassName)
	return bit.lshift(1, g_classMaskShift[aClassName])
end

function IsPackedValueHasClass(aBitPackedValue, aClassName)
	return bit.rshift(bit.band(aBitPackedValue, GetClassMask(aClassName)), g_classMaskShift[aClassName]) == 1
end

function AddClassToPackedValue(aBitPackedValue, aClassName)
	return bit.bor(aBitPackedValue, GetClassMask(aClassName))
end

function BuildClassMask(aWARRIOR, aPALADIN, aMAGE, aDRUID, aPSIONIC, aSTALKER, aPRIEST, aNECROMANCER, aENGINEER, aBARD, aWARLOCK, aUNKNOWN)
	local classMask = 0
	if aWARRIOR then
		classMask = AddClassToPackedValue(classMask, "WARRIOR")
	end
	if aPALADIN then
		classMask = AddClassToPackedValue(classMask, "PALADIN")
	end
	if aMAGE then
		classMask = AddClassToPackedValue(classMask, "MAGE")
	end
	if aDRUID then
		classMask = AddClassToPackedValue(classMask, "DRUID")
	end
	if aPSIONIC then
		classMask = AddClassToPackedValue(classMask, "PSIONIC")
	end
	if aSTALKER then
		classMask = AddClassToPackedValue(classMask, "STALKER")
	end
	if aPRIEST then
		classMask = AddClassToPackedValue(classMask, "PRIEST")
	end
	if aNECROMANCER then
		classMask = AddClassToPackedValue(classMask, "NECROMANCER")
	end
	if aENGINEER then
		classMask = AddClassToPackedValue(classMask, "ENGINEER")
	end
	if aBARD then
		classMask = AddClassToPackedValue(classMask, "BARD")
	end
	if aWARLOCK then
		classMask = AddClassToPackedValue(classMask, "WARLOCK")
	end
	if aUNKNOWN then
		classMask = AddClassToPackedValue(classMask, "UNKNOWN")
	end
	return classMask
end
	
function ChangeMainWndVisible()
	if isVisible(m_configForm) then
		WndMgr.HideWdg(m_configForm)
	else
		UpdatePressed()
		ChangedFilter()
		WndMgr.ShowWdg(m_configForm)
	end
	
	collectgarbage()
end

local function GetTimestamp()
	return common.GetMsFromDateTime( common.GetLocalDateTime() )
end

function SetProducerClass(anObjID, aPackedValue)
	local producerClasses
	if isExist(anObjID) and unit.IsPlayer(anObjID) then
		local playerClass = unit.GetClass(anObjID)
		if playerClass and playerClass.className then
			producerClasses = AddClassToPackedValue(aPackedValue, playerClass.className)
		else
			producerClasses = AddClassToPackedValue(aPackedValue, "UNKNOWN")
		end
	else
		producerClasses = AddClassToPackedValue(aPackedValue, "UNKNOWN")
	end
	return producerClasses
end
local g_groupsTypes = {}
function AddBuffToEncylopedia(aBuffInfo, aNeedSaveOnChanges)
	if aBuffInfo and aBuffInfo.name and not aBuffInfo.name:IsEmpty() then
		local myInfo = {}
		myInfo.name = removeHtmlFromWString(aBuffInfo.name)
		--myInfo.name = aBuffInfo.name
		
		myInfo.buffs = {}
		
		local buffResourceAlreadyAdded = false
		
		local findedInfo = m_searchAllTree:find(myInfo)
		if findedInfo ~= nil then
			myInfo = findedInfo
			for _, buff in pairs(myInfo.buffs) do
				if buff.buffId:IsEqual(aBuffInfo.buffId) then
					local producerClasses = SetProducerClass(aBuffInfo.producer.casterId, buff.producerClasses)
					if buff.producerClasses ~= producerClasses then
						buff.producerClasses = producerClasses
						--LogInfo("modify myInfo.name = ", myInfo.name, "  producerClasses = ", producerClasses)
						if aNeedSaveOnChanges then
							m_wasSomeChangesToSave = true
						end
					end
					buffResourceAlreadyAdded = true
					break
				end
			end
		else
			m_searchAllTree:add(myInfo)
		end
	--[[	
		for _, groupName in pairs(aBuffInfo.groups) do
			if not g_groupsTypes[groupName] then
				g_groupsTypes[groupName] = true
				LogInfo("found aBuffInfo = ", aBuffInfo.name, "  groupName = ", groupName)
			end
		end
		]]
		if not buffResourceAlreadyAdded then
			local unicBuff = {}
			unicBuff.isCleanable = IsCleanable(aBuffInfo)
			unicBuff.isControls = IsControls(aBuffInfo)
			unicBuff.isPositive = aBuffInfo.isPositive
			unicBuff.isNeedVisualize = aBuffInfo.isNeedVisualize
			unicBuff.isStackable = aBuffInfo.isStackable
			unicBuff.isGradual = aBuffInfo.isGradual
			unicBuff.producerType = aBuffInfo.producerType or GetProducerType(aBuffInfo)
			unicBuff.producerClasses =  SetProducerClass(aBuffInfo.producer.casterId, aBuffInfo.producerClasses or 0)
			unicBuff.description = aBuffInfo.description
			unicBuff.texture = aBuffInfo.texture
			unicBuff.buffId = aBuffInfo.buffId
			table.insert(myInfo.buffs, unicBuff)
			if aNeedSaveOnChanges then
				m_wasSomeChangesToSave = true
			end
		end
	end
end

function CheckAllUnits()
	local unitList = avatar.GetUnitList()
	table.insert(unitList, avatar.GetId())
	
	for _, objID in pairs(unitList) do
		if objID then 
			local unitParams = {}
			unitParams.objectId = objID
			m_subscribedUnits[unitParams.objectId] = unitParams
			common.RegisterEventHandler(OnBuffAdded, 'EVENT_OBJECT_BUFF_ADDED', unitParams)
			
			local buffs = object.GetBuffs(objID)
			if next(buffs) then
				local buffsInfo = object.GetBuffsInfo(buffs)
				for _, buffInfo in pairs( buffsInfo or {} ) do
					AddBuffToEncylopedia(buffInfo, true)
				end
			end
		end
	end
end

function OnBuffAdded(aParams)
	AddBuffToEncylopedia(object.GetBuffInfo(aParams.buffId), true)
end

function OnUnitChanged(aParams)
	for i=0, GetTableSize(aParams.spawned)-1 do
		if aParams.spawned[i] and not m_subscribedUnits[aParams.spawned[i]] then
			local unitParams = {}
			unitParams.objectId = aParams.spawned[i]
			m_subscribedUnits[unitParams.objectId] = unitParams
			common.RegisterEventHandler(OnBuffAdded, 'EVENT_OBJECT_BUFF_ADDED', unitParams)
		end
	end
	for i=0, GetTableSize(aParams.despawned)-1 do
		if aParams.despawned[i] and m_subscribedUnits[aParams.despawned[i]] then
			common.UnRegisterEventHandler(OnBuffAdded, 'EVENT_OBJECT_BUFF_ADDED', m_subscribedUnits[aParams.despawned[i]])
			m_subscribedUnits[aParams.despawned[i]] = nil
		end
	end
end

function OnEventSecondTimer()
	local unitList = avatar.GetUnitList()
	table.insert(unitList, avatar.GetId())
	for id, _ in pairs(m_subscribedUnits) do
		local reallyExist = false
		for _, objID in pairs(unitList) do
			if objID == id then
				reallyExist = true
				break
			end
		end
		if not reallyExist then
			common.UnRegisterEventHandler(OnBuffAdded, 'EVENT_OBJECT_BUFF_ADDED', m_subscribedUnits[id])
			m_subscribedUnits[id] = nil
		end
	end
	
	m_secondsCnt = m_secondsCnt + 1
	if m_secondsCnt > 30 then
		m_secondsCnt = 0
		if m_wasSomeChangesToSave then
			SavePressed()
		end
	end
end

function GetProducerType(aBuffInfo)
	return isExist(aBuffInfo.producer.casterId) and unit.IsPlayer(aBuffInfo.producer.casterId) and PLAYER_PRODUCER
	or isExist(aBuffInfo.producer.casterId) and UNIT_PRODUCER
	or aBuffInfo.producer.spellId and SPELL_PRODUCER
	or aBuffInfo.producer.abilityId and ABILITY_PRODUCER
	or aBuffInfo.producer.buffId and BUFF_PRODUCER
	or UNKNOWN_PRODUCER
end

function IsControls(aBuffInfo)
	local isControls = false
			
	for _, groupName in pairs(aBuffInfo.groups) do
		if 	groupName == "controls" or 
			groupName == "stuns" or
			groupName == "Disarms" or
			groupName == "fears"
		then
			isControls = true
			break
		end
	end
	
	return isControls
end

function IsCleanable(aBuffInfo)
	local isCleanable = false
			
	for _, groupName in pairs(aBuffInfo.groups) do
		if 	groupName == "magics" or
			groupName == "stackablemagics"
		then
			isCleanable = true
			break
		end
	end
	
	return isCleanable
end


function SavePressed()
	local settings = GetCurrentSettings()
	settings.db = {}
	for _, record in ipairs(m_searchAllTree:getTreeInList()) do 
		for _, buffInfo in pairs(record.buffs) do
			local simpleInfo = {}
			simpleInfo.producerType = buffInfo.producerType
			simpleInfo.producerClasses = buffInfo.producerClasses
			simpleInfo.buffId = buffInfo.buffId
			table.insert(settings.db, simpleInfo)
		end
	end
	SaveSettings()
end

function LoadFormSettings()
	m_searchAllTree = GetAVLWStrTree()
	LoadSettings()
	
	local settings = GetCurrentSettings()
	for _, simpleInfo in pairs(settings.db) do
		if simpleInfo.buffId then
			local info = object.GetBuffInfo(simpleInfo.buffId)
			if info then
				info.producerType = simpleInfo.producerType
				info.producerClasses = simpleInfo.producerClasses
				if info.producerClasses == nil then
					info.producerClasses = AddClassToPackedValue(0, "UNKNOWN")
				end
				AddBuffToEncylopedia(info, false)
			end
		end
	end
	
	CheckAllUnits()
end

function UpdatePressed()
	local showDuplicate = IsShowDuplicate(m_configForm)
	m_currAllList = {}
	for _, record in ipairs(m_searchAllTree:getTreeInList()) do 
		for _, buffInfo in pairs(record.buffs) do
			buffInfo.name = record.name
			buffInfo.nameStr = toLowerString(record.name)
			table.insert(m_currAllList, buffInfo)
			if not showDuplicate then
				break
			end
		end
	end

	SetScrollList(m_configForm, m_currAllList)
	m_currAllListContainDuplicate = showDuplicate
end

function ShowBuffInfoPressed(aWdg)
	local index = GetIndexForWidget(aWdg) + 1
	
	local buffInfoForm = InitBuffInfoForm()
	SetBuffInfoFormSetting(buffInfoForm, GetSearchScrollList(), index)
	WndMgr.ShowWdg(buffInfoForm)
end

function EditLineChanged()
	ChangedFilter()
end

function ChangedFilter()
	local showDuplicate = IsShowDuplicate(m_configForm)
	if m_currAllListContainDuplicate ~= showDuplicate then
		UpdatePressed()
	end
	local cleanable, nocleanable, negative, positive, showWARRIOR, showPALADIN, showMAGE, showDRUID, showPSIONIC, showSTALKER, showPRIEST, showNECROMANCER, showENGINEER, showBARD, showWARLOCK, showUNKNOWN = GetFilters(m_configForm)
	local filtredBuffs = {}
	local classMask = BuildClassMask(showWARRIOR, showPALADIN, showMAGE, showDRUID, showPSIONIC, showSTALKER, showPRIEST, showNECROMANCER, showENGINEER, showBARD, showWARLOCK, showUNKNOWN)

	for _, buffInfo in pairs(m_currAllList) do
		if (cleanable and buffInfo.isCleanable 
			or nocleanable and not buffInfo.isCleanable)
			and (negative and not buffInfo.isPositive
			or positive and buffInfo.isPositive)
			and bit.band(buffInfo.producerClasses, classMask) ~= 0
		then
			table.insert(filtredBuffs, buffInfo)
		end
	end
	
	local findedBuffs = {}
	local currText = string.lower(getTextString(getChild(m_configForm, "searchEdit")))
	if currText ~= "" then
		for _, buffInfo in pairs(filtredBuffs) do
			local res = string.find(buffInfo.nameStr, currText)
			if res then
				table.insert(findedBuffs, buffInfo)
			end
		end
		
		SetScrollList(m_configForm, findedBuffs)
	else
		SetScrollList(m_configForm, filtredBuffs)
	end
end

function OnSlashCommand(aParams)
	if userMods.FromWString(aParams.text) == "/bereset1" or userMods.FromWString(aParams.text) == "\\bereset1" then
		move(getChild(mainForm, "BEButton"), 300, 120)
	end
	if userMods.FromWString(aParams.text) == "/bereset2" or userMods.FromWString(aParams.text) == "\\bereset2" then
		SaveDefaultSettings()
		common.StateUnloadManagedAddon( "UserAddon/BuffEncyclopedia" )
		common.StateLoadManagedAddon( "UserAddon/BuffEncyclopedia" )
	end
end

local function EditLineEsc(aParams)
	aParams.widget:SetFocus(false)
end

function Init()
	setTemplateWidget("common")

	local button=createWidget(mainForm, "BEButton", "Button", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 25, 25, 300, 120)
	setText(button, "BE")
	DnD.Init(button, button, true)

	
	m_configForm = InitSearchForm()
	
	LoadFormSettings()
	
	
	common.RegisterReactionHandler(ButtonPressed, "execute")
	common.RegisterReactionHandler(CheckBoxChangedOn, "CheckBoxChangedOn")
	common.RegisterReactionHandler(CheckBoxChangedOff, "CheckBoxChangedOff")
	common.RegisterReactionHandler(EditLineChanged, "EditLineChanged")
	common.RegisterEventHandler(OnUnitChanged, "EVENT_UNITS_CHANGED")
	--по таймеру проверять валидность списка подписанных
	common.RegisterEventHandler(OnEventSecondTimer, "EVENT_SECOND_TIMER")
	common.RegisterEventHandler( OnSlashCommand, "EVENT_UNKNOWN_SLASH_COMMAND" )
	common.RegisterReactionHandler(function (aParams) WndMgr.OnWndClicked(aParams.widget) end, "PanelWndClick")
	common.RegisterReactionHandler(EditLineEsc, "EditLineEsc")
		
	AddReaction("BEButton", function () ChangeMainWndVisible() end)
	AddReaction("closeMainButton", function (aWdg) ChangeMainWndVisible() end)
	AddReaction("closeButton", function (aWdg) WndMgr.SwapWnd(getParent(aWdg)) end)
	AddReaction("closeBuffButton", function (aWdg) WndMgr.SwapWnd(getParent(aWdg)) end)
	AddReaction("scrollBtncontainerBuffs", ShowBuffInfoPressed)
	AddReaction("showCleanable", ChangedFilter)
	AddReaction("showNoCleanable", ChangedFilter)
	AddReaction("showNegative", ChangedFilter)
	AddReaction("showPositive", ChangedFilter)
	AddReaction("showDuplicate", ChangedFilter)
	AddReaction("showWARRIOR", ChangedFilter)
	AddReaction("showPALADIN", ChangedFilter)
	AddReaction("showMAGE", ChangedFilter)
	AddReaction("showDRUID", ChangedFilter)
	AddReaction("showPSIONIC", ChangedFilter)
	AddReaction("showSTALKER", ChangedFilter)
	AddReaction("showPRIEST", ChangedFilter)
	AddReaction("showNECROMANCER", ChangedFilter)
	AddReaction("showENGINEER", ChangedFilter)
	AddReaction("showBARD", ChangedFilter)
	AddReaction("showWARLOCK", ChangedFilter)
	AddReaction("showUNKNOWN", ChangedFilter)
	
	AoPanelSupportInit()
end

if (avatar.IsExist()) then
	Init()
else
	common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")
end