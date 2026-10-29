// the PC has at least 1 level Druid

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) > 0;
    return iResult;
}
