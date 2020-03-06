local m_currentSettings = nil

function SaveSettings()
	if not m_currentSettings then
		return
	end
	userMods.SetGlobalConfigSection("BE_settings", m_currentSettings)
end

function SaveDefaultSettings()
	local saveObj = {}
	saveObj.db = {}
	
	userMods.SetGlobalConfigSection("BE_settings", saveObj)
end

function LoadSettings()
	local settings = userMods.GetGlobalConfigSection("BE_settings")
	if not settings then
		SaveDefaultSettings()
		settings = userMods.GetGlobalConfigSection("BE_settings")
	end
	m_currentSettings = settings
end

function GetCurrentSettings()
	return m_currentSettings
end