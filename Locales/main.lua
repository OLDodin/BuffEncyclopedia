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
Locales["rus"]["saveBtn"]="���������"
Locales["rus"]["updBtn"]="��������"
Locales["rus"]["header1"]="����� �����"
Locales["rus"]["isNegative"]="����������:"
Locales["rus"]["isNeedVisualize"]="������������:"
Locales["rus"]["isStackable"]="���������:"
Locales["rus"]["isGradual"]="����� ������� �� 1��:"
Locales["rus"]["cleanable"]="���������:"
Locales["rus"]["controls"]="��������:"
Locales["rus"]["producer"]="���������:"
Locales["rus"]["true"]="��"
Locales["rus"]["false"]="���"
Locales["rus"]["closeBuffButton"]="�������"
Locales["rus"]["closeMainButton"]="�������"
Locales["rus"][PLAYER_PRODUCER]="�����"
Locales["rus"][UNIT_PRODUCER]="���"
Locales["rus"][SPELL_PRODUCER]="������"
Locales["rus"][ABILITY_PRODUCER]="������"
Locales["rus"][BUFF_PRODUCER]="����"
Locales["rus"][UNKNOWN_PRODUCER]="���"
Locales["rus"]["searchBtn"]="�����:"
Locales["rus"]["showCleanable"]="���������"
Locales["rus"]["showNoCleanable"]="�����������"
Locales["rus"]["showNegative"]="����������"
Locales["rus"]["showPositive"]="����������"

--------------------------------------------------------------------------------
-- English
--------------------------------------------------------------------------------

Locales["eng"]={}

