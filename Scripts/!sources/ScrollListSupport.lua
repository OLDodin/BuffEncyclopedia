local m_template = getChild(mainForm, "Template")


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

SetGenerateWidgetForContainerFunc(GenerateWidgetForTable)