local m_template = getChild(mainForm, "Template")

function GetIndexForWidget(anWidget)
	local parent = getParent(anWidget)
	local container = getParent(getParent(getParent(parent)))
	if not parent or not container then 
		return nil
	end
	local searchingName = getName(anWidget)
	
	for i=0, container:GetElementCount()-1 do
		local childWithName = getChild(container:At(i), searchingName, true)
		if childWithName and anWidget:IsEqual(childWithName) then 
			return i
		end
	end
end

function GenerateWidgetForTable(aTable, aContainer, anIndex)
	setTemplateWidget(m_template)
	local containerParentName = getName(getParent(aContainer))
	local containerName = getName(aContainer)
	
	
	local panel=createWidget(mainForm, "scrollElem_"..tostring(anIndex), "Panel", WIDGET_ALIGN_BOTH, WIDGET_ALIGN_LOW, nil, 40)
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
	
	local containerArr = {}
	for i = 0, container:GetElementCount() - 1 do
		table.insert(containerArr, container:At(i))
	end
	container:RemoveItems() 
	for j, containerWdg in ipairs(containerArr) do
		containerWdg:DestroyWidget()
	end
	
	for i, element in ipairs(aTable) do
		local widget=GenerateWidgetForTable(element, container, i)
		if widget then 
			container:PushBack(widget)
		end
	end
end

function DeleteContainer(aTable, anWidget, aForm)
	local parent = getParent(anWidget)
	local container = getParent(getParent(getParent(parent)))
	local index = GetIndexForWidget(anWidget)
	if container and index and aTable then
		local deletingWdg = container:At(index)
		container:RemoveAt(index)
		table.remove(aTable, index+1)
		deletingWdg:DestroyWidget()
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
	if not aTable or not text or text:IsEmpty() then 
		return nil 
	end
	table.insert(aTable, { name=text, nameLowerStr=textLowerStr } )
	ShowValuesFromTable(aTable, aForm, aContainer)
end
