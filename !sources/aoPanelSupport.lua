local IsAOPanelEnabled = GetConfig( "EnableAOPanel" ) or GetConfig( "EnableAOPanel" ) == nil

function onAOPanelStart( params )
	if IsAOPanelEnabled then
	
		local SetVal = { val = userMods.ToWString( "BE") }
		local params = { header = SetVal, ptype = "button", size = 30 }
		userMods.SendEvent( "AOPANEL_SEND_ADDON",
			{ name = common.GetAddonName(), sysName = common.GetAddonName(), param = params } )

		DnD.HideWdg(getChild(mainForm, "BEButton"))
	end
end

function onAOPanelLeftClick( params )
	if params.sender == common.GetAddonName() then
		ChangeMainWndVisible()
	end
end

function onAOPanelRightClick( params )
	if params.sender == common.GetAddonName() then
		local SetVal = { val = userMods.ToWString( "BE" )}
		userMods.SendEvent( "AOPANEL_UPDATE_ADDON", { sysName = common.GetAddonName(), header = SetVal } )
		ChangeSelectedAddons()
	end
	
end

function onAOPanelChange( params )
	if params.unloading and params.name == "UserAddon/AOPanelMod" then
		DnD.ShowWdg(getChild(mainForm, "BEButton"))
	end
end

function enableAOPanelIntegration( enable )
	IsAOPanelEnabled = enable
	SetConfig( "EnableAOPanel", enable )

	if enable then
		onAOPanelStart()
	else
		DnD.ShowWdg(getChild(mainForm, "BEButton"))
	end
end

function AoPanelSupportInit()
	common.RegisterEventHandler( onAOPanelStart, "AOPANEL_START" )
	common.RegisterEventHandler( onAOPanelLeftClick, "AOPANEL_BUTTON_LEFT_CLICK" )
	common.RegisterEventHandler( onAOPanelRightClick, "AOPANEL_BUTTON_RIGHT_CLICK" )
	common.RegisterEventHandler( onAOPanelChange, "EVENT_ADDON_LOAD_STATE_CHANGED" )
end

