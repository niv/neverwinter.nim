// if the PC has any Harper levels

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass(CLASS_TYPE_HARPER, GetPCSpeaker()) > 0;
    return iResult;
}
