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
Locales["rus"]["header1"]="Поиск баффа"
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

