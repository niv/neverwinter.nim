// the PC has at least 1 level Monk

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass(CLASS_TYPE_MONK, GetPCSpeaker()) > 0;
    return iResult;
}
