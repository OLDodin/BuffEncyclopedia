local m_template = createWidget(nil, "Template", "Template")

function GetIndexForWidget(anWidget)
	local parent = getParent(anWidget)
	local container = getParent(getParent(getParent(parent)))
	if not parent or not container then 
		return nil
	end
	local index = nil
	for i=0, container:GetElementCount() do
		if equals(anWidget, getChild(container:At(i), getName(anWidget), true)) then index=i end
	end
	return index
end

function GenerateWidgetForTable(aTable, aContainer, anIndex)
	setTemplateWidget(m_template)
	local containerParentName = getName(getParent(aContainer))
	local containerName = getName(aContainer)
	
	
	local panel=createWidget(aContainer, nil, "Panel", WIDGET_ALIGN_BOTH, WIDGET_ALIGN_LOW, nil, 40, nil, nil, true)
	setBackgroundColor(panel, {r=1, g=1, b=1, a=0.5})
	setText(createWidget(panel, "Id", "TextView", WIDGET_ALIGN_LOW, WIDGET_ALIGN_CENTER, 40, 20, 4), anIndex)
	if aTable.name then
		local nameWidget=createWidget(panel, "Name"..tostring(anIndex), "TextView", WIDGET_ALIGN_LOW, WIDGET_ALIGN_CENTER, 250, 20, 70)
		setText(nameWidget, aTable.name)
	end
	local preview = createWidget(panel, "preview", "ImageBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 30, 30, 35, 6)
	preview:SetBackgroundTexture(aTable.texture)

	createWidget(panel, "scrollBtn"..containerName, "EmptyButton", WIDGET_ALIGN_BOTH, WIDGET_ALIGN_LOW, nil, 40, nil, nil)
	
	return panel
end

function ShowValuesFromTable(aTable, aForm, aContainer)
	local container = aContainer
	if not aContainer then 
		container = getChild(aForm, "container") 
	end

	if not aTable or not container then 
		return nil 
	end
	
	if container.RemoveItems then 
		container:RemoveItems() 
	end
	for i, element in ipairs(aTable) do
		if container.PushBack then
			local widget=GenerateWidgetForTable(element, container, i)
			if widget then 
				container:PushBack(widget) 
			end
		end
	end
end

function DeleteContainer(aTable, anWidget, aForm)
	local parent = getParent(anWidget)
	local container = getParent(getParent(getParent(parent)))
	local index = GetIndexForWidget(anWidget)
	if container and index and aTable then
		container:RemoveAt(index)
		table.remove(aTable, index+1)
	end
	ShowValuesFromTable(aTable, aForm, container)
end

function UpdateTableValuesFromContainer(aTable, aForm, aContainer)
	local container = aContainer
	if not aContainer then 
		container = getChild(aForm, "container") 
	end
	if not container or not aTable then 
		return nil 
	end
	for i, j in ipairs(aTable) do
		j.name=getText(getChild(container, "Name"..tostring(i), true))
	end
end

function AddElementFromForm(aTable, aForm, aTextedit, aContainer)
	if not aTextedit then aTextedit="EditLine1" end
	local text = getText(getChild(aForm, aTextedit))
	local textLowerStr = toLowerString(text)
	if not aTable or not text or common.IsEmptyWString(text) then 
		return nil 
	end
	table.insert(aTable, { name=text, nameLowerStr=textLowerStr } )
	ShowValuesFromTable(aTable, aForm, aContainer)
end
