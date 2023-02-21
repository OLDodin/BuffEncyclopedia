
local m_reactions={}
local m_configForm = nil
local m_template = nil

local m_searchAllTree = nil
local m_currAllList = {}
local m_subscribedUnits = {}

local m_secondsCnt = 0
local m_wasSomeChangesToSave = false

function AddReaction(name, func)
	if not m_reactions then m_reactions={} end
	m_reactions[name]=func
end

function RunReaction(widget)
	local name=getName(widget)
	if name == "GetModeBtn" then
		name=getName(getParent(widget))
	end
	if not name or not m_reactions or not m_reactions[name] then return end
	m_reactions[name](widget)
end

function ButtonPressed(aParams)
	changeCheckBox(aParams.widget)
	RunReaction(aParams.widget)
end

function RightClick(params)

end

function ChangeMainWndVisible()
	if isVisible(m_configForm) then
		hide(m_configForm)
	else
		UpdatePressed()
		show(m_configForm)
	end
	
	collectgarbage()
end

local function GetTimestamp()
	return common.GetMsFromDateTime( common.GetLocalDateTime() )
end

function AddBuffToEncylopedia(aBuffInfo, aNeedSaveOnChanges)
	if aBuffInfo and aBuffInfo.name and not common.IsEmptyWString(aBuffInfo.name) then
		local myInfo = {}
		myInfo.name = aBuffInfo.name
		
		myInfo.buffs = {}
		
		local buffResourceAlreadyAdded = false
		local addRes = m_searchAllTree:add(myInfo)
		if not addRes then					
			for _, buff in pairs(myInfo.buffs) do
				if buff.buffId:IsEqual(aBuffInfo.buffId) then
					buffResourceAlreadyAdded = true
					break
				end
			end
		end
		
		if not buffResourceAlreadyAdded then
			local unicBuff = {}
			unicBuff.isCleanable = IsCleanable(aBuffInfo)
			unicBuff.isControls = IsControls(aBuffInfo)
			unicBuff.isPositive = aBuffInfo.isPositive
			unicBuff.isNeedVisualize = aBuffInfo.isNeedVisualize
			unicBuff.isStackable = aBuffInfo.isStackable
			unicBuff.isGradual = aBuffInfo.isGradual
			unicBuff.producerType = aBuffInfo.producerType or GetProducerType(aBuffInfo)
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
	if m_secondsCnt > 20 then
		m_secondsCnt = 0
		if m_wasSomeChangesToSave then
			SavePressed()
		end
	end
end

function GetProducerType(aBuffInfo)
	return isExist(aBuffInfo.producer.casterId) and object.IsUnit(aBuffInfo.producer.casterId) and unit.IsPlayer(aBuffInfo.producer.casterId) and PLAYER_PRODUCER
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
	for record in m_searchAllTree:iterate() do 
		for _, buffInfo in pairs(record.buffs) do
			local simpleInfo = {}
			simpleInfo.producerType = buffInfo.producerType
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
				AddBuffToEncylopedia(info, false)
			end
		end
	end
	
	CheckAllUnits()
end

function UpdatePressed()
	m_currAllList = {}
	for record in m_searchAllTree:iterate() do 
		for _, buffInfo in pairs(record.buffs) do
			buffInfo.name = record.name
			buffInfo.nameStr = toLowerString(record.name)
			table.insert(m_currAllList, buffInfo)
		end
	end
	
	SetScrollList(m_configForm, m_currAllList)
end

function ShowBuffInfoPressed(aWdg)
	local index = GetIndexForWidget(aWdg) + 1
	
	local buffInfoForm = InitBuffInfoForm()
	SetBuffInfoFormSetting(buffInfoForm, GetSearchScrollList(), index)
	show(buffInfoForm)
end

function EditLineChanged()
	ChangedFilter()
end

function ChangedFilter()
	local cleanable, nocleanable, negative, positive = GetFilters(m_configForm)
	local filtredBuffs = {}

	for _, buffInfo in pairs(m_currAllList) do
		if (cleanable and buffInfo.isCleanable 
			or nocleanable and not buffInfo.isCleanable)
			and (negative and not buffInfo.isPositive
			or positive and buffInfo.isPositive)
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
	m_template = getChild(mainForm, "Template")
	setTemplateWidget(m_template)

	local button=createWidget(mainForm, "BEButton", "Button", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 25, 25, 300, 120)
	setText(button, "BE")
	DnD:Init(button, button, true)

	
	m_configForm = InitSearchForm()
	
	LoadFormSettings()
	
	
	common.RegisterReactionHandler( RightClick, "RIGHT_CLICK" )
	common.RegisterReactionHandler(ButtonPressed, "execute")
	common.RegisterReactionHandler(EditLineChanged, "editLineChanged")
	common.RegisterEventHandler(OnUnitChanged, "EVENT_UNITS_CHANGED")
	--по таймеру проверять валидность списка подписанных
	common.RegisterEventHandler(OnEventSecondTimer, "EVENT_SECOND_TIMER")
	common.RegisterEventHandler( OnSlashCommand, "EVENT_UNKNOWN_SLASH_COMMAND" )
	
	common.RegisterReactionHandler(EditLineEsc, "EditLineEsc")
		
	AddReaction("BEButton", function () ChangeMainWndVisible() end)
	AddReaction("closeMainButton", function (aWdg) ChangeMainWndVisible() end)
	AddReaction("closeButton", function (aWdg) swap(getParent(aWdg)) end)
	AddReaction("closeBuffButton", function (aWdg) swap(getParent(aWdg)) end)
	AddReaction("scrollBtncontainerBuffs", ShowBuffInfoPressed)
	AddReaction("showCleanable", ChangedFilter)
	AddReaction("showNoCleanable", ChangedFilter)
	AddReaction("showNegative", ChangedFilter)
	AddReaction("showPositive", ChangedFilter)
		
	
	AoPanelSupportInit()
end

if (avatar.IsExist()) then
	Init()
else
	common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")
end