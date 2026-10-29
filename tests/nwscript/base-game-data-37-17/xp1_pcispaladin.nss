// the PC has at least 1 level Paladin

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker()) > 0;
    return iResult;
}
