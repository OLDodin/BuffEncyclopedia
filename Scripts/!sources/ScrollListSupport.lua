local m_template = getChild(mainForm, "Template")


function GenerateWidgetForTable(aTable, aContainer, anIndex)
	setTemplateWidget("common")
	local panel=createWidget(mainForm, "scrollElem_"..tostring(anIndex), "Panel", WIDGET_ALIGN_BOTH, WIDGET_ALIGN_LOW, nil, 40)
	setBackgroundColor(panel, {r=1, g=1, b=1, a=0.5})
	if aTable.name then
		setText(createWidget(panel, "Name"..tostring(anIndex), "TextView", WIDGET_ALIGN_LOW, WIDGET_ALIGN_CENTER, 300, 20, 4), tostring(anIndex)..".  "..aTable.name)
	end
	local preview = createWidget(panel, "preview", "ImageBox", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_LOW, 30, 30, 15, 6)
	preview:SetBackgroundTexture(aTable.texture)
	createWidget(panel, "scrollBtncontainerBuffs", "EmptyButton", WIDGET_ALIGN_BOTH, WIDGET_ALIGN_LOW, nil, 40, nil, nil)

	return panel
end

local function GetIndexForWidgetByMainPanel(anWidget)
	local parentWdg = getParent(anWidget)
	
	while parentWdg do 
		local wdgName = getName(parentWdg)
		if findSimpleString(wdgName, "scrollElem_") then
			local nStr = string.gsub(wdgName, "scrollElem_", "")
			--container from 0
			return tonumber(nStr) - 1
		end
		parentWdg = getParent(parentWdg)
	end
end

SetGenerateWidgetForContainerFunc(GenerateWidgetForTable)
SetGetIndexForWidgetInContainerFunc(GetIndexForWidgetByMainPanel)