local m_scrollList = nil



function InitSearchForm()
	local template = getChild(mainForm, "Template")
	setTemplateWidget(template)
	local formWidth = 400
	local form=createWidget(mainForm, "SearchForm", "Panel", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, formWidth, 500, 100, 120)
	priority(form, 2500)
	hide(form)

	setLocaleText(createWidget(form, "header1", "TextView", nil, nil, 150, 25, 20, 20))
	createWidget(form, "searchEdit", "EditLine", nil, nil, 290, 25, 80, 50, nil, nil)
	setLocaleText(createWidget(form, "searchBtn", "TextView", nil, nil, 80, 25, 20, 50))
	
	setLocaleText(createWidget(form, "showCleanable", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 160, 25, 20, 75), true, true)
	setLocaleText(createWidget(form, "showNoCleanable", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 160, 25, 20, 100), true, true)
	setLocaleText(createWidget(form, "showNegative", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 160, 25, 200, 75), true, true)
	setLocaleText(createWidget(form, "showPositive", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 160, 25, 200, 100), true, true)

	local btnWidth = 100
	
	setLocaleText(createWidget(form, "closeMainButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_HIGH, btnWidth, 25, formWidth/2-btnWidth/2, 20))

	setText(createWidget(form, "closeMainButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_LOW, 20, 20, 20, 20), "x")
	DnD.Init(form, form, true)
	
	createWidget(form, "containerBuffs", "ScrollableContainer", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 360, 310, 20, 127)
	
	return form
end

function SetScrollList(aForm, aList)
	m_scrollList = aList
	ShowValuesFromTable(aList, aForm, getChild(aForm, "containerBuffs"))
end

function GetSearchScrollList()
	return m_scrollList
end

function GetFilters(aForm)
	 return getCheckBoxState(getChild(aForm, "showCleanable")),
	 getCheckBoxState(getChild(aForm, "showNoCleanable")),
	 getCheckBoxState(getChild(aForm, "showNegative")),
	 getCheckBoxState(getChild(aForm, "showPositive"))
end