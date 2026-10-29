int StartingConditional()
{
    int iResult;
    iResult = GetLocalInt(GetPCSpeaker(),"X2_CI_CRAFT_NOOFITEMS")<1;   // no items read from 2da
    iResult  = iResult & (GetLocalInt(GetPCSpeaker(),"X2_CI_CRAFT_SKILL") == 25); // Is armor crafting
    return iResult;
}
