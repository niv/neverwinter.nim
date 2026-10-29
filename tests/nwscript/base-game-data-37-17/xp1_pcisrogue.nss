// the PC has at least 1 level Rogue

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass(CLASS_TYPE_ROGUE, GetPCSpeaker()) > 0;
    return iResult;
}
