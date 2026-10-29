int StartingConditional()
{
    int iGender = GetGender(GetPCSpeaker());
    if (iGender != GENDER_MALE)
    {
        return TRUE;
    }
    return FALSE;
}
