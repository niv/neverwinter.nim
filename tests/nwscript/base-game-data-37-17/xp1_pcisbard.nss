// the PC has at least 1 level Bard

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass(CLASS_TYPE_BARD, GetPCSpeaker()) > 0;
    return iResult;
}
