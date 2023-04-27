local m_prevShift = 0

function InitBuffInfoForm()
	local template = getChild(mainForm, "Template")
	setTemplateWidget(template)
	local formWidth = 530
	local form=createWidget(mainForm, "BuffInfoForm", "Panel", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, formWidth, 400, 100+m_prevShift, 120+m_prevShift)
	priority(form, 2500)
	hide(form)
	m_prevShift = m_prevShift + 5
	if m_prevShift > 50 then
		m_prevShift = 0
	end

	local btnWidth = 100
	
	setLocaleText(createWidget(form, "closeBuffButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_HIGH, btnWidth, 25, formWidth/2-btnWidth/2, 20))
	createWidget(form, "header", "EditLineTransparent", nil, nil, formWidth, 25, 60, 20)
	createWidget(form, "preview1", "ImageBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 45, 45, 10, 6)
	
	
	local typesTxtWidth = 160
	local txtValuesShift = 195
	local topYShift = 5
	local group1 = createWidget(form, "group1", "Panel")
	align(group1, WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW)
	resize(group1, formWidth-20, 300)
	move(group1, 10, 50)
	setBackgroundTexture(group1, nil)
	setBackgroundColor(group1, nil)
	group1:SetTransparentInput(true)

	setLocaleText(createWidget(group1, "isNegative", "TextView", nil, nil, typesTxtWidth, 25, 20, topYShift))
	createWidget(group1, "value1", "TextView", nil, nil, 40, 25, txtValuesShift, topYShift)
	setLocaleText(createWidget(group1, "isNeedVisualize", "TextView", nil, nil, typesTxtWidth, 25, 20, topYShift+25))
	createWidget(group1, "value2", "TextView", nil, nil, 40, 25, txtValuesShift, topYShift+25)
	setLocaleText(createWidget(group1, "isStackable", "TextView", nil, nil, typesTxtWidth, 25, 20, topYShift+50))
	createWidget(group1, "value3", "TextView", nil, nil, 40, 25, txtValuesShift, topYShift+50)
	setLocaleText(createWidget(group1, "isGradual", "TextView", nil, nil, typesTxtWidth, 25, 20, topYShift+75))
	createWidget(group1, "value4", "TextView", nil, nil, 40, 25, txtValuesShift, topYShift+75)
	setLocaleText(createWidget(group1, "cleanable", "TextView", nil, nil, typesTxtWidth, 25, 20, topYShift+100))
	createWidget(group1, "value5", "TextView", nil, nil, 40, 25, txtValuesShift, topYShift+100)
	setLocaleText(createWidget(group1, "controls", "TextView", nil, nil, typesTxtWidth, 25, 20, topYShift+125))
	createWidget(group1, "value6", "TextView", nil, nil, 40, 25, txtValuesShift, topYShift+125)
	setLocaleText(createWidget(group1, "producer", "TextView", nil, nil, typesTxtWidth, 25, 20, topYShift+150))
	createWidget(group1, "value7", "TextView", nil, nil, 50, 25, txtValuesShift, topYShift+150)
	
	local description = createWidget(group1, "desc", "TextView", nil, nil, 245, 300, txtValuesShift+60, topYShift)
	description:SetMultiline(true)
	
	setText(createWidget(form, "closeBuffButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_LOW, 20, 20, 20, 20), "x")
	DnD.Init(form, form, false)
	
	return form
end


function SetBuffInfoFormSetting(aForm, aList, anIndex)
	local buffInfo = aList[anIndex]
	local locale = getLocale()
	
	local valuedText = toValuedText(buffInfo.name, "ColorWhite", "left", 18)
	setText(getChild(aForm, "header"), common.ExtractWStringFromValuedText(valuedText))
	getChild(aForm, "header"):SetFocus(true)
	
	getChild(aForm, "preview1"):SetBackgroundTexture(buffInfo.texture)
	
	local group1 = getChild(aForm, "group1")
		
	local wDesc = common.ExtractWStringFromValuedText(buffInfo.description)
	setText(getChild(group1, "desc"), wDesc)

	setText(getChild(group1, "value1"), locale[tostring(not buffInfo.isPositive)], buffInfo.isPositive and "ColorRed" or "ColorGreen", "center", 12)
	setText(getChild(group1, "value2"), locale[tostring(buffInfo.isNeedVisualize)], buffInfo.isNeedVisualize and "ColorGreen" or "ColorRed", "center", 12)
	setText(getChild(group1, "value3"), locale[tostring(buffInfo.isStackable)], buffInfo.isStackable and "ColorGreen" or "ColorRed", "center", 12)
	setText(getChild(group1, "value4"), locale[tostring(buffInfo.isGradual)], buffInfo.isGradual and "ColorGreen" or "ColorRed", "center", 12)
	setText(getChild(group1, "value5"), locale[tostring(buffInfo.isCleanable)], buffInfo.isCleanable and "ColorGreen" or "ColorRed", "center", 12)
	setText(getChild(group1, "value6"), locale[tostring(buffInfo.isControls)], buffInfo.isControls and "ColorGreen" or "ColorRed", "center", 12)
	setText(getChild(group1, "value7"), locale[buffInfo.producerType], "ColorWhite", "center", 12)
	
end

