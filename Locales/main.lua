Global("Locales", {})

Global("PLAYER_PRODUCER", 1)
Global("UNIT_PRODUCER", 2)
Global("SPELL_PRODUCER", 3)
Global("ABILITY_PRODUCER", 4)
Global("BUFF_PRODUCER", 5)
Global("UNKNOWN_PRODUCER", 6)


function getLocale()
	return Locales[common.GetLocalization()] or Locales["eng"]
end

--------------------------------------------------------------------------------
-- Russian
--------------------------------------------------------------------------------

Locales["rus"]={}
Locales["rus"]["saveBtn"]="Сохранить"
Locales["rus"]["updBtn"]="Обновить"
Locales["rus"]["header1"]="Энциклопедия бафов"
Locales["rus"]["isNegative"]="Негативный:"
Locales["rus"]["isNeedVisualize"]="Отображаемый:"
Locales["rus"]["isStackable"]="Стэкуемый:"
Locales["rus"]["isGradual"]="Стэки спадают по 1му:"
Locales["rus"]["cleanable"]="Счищаемый:"
Locales["rus"]["controls"]="Контроль:"
Locales["rus"]["producer"]="Создатель:"
Locales["rus"]["true"]="Да"
Locales["rus"]["false"]="Нет"
Locales["rus"]["closeBuffButton"]="Закрыть"
Locales["rus"]["closeMainButton"]="Закрыть"
Locales["rus"][PLAYER_PRODUCER]="Игрок"
Locales["rus"][UNIT_PRODUCER]="Нпс"
Locales["rus"][SPELL_PRODUCER]="Умение"
Locales["rus"][ABILITY_PRODUCER]="Умение"
Locales["rus"][BUFF_PRODUCER]="Бафф"
Locales["rus"][UNKNOWN_PRODUCER]="Нет"
Locales["rus"]["searchBtn"]="Поиск:"
Locales["rus"]["showCleanable"]="Счищаемые"
Locales["rus"]["showNoCleanable"]="Несчищаемые"
Locales["rus"]["showNegative"]="Негативные"
Locales["rus"]["showPositive"]="Позитивные"

--------------------------------------------------------------------------------
-- English
--------------------------------------------------------------------------------

Locales["eng"]={}
Locales["eng"]={}
Locales["eng"]["saveBtn"]="Save"
Locales["eng"]["header1"]="Buff Encyclopedia"
Locales["eng"]["isNegative"]="Negative:"
Locales["eng"]["isNeedVisualize"]="Displayed:"
Locales["eng"]["isStackable"]="Stackable:"
Locales["eng"]["isGradual"]="Gradual:"
Locales["eng"]["cleanable"]="Cleanable:"
Locales["eng"]["controls"]="Controls:"
Locales["eng"]["producer"]="Creator:"
Locales["eng"]["true"]="Yes"
Locales["eng"]["false"]="No"
Locales["eng"]["closeBuffButton"]="Close"
Locales["eng"]["closeMainButton"]="Close"
Locales["eng"][PLAYER_PRODUCER]="Player"
Locales["eng"][UNIT_PRODUCER]="NPC"
Locales["eng"][SPELL_PRODUCER]="Skill"
Locales["eng"][ABILITY_PRODUCER]="Skill"
Locales["eng"][BUFF_PRODUCER]="Buff"
Locales["eng"][UNKNOWN_PRODUCER]="None"
Locales["eng"]["searchBtn"]="Search:"
Locales["eng"]["showCleanable"]="Cleanable"
Locales["eng"]["showNoCleanable"]="Non cleanable"
Locales["eng"]["showNegative"]="Negative"
Locales["eng"]["showPositive"]="Positive"
