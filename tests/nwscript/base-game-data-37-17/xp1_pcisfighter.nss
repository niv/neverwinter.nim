// the PC has at least 1 level Fighter

int StartingConditional()
{
    int iResult;

    iResult = GetLevelByClass(CLASS_TYPE_FIGHTER, GetPCSpeaker()) > 0;
    return iResult;
}
