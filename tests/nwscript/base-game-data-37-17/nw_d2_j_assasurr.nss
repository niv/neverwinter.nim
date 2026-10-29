int StartingConditional()
{
    int iResult = GetLocalInt(OBJECT_SELF, "Generic_Surrender");
    if(iResult == 1 && !GetIsObjectValid(GetPCSpeaker()))
    {
        SetLocalInt(OBJECT_SELF, "Generic_Surrender", 2);
        return TRUE;
    }

    return FALSE;
}


