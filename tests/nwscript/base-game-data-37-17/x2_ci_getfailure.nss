int StartingConditional()
{
    int iResult;

    iResult = (GetLocalInt(GetPCSpeaker(),"X2_CRAFT_SUCCESS") ==0);
    return iResult;
}
