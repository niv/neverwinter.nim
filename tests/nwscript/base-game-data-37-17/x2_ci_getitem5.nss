int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetPCSpeaker(),"X2_CI_CRAFT_NOOFITEMS")>4;
    return iResult;
}
