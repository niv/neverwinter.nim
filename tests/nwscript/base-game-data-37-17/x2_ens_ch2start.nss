int StartingConditional()
{
    int iResult;

    iResult = (GetLocalInt(GetPCSpeaker(),"X2_L_ENSERRIC_ASKED_Q3") == 2);
    return iResult;
}
