// the PC is a fighting class

int StartingConditional()
{
    int nClass1 = GetLevelByClass(CLASS_TYPE_BARBARIAN, GetPCSpeaker());
    int nClass2 = GetLevelByClass(CLASS_TYPE_FIGHTER, GetPCSpeaker());
    int nClass3 = GetLevelByClass(CLASS_TYPE_MONK, GetPCSpeaker());
    int nClass4 = GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker());

    if ((nClass1 > 0) || (nClass2 > 0) || (nClass3 > 0) || (nClass4 > 0))
    {
        return TRUE;
    }
    return FALSE;
}
