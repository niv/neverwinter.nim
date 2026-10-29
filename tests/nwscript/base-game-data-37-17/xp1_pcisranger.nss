// the PC has at least 1 level Ranger

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) > 0;
    return iResult;
}
