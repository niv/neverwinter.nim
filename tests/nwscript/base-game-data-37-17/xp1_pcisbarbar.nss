// the PC has at least 1 level Barbarian

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass(CLASS_TYPE_BARBARIAN, GetPCSpeaker()) > 0;
    return iResult;
}
