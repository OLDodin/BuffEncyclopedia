local m_scrollList = nil



function InitSearchForm()
	local template = getChild(mainForm, "Template")
	setTemplateWidget(template)
	local formWidth = 440
	local form=createWidget(mainForm, "SearchForm", "Panel", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, formWidth, 650, 100, 120)
	priority(form, 2500)
	hide(form)

	setLocaleText(createWidget(form, "header1", "TextView", nil, nil, 200, 25, 20, 20))
	createWidget(form, "searchEdit", "EditLine", nil, nil, 330, 25, 80, 46, nil, nil)
	setLocaleText(createWidget(form, "searchBtn", "TextView", nil, nil, 80, 25, 20, 46))
	
	setLocaleText(createWidget(form, "showDuplicate", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 220, 25, 20, 75), true, true)
	
	setLocaleText(createWidget(form, "showCleanable", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 160, 25, 20, 110), true, true)
	setLocaleText(createWidget(form, "showNoCleanable", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 160, 25, 20, 135), true, true)
	setLocaleText(createWidget(form, "showNegative", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 160, 25, 200, 110), true, true)
	setLocaleText(createWidget(form, "showPositive", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 160, 25, 200, 135), true, true)
	
	setLocaleText(createWidget(form, "showWARRIOR", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 120, 25, 20, 170), true, true)
	setLocaleText(createWidget(form, "showPALADIN", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 120, 25, 160, 170), true, true)
	setLocaleText(createWidget(form, "showMAGE", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 120, 25, 300, 170), true, true)
	
	setLocaleText(createWidget(form, "showDRUID", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 120, 25, 20, 195), true, true)
	setLocaleText(createWidget(form, "showPSIONIC", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 120, 25, 160, 195), true, true)
	setLocaleText(createWidget(form, "showSTALKER", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 120, 25, 300, 195), true, true)
	
	setLocaleText(createWidget(form, "showPRIEST", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 120, 25, 20, 220), true, true)
	setLocaleText(createWidget(form, "showNECROMANCER", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 120, 25, 160, 220), true, true)
	setLocaleText(createWidget(form, "showENGINEER", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 120, 25, 300, 220), true, true)
	
	setLocaleText(createWidget(form, "showBARD", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 120, 25, 20, 245), true, true)
	setLocaleText(createWidget(form, "showWARLOCK", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 120, 25, 160, 245), true, true)
	setLocaleText(createWidget(form, "showUNKNOWN", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 120, 25, 300, 245), true, true)

	local btnWidth = 100
	
	setLocaleText(createWidget(form, "closeMainButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_HIGH, btnWidth, 25, formWidth/2-btnWidth/2, 20))

	setText(createWidget(form, "closeMainButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_LOW, 20, 20, 20, 20), "x")
	DnD.Init(form, form, true)
	
	createWidget(form, "containerBuffs", "ScrollableContainer", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 400, 310, 20, 277)
	
	return form
end

function SetScrollList(aForm, aList)
	m_scrollList = aList
	ShowValuesFromTable(aList, aForm, getChild(aForm, "containerBuffs"))
end

function GetSearchScrollList()
	return m_scrollList
end

function IsShowDuplicate(aForm)
	return getCheckBoxState(getChild(aForm, "showDuplicate"))
end

function GetFilters(aForm)
	 return getCheckBoxState(getChild(aForm, "showCleanable")),
	 getCheckBoxState(getChild(aForm, "showNoCleanable")),
	 getCheckBoxState(getChild(aForm, "showNegative")),
	 getCheckBoxState(getChild(aForm, "showPositive")),
	 getCheckBoxState(getChild(aForm, "showWARRIOR")),
	 getCheckBoxState(getChild(aForm, "showPALADIN")),
	 getCheckBoxState(getChild(aForm, "showMAGE")),
	 getCheckBoxState(getChild(aForm, "showDRUID")),
	 getCheckBoxState(getChild(aForm, "showPSIONIC")),
	 getCheckBoxState(getChild(aForm, "showSTALKER")),
	 getCheckBoxState(getChild(aForm, "showPRIEST")),
	 getCheckBoxState(getChild(aForm, "showNECROMANCER")),
	 getCheckBoxState(getChild(aForm, "showENGINEER")),
	 getCheckBoxState(getChild(aForm, "showBARD")),
	 getCheckBoxState(getChild(aForm, "showWARLOCK")),
	 getCheckBoxState(getChild(aForm, "showUNKNOWN"))
end