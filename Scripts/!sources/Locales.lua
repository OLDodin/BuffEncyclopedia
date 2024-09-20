Global("Locales", {})
Global("LocalesInited", false)

Global("PLAYER_PRODUCER", 1)
Global("UNIT_PRODUCER", 2)
Global("SPELL_PRODUCER", 3)
Global("ABILITY_PRODUCER", 4)
Global("BUFF_PRODUCER", 5)
Global("UNKNOWN_PRODUCER", 6)


local localeGroup = common.GetAddonRelatedTextGroup(common.GetLocalization(), true) or common.GetAddonRelatedTextGroup("eng")

function getLocale()
	if LocalesInited then
		return Locales
	else
		LocalesInited = true
		return setmetatable(Locales, 
			{__index = function(t,k) 
				if type(k) == "number" then
					if k == PLAYER_PRODUCER then
						return localeGroup:GetText("PLAYER_PRODUCER") 
					elseif k == UNIT_PRODUCER then
						return localeGroup:GetText("UNIT_PRODUCER") 
					elseif k == SPELL_PRODUCER then
						return localeGroup:GetText("SPELL_PRODUCER") 
					elseif k == ABILITY_PRODUCER then
						return localeGroup:GetText("ABILITY_PRODUCER") 
					elseif k == BUFF_PRODUCER then
						return localeGroup:GetText("BUFF_PRODUCER") 
					elseif k == UNKNOWN_PRODUCER then
						return localeGroup:GetText("UNKNOWN_PRODUCER") 
					else
						return nil
					end
				end
				if localeGroup:HasText(k) then
					return localeGroup:GetText(k) 
				end
			end
			}
		)
	end
end
